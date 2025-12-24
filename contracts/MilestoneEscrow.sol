// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MilestoneEscrow is ReentrancyGuard {
    address public assessor;
    address payable public developer;
    bool public isPaused; // Trạng thái khẩn cấp

    modifier onlyAssessor() {
        require(msg.sender == assessor, "Only Assessor can call this");
        _;
    }

    constructor(address _assessor, address payable _developer) {
        assessor = _assessor;
        developer = _developer;
    }

    // NÂNG CẤP 1: Hàm phê duyệt sử dụng .call thay vì .transfer để tối ưu gas
    function approveMilestone(uint256 _amount) external onlyAssessor nonReentrant {
        require(!isPaused, "Contract is paused");
        require(address(this).balance >= _amount, "Insufficient balance");
        
        (bool success, ) = developer.call{value: _amount}("");
        require(success, "Transfer failed");
    }

    // NÂNG CẤP 2: Cơ chế dừng khẩn cấp (Circuit Breaker)
    function togglePause() external onlyAssessor {
        isPaused = !isPaused;
    }

    // NÂNG CẤP 3: Rút tiền khẩn cấp về ví dự phòng (Emergency Withdraw)
    function emergencyWithdraw() external onlyAssessor {
        require(isPaused, "Contract must be paused first");
        uint256 balance = address(this).balance;
        (bool success, ) = payable(assessor).call{value: balance}("");
        require(success, "Emergency withdrawal failed");
    }

    receive() external payable {}
}
