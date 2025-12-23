const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MilestoneBasedEscrow", function () {
  it("Should release funds only after Assessor approval", async function () {
    const [owner, dev, assessor] = await ethers.getSigners();
    
    const Escrow = await ethers.getContractFactory("MilestoneBasedEscrow");
    const escrow = await Escrow.deploy(dev.address, assessor.address);

    // Nạp 1 ETH vào contract
    await owner.sendTransaction({ to: escrow.target, value: ethers.parseEther("1.0") });

    // Thêm milestone
    await escrow.addMilestone("Xây dựng Smart Contract Core", ethers.parseEther("1.0"));

    // Dev báo xong
    await escrow.connect(dev).completeMilestone(0);

    // Assessor phê duyệt -> Tiền về ví Dev
    await expect(() => escrow.connect(assessor).approveMilestone(0))
      .to.changeEtherBalances([escrow, dev], [ethers.parseEther("-1.0"), ethers.parseEther("1.0")]);
  });
});
