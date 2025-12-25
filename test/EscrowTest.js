import pkg from 'hardhat';
const { ethers } = pkg;
import { expect } from 'chai';

describe("MilestoneEscrow Security & Logic", function () {
    let Escrow, escrow, owner, dev, assessor, otherAccount;

    beforeEach(async function () {
        // Lấy danh sách ví giả lập từ Hardhat
        [owner, dev, assessor, otherAccount] = await ethers.getSigners();
        
        // Giả lập việc triển khai Smart Contract MilestoneEscrow
        Escrow = await ethers.getContractFactory("MilestoneEscrow");
        escrow = await Escrow.deploy(assessor.address, dev.address);
    });

    it("Should prevent unauthorized users from approving funds", async function () {
        // Kịch bản: Ví lạ (otherAccount) cố gắng giải ngân 1.0 ETH/ADA
        await expect(escrow.connect(otherAccount).approveMilestone(ethers.parseUnits("1.0", "ether")))
            .to.be.revertedWith("Only Assessor can call this");
    });

    it("Should allow emergency withdraw only when paused", async function () {
        // 1. Nạp tiền giả lập vào hợp đồng
        await owner.sendTransaction({ to: await escrow.getAddress(), value: ethers.parseUnits("1.0", "ether") });

        // 2. Thử rút khẩn cấp khi chưa Pause (Phải bị từ chối)
        await expect(escrow.connect(assessor).emergencyWithdraw())
            .to.be.revertedWith("Contract must be paused first");

        // 3. Kích hoạt Pause và rút (Phải thành công)
        await escrow.connect(assessor).togglePause();
        await expect(escrow.connect(assessor).emergencyWithdraw())
            .to.changeEtherBalances([escrow, assessor], [ethers.parseUnits("-1.0", "ether"), ethers.parseUnits("1.0", "ether")]);
    });
});
