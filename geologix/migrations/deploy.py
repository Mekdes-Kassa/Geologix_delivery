# deploy.py
from contracts import artifacts
from contracts.artifacts import  GeoLogixSmartContract, accounts

def main():
    # Load the contract
    GeoLogixSmartContract = artifacts.require('GeoLogixSmartContract')

    # Deploy the contract
    contract = GeoLogixSmartContract.deploy({'from': accounts[0]})

    # Print the contract address
    print("Contract deployed at:", contract.address)
