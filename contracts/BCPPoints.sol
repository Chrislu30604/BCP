pragma solidity ^0.5.0;

import "browser/SafeMath.sol";
import "browser/ERC20Interface.sol";
import "browser/Ownership.sol";

contract CharityPoint is ERC20Interface, Ownership {
    using SafeMath for uint;
 
    string public symbol;
    string public  name;
    uint public decimals;
    uint public exchangeRate;
    uint _totalSupply;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) alpragma solidity ^0.5.0;

import "browser/SafeMath.sol";
import "browser/Ownership.sol";
import "browser/ERC20BCPInterface.sol";
import "browser/ERC20LIPInterface.sol";

contract BCP is ERC20BCPInterface, Ownership {
    using SafeMath for uint;
 
    string public symbol;
    string public  name;
    uint public decimals;
    uint _totalSupply;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    uint exchangeRate; // 1 LIP -> 2 BCP
    
    // Constructor Initiate
    constructor() public payable {
        symbol = "BCP";
        name = "Blockchain Charity Points";
        decimals = 18;
        _totalSupply = 2000 * 10**uint(decimals); 
        exchangeRate = 2;

        // Release all the token to contract address
        balances[address(this)] = _totalSupply;
        emit Transfer(address(0), address(this), _totalSupply);
    }
    
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        require(balances[msg.sender] > 0);
        require(tokens > 0);
        
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(balances[from] > 0);
        require(allowed[from][msg.sender] > 0);
        require(tokens > 0);
        
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    /*-----------------Additional Function-----------------*/
    function distributePoints(address to, uint tokens) public onlyOwner returns (bool success) {
        require(balances[address(this)] >= tokens);
        require(tokens > 0);
        
        balances[address(this)] = balances[address(this)].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(address(this), to, tokens);
        return true;
    }
    
    function transferFromContract(address from, address to, uint tokens) public returns (bool success) {
        require(balances[from] >= tokens);
        require(tokens > 0);
        
        balances[from] = balances[from].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;   
    }
    
    
    function LIPtoBCP(address LIPAddr, uint LIPtokens) public returns (bool success) {
        require(ERC20LIPInterface(LIPAddr).balanceOf(msg.sender) >= LIPtokens);
        require(balances[address(this)] >= LIPtokens*exchangeRate);
        
        // Receive LIP from msg.sender
        ERC20LIPInterface(LIPAddr).transferFromContract(msg.sender, address(this), LIPtokens);
        // Exchange BCP from BCPContract to msg.sender
        transferFromContract(address(this), msg.sender, LIPtokens*exchangeRate);
        return true;
    }
    
    
    function BCPtoLIP(address LIPAddr, uint BCPtokens) public returns (bool success) {
        require(BCPtokens % exchangeRate == 0);
        require(balances[msg.sender] >= BCPtokens);
        require(ERC20LIPInterface(LIPAddr).balanceOf(address(this)) >= BCPtokens.div(exchangeRate));
        
        // Receive BCP from msg.sender
        transferFromContract(msg.sender, address(this), BCPtokens);
        // Exchange LIP from BCPContract to msg.sender
        ERC20LIPInterface(LIPAddr).transferFromContract(address(this), msg.sender, BCPtokens.div(exchangeRate));
        return true;
    }
    
    
    function donate(address from, address to, uint tokens) public returns (bool success) {
        require(balances[from] > tokens);
        require(tokens > 0);
        
        balances[from] = balances[from].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer( from, to, tokens);
        return true;
    }
    
    
    function exchange(address from, uint tokens) public returns (bool success) {
        require(balances[from] == tokens);
        require(tokens > 0);
        
        balances[from] = balances[from].sub(tokens);
        balances[address(this)] = balances[address(this)].add(tokens);
        emit Transfer(from , address(this), tokens);
        return true;
    }
    
    
    // Fallback Function 
    function () external payable {
        revert();
    }
}lowed;
    
    // Constructor initiate
    constructor() public payable {
        symbol = "CPP";
        name = "CharityPoint";
        decimals = 18;
        _totalSupply = 2000 * 10**uint(decimals); // wei
        exchangeRate = 2; // 1 LPP = 2 CPP
        balances[owner] = _totalSupply;
        allowed[owner][address(this)] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
        emit Approval(owner, address(this), _totalSupply);
    }
    
    function totalSupply() public view returns (uint) {
        return _totalSupply.sub(balances[address(0)]);
    }
    
    
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }
    
    
    // Transfer the balance from token owner's account to `to` account
    function transfer(address to, uint tokens) public returns (bool success) {
        require(balances[msg.sender] > 0);
        require(tokens > 0);
        
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    
    // Returns the amount of tokens approved by the owner that can be transferred to the spender's account
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
    
    // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function approveExchangeContract(address exchangeContract) public onlyOwner returns (bool succss) {
        allowed[msg.sender][exchangeContract] = _totalSupply;
        emit Approval(msg.sender, exchangeContract, _totalSupply);
        return true;
    }
    
   
    // Transfer `tokens` from the `from` account to the `to` account
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(balances[from] > 0);
        require(allowed[from][msg.sender] > 0);
        require(tokens > 0);
        
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
    
    // Fallback Function : This ERC20 don't accept ETH
    function () external payable {
        revert();
    }
    

    // Owner can transfer out any accidentally sent ERC20 tokens
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}