pragma solidity ^0.5.0;

import "./lib/SafeMath.sol";
import "./lib/ERC20LIPInterface.sol";
import "./lib/ERC20BCPInterface.sol";
import "./Escrow.sol";


contract CharityPlatform{
    
    using SafeMath for uint;
    
    // ERC20 contract
    address BCPAddr = 0x1614BF3D2107Aa755430202d101e9c50485805BE;
    address LIPAddr = 0xa811361389625aE7a2205EC0E92DD542F1feCd8a;
    
    uint internal missionIndex;
    uint internal exchangeRate;
    mapping(uint => address) missionIdxList; // missionID -> missionOwnerAddr
    mapping(address => Mission) missonList; // missionOwnerAddr -> Mission
    mapping(address => uint) ownerToMissionId; // ownerAddr -> missionID
    mapping(address => bool) appliedMissionList; // ownerAddr -> bool
    
    mapping(uint => address) escrowMissionList; // missionID -> escrowAddr 
    
    struct Mission {
        uint id;
        string title;
        string description;
        string imgHash;
        string minorityHash;
        uint targetFund;
        uint fundedAmount;
        address payable ownerAddr;
        mapping(address => uint) ledger;
    }
    
    constructor() public {
        missionIndex = 0;
        exchangeRate = 2;
    }
    
    // Add New Mission
    function addMission(
        string memory _title, 
        string memory _description,
        string memory _imgHash,
        string memory _minorityProofHash,
        uint _targetFund) public returns (bool success) {
        // Check whether msg.sender has had already applied for mission
        require(appliedMissionList[msg.sender] != true);
        
        // Create New Mission
        missionIndex ++;
        Mission memory mission = Mission(missionIndex, _title, _description, _imgHash,  _minorityProofHash, _targetFund, 0, msg.sender);
        missonList[msg.sender] = mission;
        missionIdxList[missionIndex] = msg.sender;
        ownerToMissionId[msg.sender] = missionIndex;
        appliedMissionList[msg.sender] = true;

        // Create Mission Escrow 
        Escrow escrow = new Escrow(missionIndex);
        escrowMissionList[missionIndex] = address(escrow);
        return true;
    }
    

    // Donate Mission 
    function donateMission(uint _missionID, uint tokens) public returns (bool success) {
        require(missionIdxList[_missionID] != msg.sender);
        require(missonList[missionIdxList[_missionID]].targetFund - missonList[missionIdxList[_missionID]].fundedAmount >= tokens);
        
        // Donation
        require(ERC20BCPInterface(BCPAddr).balanceOf(msg.sender) >= tokens);  // Donator's BCP >= tokens
        // Transfer BCP from Donator to MissionContractAddress
        ERC20BCPInterface(BCPAddr).transferFromContract(msg.sender, escrowMissionList[_missionID], tokens); 
        
        missonList[missionIdxList[_missionID]].ledger[msg.sender] = tokens;
        missonList[missionIdxList[_missionID]].fundedAmount = missonList[missionIdxList[_missionID]].fundedAmount.add(tokens);   
        return true;
    }


    // Mission Closing : Exchange from BCP in Escrow to LIP back to missionOwner
    function closeMission() public view returns (address, uint) {
        require(missionIdxList[ownerToMissionId[msg.sender]] == msg.sender); // only missionOwner can close mission
        
        address escrowAddr = escrowMissionList[ownerToMissionId[msg.sender]];
        uint escrowTotalBCP = ERC20BCPInterface(BCPAddr).balanceOf(escrowAddr);
        
        
        // Sendback BCP to BCP.ContractAddress from missionOwner
        // ERC20BCPInterface(BCPAddr).transferFromContract(escrowMissionList[ownerToMissionId[msg.sender]], BCPAddr, escrowTotalBCP);
        
        // // Exchage to LIP from BCP.ContractAddress to missionOwner
        // require(ERC20LIPInterface(LIPAddr).balanceOf(BCPAddr) >= escrowTotalBCP.div(exchangeRate)); // require BCP have enough LIP to exchange
        // ERC20LIPInterface(LIPAddr).transferFromContract(BCPAddr, msg.sender, escrowTotalBCP.div(exchangeRate));  
        return (escrowAddr, escrowTotalBCP);
    }



    // Information Function
    function getMission() public view returns (uint, string memory, string memory, string memory, string memory, uint, uint, address){
        Mission memory mission = missonList[msg.sender];
        return (mission.id, mission.title, mission.description, mission.imgHash, mission.minorityHash, mission.targetFund, mission.fundedAmount, mission.ownerAddr);
    }
    
    function getMissionById(uint _missionID) public view returns (uint, string memory, string memory, string memory, string memory, uint, uint, address) {
        Mission memory mission = missonList[missionIdxList[_missionID]];
        return (mission.id, mission.title, mission.description, mission.imgHash, mission.minorityHash, mission.targetFund, mission.fundedAmount, mission.ownerAddr);
    }
    
    function escrowInfo(uint _missionID) public view returns(address) {
        return Escrow(escrowMissionList[_missionID]).escrowInfo();
    }
}
