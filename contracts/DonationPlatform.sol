pragma solidity ^0.5.0;

import "browser/SafeMath.sol";
import "browser/EscrowTmp.sol";
import "browser/ERC20Interface.sol";

contract CharityPlatform{
    
    using SafeMath for uint;
    
    uint internal missionIndex;
    mapping(uint => address) missionIdxList; // missionID -> missionOwnerAddr
    mapping(address => Mission) missonList; // missionOwnerAddr -> Mission
    mapping(address => bool) appliedMissionList; 
    
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
    }
    
    
    function addMissionList(string memory _name, uint _targetFund) public returns (bool success) {
        // Check whether msg.sender has had already applied for mission
        require(appliedMissionList[msg.sender] != true);
        
        // Create New Mission
        missionIndex ++;
        Mission memory mission = Mission(missionIndex, _name, _targetFund, 0, msg.sender);
        missonList[msg.sender] = mission;
        missionIdxList[missionIndex] = msg.sender;
        appliedMissionList[msg.sender] = true;
        
        // Create Mission Escrow 
        Escrow escrow = new Escrow(missionIndex);
        escrowMissionList[missionIndex] = address(escrow);
        
        return true;
    }
    
    function donateMission(uint _missionID, address LPPAddr, uint tokenValue) public returns (bool success) {
        require(missionIdxList[_missionID] != msg.sender);
        require(missonList[missionIdxList[_missionID]].targetFund - missonList[missionIdxList[_missionID]].fundedAmount >= tokenValue);
        
        // Transfer Error (need approval to contract)
        ERC20Interface(LPPAddr).transfer(escrowMissionList[_missionID], tokenValue);
        missonList[missionIdxList[_missionID]].ledger[msg.sender] = tokenValue;
        missonList[missionIdxList[_missionID]].fundedAmount += tokenValue;
        
        return true;
    }
    
    
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