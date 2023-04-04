const { expect } = require("chai");
const { ethers } = require("hardhat");
describe("Token contract", function () {
  let owner, user1, user2;
  let Token, token;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();
    console.log(owner, user1, user2);
    Token =  await ethers.getContractFactory("Token");
    

    token =  await Token.deploy();
    console.log("111");
  });
  it("set variable monthly score && add user", async () => {
    console.log("aaaa");
    await expect(token.setFixedMonthlyScore(100000000)).to.emit(token, "Fixed_Score_set").withArgs(100000000);
    await expect(token.addUser(user1, 1)).to.emit(token, "User_Added").withArgs(user1, 1);
    token.connect(user1);
    await token.withdraw_variable_pay();
  });

//   it("should add a new user", async () => {
//     await expect(token.addUser(owner.address, 1)).to.emit(token, "User_Added").withArgs(owner.address, 1);
//   });

  
  
});
