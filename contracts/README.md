# BCP (Block Charity Point)

## Structure



## Function

- **CharityPlatform.sol:**

  - **$addMissionList(string memory_name, uint_targetFund):**

	新創一個募款專案  
	\_name -> 捐款項目名稱  
	\_targetFund -> 要募多少錢  

  - **$donateMission(uint \_missionID ,address CPPAddr ,uint tokenValue):**

  	擁有 CHARITY TOKENS 的 account 可以選擇喜歡的項目捐款  
    \_missionID -> 項目 ID  
  	CPPAddr -> Charity 合約地址  
  	tokenValue -> 要捐多少錢  

  - **$ExChange_LINE(address LPPAddr ,address CPPAddr):**

    把捐款項目地址內的 CHARITY 都換成 LINE Points  
  	LPPAddr -> LINE 合約地址  
  	CPPAddr -> Charity 合約地址  

  - **$getMission():**

  	get Mission Info  

  - **$getMissionById(uint \_missionID):**

  	get Mission Info by missionID  
  	\_missionID -> 項目 ID  

  - **$escrowInfo:**

  	get Mission's Address


- **Exchange.sol:**

	- **$ExChange_Charity(address LPPAddr ,address CPPAddr ,uint tokenValue):**

		把 [tokenValue] 數量的 LINE Points 換成 CHARITY Points  
		LPPAddr -> LINE 合約地址  
		CPPAddr -> Charity 合約地址  
		tokenValue -> 要換多少 LINE Points  


- **SafeMath.sol:**

	避免 Overflow and Underflow


- **Ownership.sol:**

	權限管理


- **LinePoints.sol:**

	生成 LINE Points 的合約 (先用 ERC20 的方式模擬現實生活的 LINE Points)  


- **CharityPoint.sol:**

	生成 Charity Points 的合約  


- **Escrow.sol:**

	生成新募款項目地址

- **ERC_Line_Interface.sol:**

	Describe:LINE Points的統一規範

- **ERC_Charity_Interface.sol:**

	Describe:Charity Tokens的統一規範
