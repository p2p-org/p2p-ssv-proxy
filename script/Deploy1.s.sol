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

        address[] memory allowedSsvOperatorOwners = new address[](4);
        allowedSsvOperatorOwners[0] = 0x95b3D923060b7E6444d7C3F0FCb01e6F37F4c418;
        allowedSsvOperatorOwners[1] = 0xfeC26f2bC35420b4fcA1203EcDf689a6e2310363;
        allowedSsvOperatorOwners[2] = 0x47659cc5fB8CDC58bD68fEB8C78A8e19549d39C5;
        allowedSsvOperatorOwners[3] = 0x9a792B1588882780Bed412796337E0909e51fAB7;

        P2pSsvProxyFactory p2pSsvProxyFactory = P2pSsvProxyFactory(0x5ed861aec31cCB496689FD2E0A1a3F8e8D7B8824);

        vm.startBroadcast(deployerKey);

        p2pSsvProxyFactory.setAllowedSsvOperatorOwners(allowedSsvOperatorOwners);

        p2pSsvProxyFactory.setSsvOperatorIds([uint64(195),196,197,212,213,214,350,351,361,362,363,364,377,378,379,380,1033,1162,0,0,0,0,0,0], allowedSsvOperatorOwners[0]);
        p2pSsvProxyFactory.setSsvOperatorIds([uint64(192),193,194,209,210,211,348,349,357,358,359,360,373,374,375,376,1032,1161,0,0,0,0,0,0], allowedSsvOperatorOwners[1]);
        p2pSsvProxyFactory.setSsvOperatorIds([uint64(198),199,200,215,216,217,352,353,365,366,367,368,381,382,383,384,1034,1163,0,0,0,0,0,0], allowedSsvOperatorOwners[2]);
        p2pSsvProxyFactory.setSsvOperatorIds([uint64(201),202,203,218,219,220,354,355,369,370,371,372,385,386,387,388,1035,1164,0,0,0,0,0,0], allowedSsvOperatorOwners[3]);


        p2pSsvProxyFactory.changeOperator(0x18fB2400e61b623c3fc55b212c9022B44EdD1c18);
        p2pSsvProxyFactory.transferOwnership(0xbc1Ff75c84724Fe6377e0FDD13cd0f59C156e864);


        // P2pSsvProxy referenceP2pSsvProxy = new P2pSsvProxy(address(p2pSsvProxyFactory));
        // p2pSsvProxyFactory.setReferenceP2pSsvProxy(address(referenceP2pSsvProxy));

        // IChangeOperator(address(feeDistributorFactory)).changeOperator(address(p2pSsvProxyFactory));

//        p2pSsvProxyFactory.setSsvPerEthExchangeRateDividedByWei(uint112(vm.envUint("EXCHANGE_RATE")));
//        p2pSsvProxyFactory.setMaxSsvTokenAmountPerValidator(uint112(vm.envUint("MAX_SSV_TOKEN_AMOUNT_PER_VALIDATOR")));

        vm.stopBroadcast();
    }
}
