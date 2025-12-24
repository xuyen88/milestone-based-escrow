// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MilestoneEscrow is ReentrancyGuard {
    address public assessor; // Người đánh giá (là bạn)
    address payable public developer;
    uint256 public currentMilestone;

    event MilestoneApproved(uint256 milestoneId, uint256 amount);

    constructor(address _assessor, address payable _developer) {
        assessor = _assessor;
        developer = _developer;
    }

    // Hàm phê duyệt giải ngân - Trọng tâm của việc đánh giá tiến độ
    function approveMilestone(uint256 _amount) external nonReentrant {
        require(msg.sender == assessor, "Only assessor can approve");
        require(address(this).balance >= _amount, "Insufficient funds");
        
        currentMilestone++;
        developer.transfer(_amount);
        
        emit MilestoneApproved(currentMilestone, _amount);
    }

    receive() external payable {} // Nhận tiền từ nhà đầu tư
}
