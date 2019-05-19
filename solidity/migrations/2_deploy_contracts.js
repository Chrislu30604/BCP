var BCPPoints = artifacts.require("./BCPPoints.sol");
var LIPPoints = artifacts.require("./LIPPoints.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(BCPPoints)
  deployer.deploy(LIPPoints)
};