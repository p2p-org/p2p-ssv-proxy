// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.24;

import {ISSVClustersEth} from "./ISSVClustersEth.sol";

/// @dev Composed ETH-era SSV Network interface.
/// Points to the same SSV Network proxy address as ISSVNetwork but exposes ETH-payment signatures.
interface ISSVNetworkEth is ISSVClustersEth {
    function setFeeRecipientAddress(address feeRecipientAddress) external;
}
