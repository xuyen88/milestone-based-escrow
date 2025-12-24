const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MilestoneEscrow Security & Logic", function () {
    let Escrow, escrow, owner, dev, assessor, otherAccount;

    beforeEach(async function () {
        [owner, dev, assessor, otherAccount] = await ethers.getSigners();
        Escrow = await ethers.getContractFactory("MilestoneEscrow");
        // Triển khai với địa chỉ Assessor và Developer
        escrow = await Escrow.deploy(assessor.address, dev.address);
    });

    it("Should prevent unauthorized users from approving funds", async function () {
        // Kịch bản: Một ví lạ cố tình gọi hàm giải ngân
        // Kết quả mong đợi: Giao dịch phải bị từ chối (Revert)
        await expect(escrow.connect(otherAccount).approveMilestone(ethers.parseEther("1.0")))
            .to.be.revertedWith("Only Assessor can call this");
    });

    it("Should allow emergency withdraw only when paused", async function () {
        // 1. Nạp tiền vào hợp đồng
        await owner.sendTransaction({ to: escrow.target, value: ethers.parseEther("1.0") });

        // 2. Thử rút khẩn cấp khi chưa Pause (Phải thất bại)
        await expect(escrow.connect(assessor).emergencyWithdraw())
            .to.be.revertedWith("Contract must be paused first");

        // 3. Pause hợp đồng và rút (Phải thành công)
        await escrow.connect(assessor).togglePause();
        await expect(escrow.connect(assessor).emergencyWithdraw())
            .to.changeEtherBalances([escrow, assessor], [ethers.parseEther("-1.0"), ethers.parseEther("1.0")]);
    });
});
