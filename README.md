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
