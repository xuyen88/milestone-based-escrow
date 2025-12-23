// SPDX-License-Identifier: MIT
pragma uint256;
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MilestoneBasedEscrow
 * @dev Hợp đồng giải ngân theo tiến độ để chứng minh tư duy quản lý dự án Web3.
 */
contract MilestoneBasedEscrow is ReentrancyGuard, Ownable {
    
    struct Milestone {
        string description;
        uint256 amount;
        bool isCompleted;
        bool isApproved;
    }

    address public developer;
    address public assessor; // Người đánh giá tiến độ (Chính là vai trò bạn ứng tuyển)
    uint256 public totalMilestones;
    uint256 public currentMilestone;

    mapping(uint256 => Milestone) public milestones;

    event MilestoneApproved(uint256 milestoneId);
    event FundsReleased(uint256 amount);

    constructor(address _developer, address _assessor) Ownable(msg.sender) {
        developer = _developer;
        assessor = _assessor;
    }

    // Investor (Owner) nạp tiền và thiết lập tiến độ
    function addMilestone(string memory _description, uint256 _amount) external onlyOwner {
        milestones[totalMilestones] = Milestone(_description, _amount, false, false);
        totalMilestones++;
    }

    // Developer báo cáo đã xong
    function completeMilestone(uint256 _id) external {
        require(msg.sender == developer, "Only developer can call");
        milestones[_id].isCompleted = true;
    }

    // Assessor (Bạn) kiểm tra và phê duyệt dựa trên bằng chứng kỹ thuật (GitHub PR/Audit)
    function approveMilestone(uint256 _id) external nonReentrant {
        require(msg.sender == assessor, "Only assessor can approve");
        require(milestones[_id].isCompleted, "Milestone not marked as completed");
        require(!milestones[_id].isApproved, "Already approved");

        milestones[_id].isApproved = true;
        uint256 amountToRelease = milestones[_id].amount;
        
        require(address(this).balance >= amountToRelease, "Insufficient contract balance");
        
        (bool success, ) = developer.call{value: amountToRelease}("");
        require(success, "Transfer failed");

        emit MilestoneApproved(_id);
        emit FundsReleased(amountToRelease);
        currentMilestone++;
    }

    receive() external payable {}
}
