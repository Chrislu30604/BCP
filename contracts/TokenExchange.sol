pragma solidity ^0.5.0;

import "browser/ERC20Interface.sol";

contract TokenExchange {
    // LinePoint Contract, User
    address LPPTokenAddr;
    address LPPUser;
    uint256 exchangeAmount;
    
    // Charity Contract
    address CPPTokenAddr;
    // Exchange Rate
    uint exchangeRate;
    
    constructor () public payable {
        exchangeRate = 2;
    }
    
    // 1. LinePoint user : Approve ExchangeContract the ExchangeAmount
    // 2. Charity Owner : Approve to ExchangeContract for totalySupply
    
    // 3. LinePoint user : Trigger this CreateExchange function
    function CreateExchange(
        address _LPPTokenAddr, address _CPPTokenAddr, uint256 _exchangeAmount) public {
            require(ERC20Interface(_LPPTokenAddr).transferFrom(msg.sender, address(this), _exchangeAmount));
            LPPUser = msg.sender;
            LPPTokenAddr = _LPPTokenAddr;
            exchangeAmount = _exchangeAmount;
            
            CPPTokenAddr = _CPPTokenAddr;
        }
    
    // 4. Charity Point Owner : Comfirm this exchange
    function DoChange() public {
        require(ERC20Interface(CPPTokenAddr).transferFrom(msg.sender, address(this), exchangeAmount*exchangeRate));
        ERC20Interface(LPPTokenAddr).transfer(msg.sender, exchangeAmount);
        ERC20Interface(CPPTokenAddr).transfer(LPPUser, exchangeAmount*exchangeRate);
    }
}