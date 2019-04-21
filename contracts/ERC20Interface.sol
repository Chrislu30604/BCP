pragma solidity ^0.5.0;

interface ERC20Interface {
    
  // 所有存在的 Token 數量
  function totalSupply() external view returns (uint256);
  
  // 讀取 tokenOwner 這個 address 所持有的 Token 數量
  function balanceOf(address tokenOwner) external view returns (uint256 balance);
  
  // 從 msg.sender 轉 tokens 個 Token 給 to 這個 address
  function transfer(address to, uint256 tokens) external returns (bool success);
  
  
  // 得到 tokenOwner 授權給 spender 使用的 Token 剩餘數量
  function allowance(address tokenOwner, address spender)
    external view returns (uint256 remaining);
  
  // msg.sender 授權給 spender 可使用自己的 tokens 個 Token
  function approve(address spender, uint256 tokens)
    external returns (bool success);

  // 將 tokens 個 Token 從 from 轉到 to
  function transferFrom(address from, address to, uint256 tokens)
    external returns (bool success);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 tokens
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 tokens
  );
}