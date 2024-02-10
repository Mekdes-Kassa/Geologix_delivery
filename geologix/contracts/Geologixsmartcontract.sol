// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // declaring the version of solidity program 

// importing contracts 
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
//creating a contract 
contract GeoLogixSmartContract is ERC20, Ownable {
    address public employer;
    address public driver;
    uint256 public constant SALARY_AMOUNT = 0.15 ether;
    uint256 public constant REWARD_AMOUNT = 0.05 ether;
    uint256 public constant PENALIZE_AMOUNT = 0.05 ether;
    enum DriverPerformance { Excellent, Good, Average, BelowAverage, NotPerformed }
    mapping(address => DriverPerformance) public driverPerformances;
    event SalaryReleased(address indexed driver, uint256 amount);
    event RewardReleased(address indexed driver, uint256 amount);
    event PenaltyApplied(address indexed driver, uint256 amount);
    constructor()Ownable(msg.sender) ERC20("GeoLogixToken", "GLT") {
        employer = payable(0x3d3982D2C5718B6B6Ed91f0153e774f10C7fcA14);
        driver = payable(0x9065a2B36De18180E60E8115742b54116C3c7D16);
    }
    function evaluateDriver(
        int256 currentLatitude,
        int256 currentLongitude,
        uint256 timestamp
    ) external onlyOwner {
        require(timestamp == 10 minutes || timestamp == 20 minutes, "Invalid timestamp");

        // Check if the driver is at the checkpoint 
        // we have the two checkpoints (50,50) in the middle & (100,100) at the destination
        if (((uint256(50-currentLatitude))<=5 && (uint256(50-currentLongitude))<=5) || ((currentLatitude-50)<=40 && (currentLongitude-50)<=40)|| ((uint256(100-currentLatitude))<=5 && (uint256(100-currentLongitude))<=5 )) {
            payable(driver).transfer(SALARY_AMOUNT + REWARD_AMOUNT);
        }
        else if (((uint256(50-currentLatitude))<=10 && (uint256(50-currentLongitude))<=10) || ((currentLatitude-50)<=40 && (currentLongitude-50)<=40)|| (uint256(100-currentLatitude)<=10 && uint256(100-currentLongitude)<=10)) {
            payable(driver).transfer(SALARY_AMOUNT);
            
        }
        else {
            payable(driver).transfer(SALARY_AMOUNT-PENALIZE_AMOUNT);   
        }   
    }   
}