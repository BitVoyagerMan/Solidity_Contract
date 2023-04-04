async function main(){
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Acoount balance:", (await deployer.getBalance()).toString());
    console.log("aaa");

    // const MyToken = await ethers.getContractFactory("MyToken");
    // const token = await MyToken.deploy(5000000000);
    // console.log("Token address:", token.address)
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
    console.log("Contract address:", token.address);
}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
})