// SPDX-FileCopyrightText: 2024 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import "../src/p2pSsvProxyFactory/P2pSsvProxyFactory.sol";
import "../src/constants/P2pConstants.sol";

contract PreDeploy is Script {

    function run() external view {
        // address oldFactoryAddr = 0x2444fae9394deBF503775940AF2a3e9364A31e34; // Hoodi Dev
        address oldFactoryAddr = 0x91234ffd7D65Aa5E4fDA60a2e7B9513175df3272; // Hoodi Prod
        // address oldFactoryAddr = 0x5ed861aec31CCB496689fD2e0A1a3F8E8D7b8824; // Mainnet

        P2pSsvProxyFactory oldFactory = P2pSsvProxyFactory(payable(oldFactoryAddr));

        address fdFactory = oldFactory.getFeeDistributorFactory();
        address refFD = oldFactory.getReferenceFeeDistributor();
        address factoryOperator = oldFactory.operator();
        address factoryOwner = oldFactory.owner();
        uint112 exchangeRate = oldFactory.getSsvPerEthExchangeRateDividedByWei();
        uint112 maxSsv = oldFactory.getMaxSsvTokenAmountPerValidator();
        address[] memory owners = oldFactory.getAllowedSsvOperatorOwners();

        console.log("# --- Copy below into your .env file ---");
        console.log("");

        console.log("FEE_DISTRIBUTOR_FACTORY=%s", vm.toString(fdFactory));
        console.log("REFERENCE_FEE_DISTRIBUTOR=%s", vm.toString(refFD));
        console.log("SSV_PER_ETH_EXCHANGE_RATE_DIVIDED_BY_WEI=%s", vm.toString(uint256(exchangeRate)));
        console.log("MAX_SSV_TOKEN_AMOUNT_PER_VALIDATOR=%s", vm.toString(uint256(maxSsv)));
        console.log("FACTORY_OPERATOR=%s", vm.toString(factoryOperator));
        console.log("FACTORY_OWNER=%s", vm.toString(factoryOwner));
        console.log("");

        console.log("OPERATOR_OWNER_COUNT=%s", vm.toString(owners.length));
        for (uint256 i = 0; i < owners.length; i++) {
            console.log("ALLOWED_OPERATOR_OWNER_%s=%s", vm.toString(i + 1), vm.toString(owners[i]));
        }
        console.log("");

        for (uint256 i = 0; i < owners.length; i++) {
            uint64[MAX_ALLOWED_SSV_OPERATOR_IDS] memory ids = oldFactory.getAllowedSsvOperatorIds(owners[i]);

            uint256 nonZero;
            for (uint256 j = 0; j < MAX_ALLOWED_SSV_OPERATOR_IDS; j++) {
                if (ids[j] != 0) nonZero++;
            }

            console.log("# Operator IDs for %s (%s non-zero)", vm.toString(owners[i]), vm.toString(nonZero));
            for (uint256 j = 0; j < MAX_ALLOWED_SSV_OPERATOR_IDS; j++) {
                console.log(
                    "OPERATOR_IDS_%s_%s=%s",
                    vm.toString(i + 1),
                    vm.toString(j + 1),
                    vm.toString(uint256(ids[j]))
                );
            }
        }

        console.log("");
        console.log("# --- End of config ---");
    }
}