const { expect } = require("chai");
const { ethers } = require("hardhat");
describe("Token contract", function () {
  let owner;
  let Token, token;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();
    Token =  await ethers.getContractFactory("Token");
    token =  await Token.deploy();
  });
  it("set variable monthly score && add user", async () => {
    await expect(token.setVariableMonthlyScore(10000)).to.emit(token, "Variable_Score_set").withArgs(10000);
    await expect(token.addUser(owner.address, 1)).to.emit(token, "User_Added").withArgs(owner.address, 1);
    await token.withdraw_variable_pay();
  });

//   it("should add a new user", async () => {
//     await expect(token.addUser(owner.address, 1)).to.emit(token, "User_Added").withArgs(owner.address, 1);
//   });
  it("set fixed monthly score", async () => {
    await expect(token.setFixedMonthlyScore(10)).to.emit(token, "Fixed_Score_set").withArgs(10);
  });
  
  
});
