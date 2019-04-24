# BCP (Block Charity Point)

## Structure

-
```
CharityPlatform.sol -> LinePoints.sol  ERC_Line_Interface.sol
       |		     |
       |                  -- SafeMath.sol
       |                 |
       |                  -- Ownership.sol
       |
        -- CharityPoint.sol -- ERC_Charity_Interface.sol
       |		       |
       |                    -- SafeMath.sol
       |                   |
       |                    -- Ownership.sol
       |
        -- Escrow.sol
       |tr
        -- SafeMath.sol

```

## Function

- CharityPlatform.sol:  

  - $addMissionList(string memory_name, uint_targetFund):  
  
	新創一個捐款項目  
	_name -> 捐款項目名稱  
	_targetFund -> 要募多少錢
