pragma solidity ^0.5.0;

import "browser/SafeMath.sol";
import "browser/Escrow.sol";
import "browser/ERC20LIPInterface.sol";
import "browser/ERC20BCPInterface.sol";


contract CharityPlatform{
    
    using SafeMath for uint;
    
    uint internal missionIndex;
    uint internal exchangeRate;
    mapping(uint => address) missionIdxList; // missionID -> missionOwnerAddr
    mapping(address => Mission) missonList; // missionOwnerAddr -> Mission
    mapping(address => uint) ownerToMissionId; // ownerAddr -> missionID
    mapping(address => bool) appliedMissionList; // ownerAddr -> bool
    
    mapping(uint => address) escrowMissionList; // missionID -> escrowAddr 
    
    struct Mission {
        uint id;
        string name;
        uint targetFund;
        uint fundedAmount;
        address payable ownerAddr;
        mapping(address => uint) ledger;
    }
    
    constructor() public {
        missionIndex = 0;
        exchangeRate = 2;
    }
    
    
    function addMissionList(string memory _name, uint _targetFund) public returns (bool success) {
        // Check whether msg.sender has had already applied for mission
        require(appliedMissionList[msg.sender] != true);
        
        // Create New Mission
        missionIndex ++;
        Mission memory mission = Mission(missionIndex, _name, _targetFund, 0, msg.sender);
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
    function donateMission(uint _missionID, address BCPAddr, uint tokens) public returns (bool success) {
        require(missionIdxList[_missionID] != msg.sender);
        require(missonList[missionIdxList[_missionID]].targetFund - missonList[missionIdxList[_missionID]].fundedAmount >= tokens);
        
        // Donation
        address Donator = msg.sender;
        require(ERC20BCPInterface(BCPAddr).balanceOf(Donator) >= tokens);  // Donator's BCP >= tokens
        // Transfer BCP from Donator to MissionContractAddress
        ERC20BCPInterface(BCPAddr).donate(Donator, escrowMissionList[_missionID], tokens); 
        
        missonList[missionIdxList[_missionID]].ledger[msg.sender] = tokens;
        missonList[missionIdxList[_missionID]].fundedAmount = missonList[missionIdxList[_missionID]].fundedAmount.add(tokens);        
        return true;
    }


    // Mission Closing : Exchange from BCP in Escrow to LIP back to missionOwner
    function missionClosing(address LIPAddr, address BCPAddr) public returns (bool success) {
        require(missionIdxList[ownerToMissionId[msg.sender]] == msg.sender); // only missionOwner can close mission
        
        uint escrowTotalBCP = ERC20BCPInterface(BCPAddr).balanceOf(escrowMissionList[ownerToMissionId[msg.sender]]);
        // Sendback BCP to BCP.ContractAddress from missionOwner (LIP -> BCP)
        ERC20BCPInterface(BCPAddr).transferFromContract(escrowMissionList[ownerToMissionId[msg.sender]], BCPAddr, escrowTotalBCP);
        // ERC20BCPInterface(BCPAddr).exchange(escrowMissionList[ownerToMissionId[msg.sender]], escrowTotalBCP);  
        
        // Exchage to LIP from BCP.ContractAddress to missionOwner (BCP -> LIP)
        require(ERC20LIPInterface(LIPAddr).balanceOf(BCPAddr) >= escrowTotalBCP.div(exchangeRate)); // require BCP have enough LIP to exchange
        ERC20LIPInterface(LIPAddr).transferFromContract(BCPAddr, msg.sender, escrowTotalBCP.div(exchangeRate));  
        return true;
    }


        /*-----------------new-----------------*/
/*
    function Debug(address CPPAddr) public view returns (uint value){
        return ERC_Charity_Interface(CPPAddr).balanceOf(escrowMissionList[OwnerToMissionId[msg.sender]]);
    }
    
    function Debug() public view returns (bool value){
        require(missionIdxList[OwnerToMissionId[msg.sender]] == msg.sender);
        return true;
    }
*/   


    // Informational Function
    function getMission() public view returns (uint, string memory, uint, uint, address){
        Mission memory mission = missonList[msg.sender];
        return (mission.id, mission.name, mission.targetFund, mission.fundedAmount, mission.ownerAddr);
    }
    
    function getMissionById(uint _missionID) public view returns (uint, string memory, uint, uint, address) {
        Mission memory mission = missonList[missionIdxList[_missionID]];
        return (mission.id, mission.name, mission.targetFund, mission.fundedAmount, mission.ownerAddr);
    }
    
    function escrowInfo(uint _missionID) public view returns(address) {
        return Escrow(escrowMissionList[_missionID]).escrowInfo();
    }
    
}