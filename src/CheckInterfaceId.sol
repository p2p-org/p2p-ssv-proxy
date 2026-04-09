// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import "src/p2pSsvProxy/IP2pSsvProxy.sol";
import "src/p2pSsvProxyFactory/IP2pSsvProxyFactory.sol";
contract CheckInterfaceId {
    function getProxyInterfaceId() external pure returns (bytes4) {
        return type(IP2pSsvProxy).interfaceId;
    }
    function getFactoryInterfaceId() external pure returns (bytes4) {
        return type(IP2pSsvProxyFactory).interfaceId;
    }
}
