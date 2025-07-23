# 📘 Hcoin Digital Evidence Smart Contract

[English](./README.md) | [简体中文](./README.zh.md)

Hcoin is an upgradeable ERC20 token contract with built-in **digital evidence functionality**, enabling users to submit immutable data hashes associated with unique UUIDs by paying a fixed token fee.

---

## 🧩 Features

### 🔹 ERC20 Token

- Based on OpenZeppelin's `ERC20Upgradeable` and `ERC20PermitUpgradeable`
- Supports minting (`mint`), burning (`burn`), pausing (`pause`)
- Enables gasless approvals via EIP-2612 `permit`
- Upgradeable using UUPS proxy (data-safe logic upgrades)

### 🔹 Digital Evidence Module

- Users can submit a hash string and a UUID using `submitEvidence`
- A small fee in Hcoin is required per submission
- Each record stores: UUID, hash, sender address, timestamp
- Query via `getEvidence(bytes16 uuid)`

---

## 📚 Data Structure

```solidity
struct Evidence {
  bytes16 EvidenceUUID; // UUID
  string DataHash;      // Hash of original data
  address Owner;        // Sender address
  uint256 Timestamp;    // Submission time
}
```

---

## 🚀 Public Functions

| Function | Description |
|----------|-------------|
| `mint(address to, uint256 amount)` | Mint tokens to a specified address (onlyOwner) |
| `burn(uint256 amount)` | Burn caller’s own tokens |
| `pause()` / `unpause()` | Pause/unpause contract actions (onlyOwner) |
| `setEvidenceFee(uint256 fee)` | Set the token fee for submitting evidence (minimum 10) |
| `submitEvidence(bytes16 uuid, string calldata hash)` | Submit an evidence record (fee deducted) |
| `getEvidence(bytes16 uuid)` | Retrieve on-chain evidence info by UUID |
| `version()` | Returns contract version string |

---

## 📢 Events

```solidity
event EvidenceSubmitted(
  bytes16 indexed evidenceUUID,
  string indexed dataHash,
  address indexed owner
);
```

> Emitted whenever a user successfully submits a piece of digital evidence.

---

## 🛡️ Access Control

- Only the `owner` can mint tokens, pause the contract, or update the fee
- Anyone can submit and retrieve evidence

---

## 📌 Use Cases

- Digital copyright notarization (images, code, content)
- Blockchain timestamping of contracts or agreements
- Legal or arbitration evidence records
- Scientific or academic disclosure

---

## 📦 Technology Stack

- Solidity ^0.8.20
- OpenZeppelin Contracts Upgradeable
- ERC20 / ERC20Permit / Ownable / Pausable / UUPSUpgradeable
