// SPDX-License-Identifier: MIT


pragma solidity == 0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";


contract GeoLogixSolutions {
    // Define the ERC20 token for rewards
    ERC20Detailed private _token;

    // Define the driver struct
    struct Driver {
        address driverAddress;
        string name;
        uint256 rating;
        uint256 lastRewardTime;
        uint256 lastRewardAmount;
    }

    // Define the driver mapping
    mapping(address => Driver) private _drivers;

    // Define the contract owner
    address private _owner;

    // Define the contract constructor
    constructor() public {
        _owner = msg.sender;
        _token = new ERC20Detailed("GeoLogix Token", "GLT", 18);
    }

    // Define the modifier to check if the caller is the contract owner
    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not the owner");
        _;
    }

    // Define the function to add a new driver
    function addDriver(address driverAddress, string memory name) public onlyOwner {
        require(_drivers[driverAddress].driverAddress == address(0), "Driver already exists");
        _drivers[driverAddress] = Driver(driverAddress, name, 0, 0, 0);
    }
    // Define the function to get the zone based on the location
    function getZone(uint256 latitude, uint256 longitude) private pure returns (uint256) {
        // Define the zones based on the location
        if (latitude >= 10 && latitude <= 20 && longitude >= 10 && longitude <= 20) {
            return 1; // Zone 1
        } else if (latitude >= 20 && latitude <= 30 && longitude >= 20 && longitude <= 30) {
            return 2; // Zone 2
        } else {
            return 0; // Outside the zones
        }
    }
    // Define the function to update the driver's location
    function updateDriverLocation(address driverAddress, uint256 timestamp, uint256 latitude, uint256 longitude) public onlyOwner {
        require(_drivers[driverAddress].driverAddress != address(0), "Driver does not exist");
        Driver storage driver = _drivers[driverAddress];
        uint256 zone = getZone(latitude, longitude);
        uint256 rewardAmount = getRewardAmount(driver.rating, timestamp, driver.lastRewardTime);
        if (zone == 1) {
            driver.rating += 1;
            driver.lastRewardAmount = rewardAmount;
            driver.lastRewardTime = timestamp;
            _token.mint(driverAddress, rewardAmount);
        } else if (zone == 2) {
            driver.rating -= 1;
            driver.lastRewardAmount = rewardAmount;
            driver.lastRewardTime = timestamp;
            _token.mint(driverAddress, rewardAmount);
        } else {
            driver.rating = 0;
            driver.lastRewardAmount = 0;
            driver.lastRewardTime = timestamp;
        }
    }

    // Define the function to get the driver's information
    function getDriver(address driverAddress) public view returns (Driver memory) {
        require(_drivers[driverAddress].driverAddress != address(0), "Driver does not exist");
        return _drivers[driverAddress];
    }

    
    // Define the function to give reward
    function getRewardAmount(uint256 rating, uint256 currentTime, uint256 lastRewardTime) private pure returns (uint256) {
        uint256 timeDifference = currentTime - lastRewardTime;
        uint256 rewardAmount;

        // Define the reward amount based on the rating
        if (rating >= 10 && rating <= 20) {
            rewardAmount = timeDifference * 1; // 1 token per second
        } else if (rating >= 20 && rating <= 30) {
            rewardAmount = timeDifference * 2; // 2 tokens per second
        } else if (rating >= 30 && rating <= 40) {
            rewardAmount = timeDifference * 3; // 3 tokens per second
        } else {
            rewardAmount = 0; // No reward
        }

        return rewardAmount;
    }
    // function to penalize driver by reducing the rate 
    function penalizeDriver(address driverAddress, uint256 timestamp, uint256 latitude, uint256 longitude) public onlyOwner {
        require(_drivers[driverAddress].driverAddress != address(0), "Driver does not exist");
        Driver storage driver = _drivers[driverAddress];
        uint256 zone = getZone(latitude, longitude);
        if (zone == 0) {
            driver.rating -= 1;
            driver.lastPenaltyTime = timestamp;
            driver.lastPenaltyAmount = getPenaltyAmount(driver.rating, timestamp, driver.lastPenaltyTime);
            _token.mint(driverAddress, -driver.lastPenaltyAmount);
        }

    }
    // function to get penalty amount 
    function getPenaltyAmount(uint256 rating, uint256 currentTime, uint256 lastPenaltyTime) private pure returns (uint256) {
        uint256 timeDifference = currentTime - lastPenaltyTime;
        uint256 penaltyAmount;

        // Define the penalty amount based on the rating
        if (rating >= 10 && rating <= 20) {
            penaltyAmount = timeDifference * 1; // 1 token per second
        } else if (rating >= 20 && rating <= 30) {
            penaltyAmount = timeDifference * 2; // 2 tokens per second
        } else if (rating >= 30 && rating <= 40) {
            penaltyAmount = timeDifference * 3; // 3 tokens per second
        } else {
            penaltyAmount = 0; // No penalty
        }

        return penaltyAmount;
    }
}