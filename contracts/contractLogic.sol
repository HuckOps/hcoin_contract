// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

abstract contract HcoinLogic is ERC20PermitUpgradeable, OwnableUpgradeable, PausableUpgradeable {
    

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    // ERC通用ABI
    function __HcoinLogic_init() internal onlyInitializing {

        __Pausable_init();
        
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
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

    // 存证合约
    uint256 public EvidenceFee;

    struct Evidence {
        bytes16 EvidenceUUID;
        string DataHash;
        address Owner; 
        uint256 Timestamp;
    }

    event EvidenceSubmitted(bytes16 indexed evidenceUUID, string indexed dataHash, address indexed owner);

    mapping (bytes16 => Evidence) private evidence;

    function setEvidenceFee (uint256 fee) external onlyOwner {
        require(fee >= 10, "Fee cannot be negative");
        EvidenceFee = fee;
    }

    function submitEvidence (bytes16 evidenceUUID, string calldata hash) external {
        require(EvidenceFee > 0, "Evidence was paused");
        require(evidenceUUID != 0x0, "Evidence UUID must not zero");
        require(balanceOf(msg.sender) >= EvidenceFee, "Insufficient balance");
        require((evidence[evidenceUUID].EvidenceUUID).length == 0, "Evidence already exists");
        require(keccak256(abi.encodePacked(hash)) != keccak256(abi.encodePacked("")), "Hash must not be empty");


        evidence[evidenceUUID] = Evidence({
            EvidenceUUID: evidenceUUID,
            DataHash: hash,
            Owner: msg.sender,
            Timestamp: block.timestamp
        });
        _transfer(msg.sender, address(this), EvidenceFee);
        emit EvidenceSubmitted(evidenceUUID, hash, msg.sender);
    }

    function getEvidence (bytes16 evidenceUUID) external view returns (Evidence memory) {
        return evidence[evidenceUUID];
    }

}
