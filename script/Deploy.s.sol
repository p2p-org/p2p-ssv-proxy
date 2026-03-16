// SPDX-FileCopyrightText: 2024 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import "../src/p2pSsvProxyFactory/P2pSsvProxyFactory.sol";
import "../src/proxy/P2pUpgradeableBeacon.sol";
import "../src/constants/P2pConstants.sol";
import "../src/access/IOwnable.sol";
import "../src/mocks/IChangeOperator.sol";

contract Deploy is Script {
    function run() external returns (
        P2pSsvProxyFactory,
        P2pSsvProxy,
        P2pUpgradeableBeacon
    ) {
        address p2pOrgUnlimitedEthDepositor = vm.envAddress("P2P_ORG_UNLIMITED_ETH_DEPOSITOR");
        address feeDistributorFactory = vm.envAddress("FEE_DISTRIBUTOR_FACTORY");
        address referenceFeeDistributor = vm.envAddress("REFERENCE_FEE_DISTRIBUTOR");
        uint112 exchangeRate = uint112(vm.envUint("SSV_PER_ETH_EXCHANGE_RATE_DIVIDED_BY_WEI"));
        uint112 maxSsv = uint112(vm.envUint("MAX_SSV_TOKEN_AMOUNT_PER_VALIDATOR"));
        address factoryOperator = vm.envOr("FACTORY_OPERATOR", address(0));
        address factoryOwner = vm.envOr("FACTORY_OWNER", address(0));
        uint256 ownerCount = vm.envOr("OPERATOR_OWNER_COUNT", uint256(0));

        vm.startBroadcast();

        P2pSsvProxyFactory p2pSsvProxyFactory = new P2pSsvProxyFactory(
            p2pOrgUnlimitedEthDepositor,
            feeDistributorFactory,
            referenceFeeDistributor
        );
        P2pSsvProxy referenceP2pSsvProxy = new P2pSsvProxy();
        P2pUpgradeableBeacon beacon = new P2pUpgradeableBeacon(address(referenceP2pSsvProxy), msg.sender);
        p2pSsvProxyFactory.setBeacon(address(beacon));

        bool fdHandoffDone;
        if (IOwnable(feeDistributorFactory).owner() == msg.sender) {
            IChangeOperator(feeDistributorFactory).changeOperator(address(p2pSsvProxyFactory));
            fdHandoffDone = true;
        }

        if (exchangeRate > 0) {
            p2pSsvProxyFactory.setSsvPerEthExchangeRateDividedByWei(exchangeRate);
        }
        if (maxSsv > 0) {
            p2pSsvProxyFactory.setMaxSsvTokenAmountPerValidator(maxSsv);
        }

        if (ownerCount > 0) {
            address[] memory owners = new address[](ownerCount);
            for (uint256 i = 0; i < ownerCount; i++) {
                owners[i] = vm.envAddress(string.concat("ALLOWED_OPERATOR_OWNER_", vm.toString(i + 1)));
            }
            p2pSsvProxyFactory.setAllowedSsvOperatorOwners(owners);

            for (uint256 i = 0; i < ownerCount; i++) {
                uint64[MAX_ALLOWED_SSV_OPERATOR_IDS] memory ids;
                bool hasIds;
                for (uint256 j = 0; j < MAX_ALLOWED_SSV_OPERATOR_IDS; j++) {
                    ids[j] = uint64(vm.envOr(
                        string.concat("OPERATOR_IDS_", vm.toString(i + 1), "_", vm.toString(j + 1)),
                        uint256(0)
                    ));
                    if (ids[j] != 0) hasIds = true;
                }
                if (hasIds) {
                    p2pSsvProxyFactory.setSsvOperatorIds(ids, owners[i]);
                }
            }
        }

        if (factoryOperator != address(0)) {
            p2pSsvProxyFactory.changeOperator(factoryOperator);
        }

        if (factoryOwner != address(0) && factoryOwner != msg.sender) {
            p2pSsvProxyFactory.transferOwnership(factoryOwner);
            beacon.transferOwnership(factoryOwner);
        }

        vm.stopBroadcast();

        console.log("P2pSsvProxyFactory:", address(p2pSsvProxyFactory));
        console.log("P2pSsvProxy (impl):", address(referenceP2pSsvProxy));
        console.log("P2pUpgradeableBeacon:", address(beacon));

        if (!fdHandoffDone) {
            console.log("");
            console.log("ACTION REQUIRED: FeeDistributorFactory operator handoff skipped (deployer is not FD factory owner).");
            console.log("FD factory owner must call: IChangeOperator(%s).changeOperator(%s)",
                vm.toString(feeDistributorFactory), vm.toString(address(p2pSsvProxyFactory)));
        }

        if (factoryOwner != address(0) && factoryOwner != msg.sender) {
            console.log("");
            console.log("ACTION REQUIRED: Ownership transfer initiated to %s", vm.toString(factoryOwner));
            console.log("New owner must call acceptOwnership() on both:");
            console.log("  P2pSsvProxyFactory: %s", vm.toString(address(p2pSsvProxyFactory)));
            console.log("  P2pUpgradeableBeacon: %s", vm.toString(address(beacon)));
        }

        return (
            p2pSsvProxyFactory,
            referenceP2pSsvProxy,
            beacon
        );
    }
}
