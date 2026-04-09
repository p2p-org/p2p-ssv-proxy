// SPDX-FileCopyrightText: 2026 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "../@openzeppelin/contracts/proxy/beacon/IBeacon.sol";
import "../@openzeppelin/contracts/utils/Address.sol";
import "../access/Ownable2Step.sol";

error P2pUpgradeableBeacon__ImplementationIsNotAContract(address implementation);
error P2pUpgradeableBeacon__ZeroOwnerAddress();

/// @title Upgradeable Beacon for P2pSsvProxy fleet
/// @dev Minimal beacon with 2-step ownership transfer. The owner can upgrade
/// the implementation for all P2pBeaconProxy instances that reference this beacon.
contract P2pUpgradeableBeacon is Ownable2Step, IBeacon {
    address private s_implementation;

    /// @dev Emitted when the implementation is upgraded.
    event P2pUpgradeableBeacon__Upgraded(address indexed implementation);

    /// @notice Deploy the beacon with an initial implementation and owner.
    /// @param implementation_ The initial implementation contract address
    /// @param owner_ The owner who can call upgradeTo
    constructor(address implementation_, address owner_) {
        if (!Address.isContract(implementation_)) revert P2pUpgradeableBeacon__ImplementationIsNotAContract(implementation_);
        if (owner_ == address(0)) revert P2pUpgradeableBeacon__ZeroOwnerAddress();
        s_implementation = implementation_;
        if (owner_ != _msgSender()) {
            _transferOwnership(owner_);
        }
        emit P2pUpgradeableBeacon__Upgraded(implementation_);
    }

    /// @inheritdoc IBeacon
    function implementation() public view override returns (address) {
        return s_implementation;
    }

    /// @notice Upgrade the beacon to a new implementation.
    /// @param newImplementation The new implementation contract address
    function upgradeTo(address newImplementation) public onlyOwner {
        if (!Address.isContract(newImplementation)) revert P2pUpgradeableBeacon__ImplementationIsNotAContract(newImplementation);
        s_implementation = newImplementation;
        emit P2pUpgradeableBeacon__Upgraded(newImplementation);
    }

}
