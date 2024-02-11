# Importing the necessary modules
import pytest

# Define the test function to evaluate driver performance
def test_evaluate_driver(geologix_smart_contract, accounts):
    # Get the contract instance
    geoLogixSmartContract = geologix_smart_contract

    # Define the parameters for evaluating driver performance
    currentLatitude = 60
    currentLongitude = 60
    timestamp = 10 * 60  # 10 minutes

    # Evaluate driver performance
    tx = geoLogixSmartContract.evaluateDriver(currentLatitude, currentLongitude, timestamp, {"from": accounts[0]})

    # Verify the transaction
    assert "SalaryReleased" in tx.events
    assert "RewardReleased" in tx.events

    # Verify that funds are transferred correctly
    assert geoLogixSmartContract.balanceOf(accounts[1]) == geoLogixSmartContract.SALARY_AMOUNT + geoLogixSmartContract.REWARD_AMOUNT
