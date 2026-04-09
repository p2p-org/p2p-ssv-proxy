// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.24;

import {ISSVNetworkCore} from "./ISSVNetworkCore.sol";

/// @dev ETH-era SSV cluster interface. Functions use msg.value instead of an explicit amount parameter.
/// Based on the SSV Network ETH payment upgrade ABI.
interface ISSVClustersEth is ISSVNetworkCore {
    /// @notice Registers a new validator on the SSV Network (ETH payment)
    /// @param publicKey The public key of the new validator
    /// @param operatorIds Array of IDs of operators managing this validator
    /// @param sharesData Encrypted shares related to the new validator
    /// @param cluster Cluster to be used with the new validator
    function registerValidator(
        bytes calldata publicKey,
        uint64[] memory operatorIds,
        bytes calldata sharesData,
        Cluster memory cluster
    ) external payable;

    /// @notice Registers new validators on the SSV Network (ETH payment)
    /// @param publicKeys The public keys of the new validators
    /// @param operatorIds Array of IDs of operators managing this validator
    /// @param sharesData Encrypted shares related to the new validators
    /// @param cluster Cluster to be used with the new validators
    function bulkRegisterValidator(
        bytes[] calldata publicKeys,
        uint64[] memory operatorIds,
        bytes[] calldata sharesData,
        Cluster memory cluster
    ) external payable;

    /// @notice Deposits ETH into a cluster
    /// @param clusterOwner The owner of the cluster
    /// @param operatorIds Array of IDs of operators managing the cluster
    /// @param cluster Cluster where the deposit will be made
    function deposit(
        address clusterOwner,
        uint64[] memory operatorIds,
        Cluster memory cluster
    ) external payable;

    /// @notice Reactivates a cluster (ETH payment)
    /// @param operatorIds Array of IDs of operators managing the cluster
    /// @param cluster Cluster to be reactivated
    function reactivate(
        uint64[] memory operatorIds,
        Cluster memory cluster
    ) external payable;

    /// @notice Migrates an SSV-based cluster to ETH payments
    /// @dev Returns any existing SSV balance to the owner and accepts ETH via msg.value.
    /// Reverts if the provided ETH balance is insufficient (cluster would be immediately liquidatable).
    /// @param operatorIds Array of IDs of operators managing the cluster
    /// @param cluster Cluster to be migrated
    function migrateClusterToETH(
        uint64[] memory operatorIds,
        Cluster memory cluster
    ) external payable;

    /// @notice Liquidates a legacy SSV-payment cluster (post-upgrade)
    /// @param owner The owner of the cluster
    /// @param operatorIds Array of IDs of operators managing the cluster
    /// @param cluster Cluster to be liquidated
    function liquidateSSV(
        address owner,
        uint64[] memory operatorIds,
        Cluster memory cluster
    ) external;

    /**
     * @dev Emitted when a cluster is migrated from SSV to ETH payments.
     * @param owner The owner of the migrated cluster.
     * @param operatorIds The operator IDs managing the cluster.
     * @param ethDeposited The amount of ETH deposited as the new cluster balance.
     * @param ssvRefunded The amount of SSV tokens refunded to the owner.
     * @param effectiveBalance The effective balance of the cluster after migration.
     * @param cluster The cluster data after migration.
     */
    event ClusterMigratedToETH(
        address indexed owner,
        uint64[] operatorIds,
        uint256 ethDeposited,
        uint256 ssvRefunded,
        uint32 effectiveBalance,
        Cluster cluster
    );
}
