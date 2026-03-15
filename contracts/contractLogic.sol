// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

abstract contract HcoinLogic is ERC20PermitUpgradeable, OwnableUpgradeable, PausableUpgradeable {


    // ERC通用ABI
    function __HcoinLogic_init() internal onlyInitializing {

        __Pausable_init();
        
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(address(this), amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function version() external pure returns (string memory) {
        return "v1.0.0";
    }

    // 合约水龙头
    mapping (address => uint256) private lastClaimTime;

    uint256 claimTokenLimit = 0;

    event Claimed(address indexed user, uint256 amount);

    function setClaimTokensLimit(uint256 limit) external onlyOwner {
        require(limit > 0, "Limit must bigger than 0");
        claimTokenLimit = limit;
    }

    function claim() external {
        require(claimTokenLimit > 0, "Water faucet was paused");
        require(block.timestamp - lastClaimTime[msg.sender] > 24 hours, "You can only claim once every 24 hours");
        require(balanceOf(address(this)) >= claimTokenLimit, "Not enough balance about contract");
        _transfer(address(this), msg.sender, claimTokenLimit);
        lastClaimTime[msg.sender] = block.timestamp;
    }

}
