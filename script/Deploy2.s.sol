// SPDX-FileCopyrightText: 2024 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import "../src/p2pSsvProxyFactory/P2pSsvProxyFactory.sol";
import "../src/mocks/IChangeOperator.sol";

contract Deploy is Script {

    function run() external {
        address p2pOrgUnlimitedEthDepositor = vm.envAddress("P2P_ORG_UNLIMITED_ETH_DEPOSITOR");
        address feeDistributorFactory = vm.envAddress("FEE_DISTRIBUTOR_FACTORY");
        address referenceFeeDistributor = vm.envAddress("REFERENCE_FEE_DISTRIBUTOR");

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        P2pSsvProxyFactory p2pSsvProxyFactoryOLD = P2pSsvProxyFactory(0xBde84973e73E8DB7e808dF420098D4f4936018b1);

        address[] memory allowedSsvOperatorOwners = p2pSsvProxyFactoryOLD.getAllowedSsvOperatorOwners();

        uint64[24] memory ids0 = p2pSsvProxyFactoryOLD.getAllowedSsvOperatorIds(allowedSsvOperatorOwners[0]);
        uint64[24] memory ids1 = p2pSsvProxyFactoryOLD.getAllowedSsvOperatorIds(allowedSsvOperatorOwners[1]);
        uint64[24] memory ids2 = p2pSsvProxyFactoryOLD.getAllowedSsvOperatorIds(allowedSsvOperatorOwners[2]);
        uint64[24] memory ids3 = p2pSsvProxyFactoryOLD.getAllowedSsvOperatorIds(allowedSsvOperatorOwners[3]);

        P2pSsvProxyFactory p2pSsvProxyFactory = P2pSsvProxyFactory(0x91234ffd7D65Aa5E4fDA60a2e7B9513175df3272);

        vm.startBroadcast(deployerKey);

        p2pSsvProxyFactory.setAllowedSsvOperatorOwners(allowedSsvOperatorOwners);

        p2pSsvProxyFactory.setSsvOperatorIds(ids0, allowedSsvOperatorOwners[0]);
        p2pSsvProxyFactory.setSsvOperatorIds(ids1, allowedSsvOperatorOwners[1]);
        p2pSsvProxyFactory.setSsvOperatorIds(ids2, allowedSsvOperatorOwners[2]);
        p2pSsvProxyFactory.setSsvOperatorIds(ids3, allowedSsvOperatorOwners[3]);


        p2pSsvProxyFactory.changeOperator(0x4f47434254eE1fD315Dc49df987cFF7db2F12eb6);
        // p2pSsvProxyFactory.transferOwnership(0xCbf5aA4606202161D879929a0C1AE694c644a45E);


        // P2pSsvProxy referenceP2pSsvProxy = new P2pSsvProxy(address(p2pSsvProxyFactory));
        // p2pSsvProxyFactory.setReferenceP2pSsvProxy(address(referenceP2pSsvProxy));

        // IChangeOperator(address(feeDistributorFactory)).changeOperator(address(p2pSsvProxyFactory));

//        p2pSsvProxyFactory.setSsvPerEthExchangeRateDividedByWei(uint112(vm.envUint("EXCHANGE_RATE")));
//        p2pSsvProxyFactory.setMaxSsvTokenAmountPerValidator(uint112(vm.envUint("MAX_SSV_TOKEN_AMOUNT_PER_VALIDATOR")));

        vm.stopBroadcast();
    }
}
