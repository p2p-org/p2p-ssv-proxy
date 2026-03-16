// SPDX-FileCopyrightText: 2024 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import "../src/p2pSsvProxy/P2pSsvProxy.sol";
import "../src/proxy/P2pUpgradeableBeacon.sol";

contract Upgrade is Script {
    function run() external {
        P2pUpgradeableBeacon beacon = P2pUpgradeableBeacon(vm.envAddress("BEACON_ADDRESS"));
        address oldImpl = beacon.implementation();

        vm.startBroadcast();
        P2pSsvProxy newImpl = new P2pSsvProxy();
        beacon.upgradeTo(address(newImpl));
        vm.stopBroadcast();

        console.log("Old implementation:", oldImpl);
        console.log("New implementation:", address(newImpl));
    }
}