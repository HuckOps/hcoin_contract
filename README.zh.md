# 📘 Hcoin 数字存证合约

[English](./README.md) | [简体中文](./README.zh.md)

Hcoin 是一个可升级的 ERC20 代币合约，内置“数字存证”功能，允许用户通过支付代币将任意数据哈希与唯一标识符（UUID）上链存证，确保数据真实性和不可篡改性。

---

## 🧩 功能简介

### 🔹 ERC20 代币功能

- 基于 OpenZeppelin 的 `ERC20Upgradeable` 与 `ERC20PermitUpgradeable`
- 支持代币的铸造（`mint`）、销毁（`burn`）与暂停（`pause`）
- 支持通过 `permit` 实现 Gasless 授权（符合 EIP-2612）
- 支持 UUPS 升级机制（不需重新部署即可升级逻辑）

### 🔹 数字存证功能

- 允许用户通过 `submitEvidence` 提交一条带有 UUID 的哈希
- 存证需支付一定数量的代币（由合约设置）
- 存证信息包括：UUID、哈希、提交者地址、时间戳
- 可通过 `getEvidence` 查询已存证信息

---

## 📚 数据结构

```solidity
struct Evidence {
  bytes16 EvidenceUUID; // UUID
  string DataHash;      // 原始数据哈希
  address Owner;        // 提交者地址
  uint256 Timestamp;    // 区块时间戳
}
```

---

## 🚀 合约方法

| 方法名 | 说明 |
|--------|------|
| `mint(address to, uint256 amount)` | 由合约所有者铸造代币给用户 |
| `burn(uint256 amount)` | 用户销毁自己的代币 |
| `pause()` / `unpause()` | 暂停或恢复合约 |
| `setEvidenceFee(uint256 fee)` | 设置提交存证的代币费用（≥10） |
| `submitEvidence(bytes16 uuid, string calldata hash)` | 用户提交一条数字存证，扣除费用 |
| `getEvidence(bytes16 uuid)` | 查询指定 UUID 的存证信息 |
| `version()` | 获取当前合约版本号 |

---

## 📢 事件说明

```solidity
event EvidenceSubmitted(
  bytes16 indexed evidenceUUID,
  string indexed dataHash,
  address indexed owner
);
```

> 当用户成功提交一条存证时触发此事件，方便链上监听与验证。

---

## 🛡️ 权限控制

- 仅 `owner` 可设置费用、暂停或铸币
- 所有用户都可提交和查询存证

---

## 📌 应用场景

- 数字版权登记（如图片、文章、代码）
- 合同签署留痕
- 区块链司法/仲裁证据存档
- 学术成果公开存证

---

## 📦 技术栈

- Solidity ^0.8.20
- OpenZeppelin Contracts Upgradeable
- ERC20 / ERC20Permit / Ownable / Pausable / UUPSUpgradeable
