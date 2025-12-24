# 🛡️ Milestone-Based Escrow Protocol
### *Decentralized Project Management & Progress Evaluation*

## 📖 Tổng quan
Dự án này là một công cụ quản lý tài chính phi tập trung. Nó giải quyết bài toán: **Làm sao để đảm bảo nhà phát triển thực hiện đúng cam kết trước khi nhận tiền?**  tôi thiết kế giao thức này để thực thi việc giải ngân dựa trên các cột mốc (milestones) kỹ thuật thực tế.

This project is a decentralized financial management tool. It solves the problem: **How ​​to ensure developers fulfill their commitments before receiving payment?** I designed this protocol to enforce disbursements based on actual technical milestones.

## 🏗️ Cấu trúc kỹ thuật   - Technical structure
- **contracts/MilestoneEscrow.sol**: Hợp đồng thông minh điều phối dòng tiền. Sử dụng các tiêu chuẩn an toàn từ OpenZeppelin.
- **test/EscrowTest.js**: Bộ kiểm thử tự động, giả lập các tình huống: nạp tiền, hoàn thành milestone và phê duyệt giải ngân.

## 🔍 Quy trình đánh giá (PM Perspective)
1. **Kiểm tra mã nguồn:** Xác thực các Pull Request trên GitHub.
2. **Xác nhận Milestone:** Chạy bộ test để đảm bảo tính năng hoạt động đúng logic.
3. **Phê duyệt (Assessor):** Thực thi hàm `approveMilestone` trên Smart Contract để giải ngân ETH cho Developer.

## 🚀 Cách kiểm tra dự án     - How to check a project
1. `npx hardhat compile`: Biên dịch hợp đồng.
2. `npx hardhat test`: Chạy bộ kiểm thử tự động.   # milestone-based-escrow

---
## 🔄 Multi-chain Architecture: EVM vs. Cardano (eUTXO)
Dự án này được thiết kế để hoạt động trên cả hai mô hình blockchain phổ biến nhất hiện nay:

### 1. Ethereum Implementation (Solidity)
- **Model:** Account-based.
- **Mechanism:** Sử dụng `State Variables` để lưu trữ tiến độ milestone.
- **Security:** Chống Reentrancy bằng `nonReentrant` modifier của OpenZeppelin.

### 2. Cardano Implementation (Aiken/Plutus)
- **Model:** eUTXO (Extended Unspent Transaction Output).
- **Mechanism:** Tiền được khóa trong một script address. Việc giải ngân dựa trên `Validator` kiểm tra chữ ký của Assessor trong `ScriptContext`.
- **Advantage:** Tính bảo mật cao hơn do mô hình eUTXO cho phép kiểm tra kết quả giao dịch trước khi thực thi (Deterministic).

> **Analyst Note:** Sự chuyển đổi này cho thấy khả năng thích nghi với các cấu trúc dữ liệu khác nhau, từ việc thay đổi trạng thái (State change) sang việc tiêu thụ đầu ra giao dịch (UTXO spending).
> ## 🌐 Multi-chain Capability (Ethereum & Cardano)
This project is architected to handle milestone payments across different blockchain models:

- **EVM Version:** Written in Solidity, focusing on state-based logic and Reentrancy protection.
- **Cardano Version:** Written in Aiken, utilizing the eUTXO model for deterministic security and validator-based approvals.

> **Technical Insight:** Moving from Solidity to Aiken allows for a more secure, formal verification-friendly environment for large-scale project funding.

**Security Features" (Đặc tính bảo mật):**

Circuit Breaker: Khả năng tạm dừng hợp đồng trong trường hợp khẩn cấp.

Emergency Fund Recovery: Cơ chế rút tiền an toàn về ví quản trị nếu có tranh chấp.

Gas Optimized: Sử dụng .call để đảm bảo tương thích với các ví hiện đại và tiết kiệm chi phí giao dịch.

Multi-chain Architecture: So sánh rõ ràng giữa mô hình Account-based (EVM) và eUTXO (Cardano).
