pragma solidity ^0.5.0;
 
import "browser/SafeMath.sol";
import 'browser/ERC20Interface.sol';
import 'browser/Ownership.sol';

contract LinePoint is ERC20Interface, Ownership {
    using SafeMath for uint;
 
    string public symbol;
    string public  name;
    uint public decimals;
    uint _totalSupply;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    constructor() public payable {
        symbol = "LIP";
        name = "LinePoint";
        decimals = 18;
        _totalSupply = 1000 * 10**uint(decimals); // wei
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