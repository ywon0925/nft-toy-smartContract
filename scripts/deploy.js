const hre = require("hardhat");
const main = async () =>  {
  const NFTBusinessCard = await hre.ethers.getContractFactory("NFTBusinessCard");
  const nftBusinessCard = await NFTBusinessCard.deploy();

  await nftBusinessCard.deployed();

  console.log(`NFTBusinessCard deployed to ${nftBusinessCard.address}`);
}

const runMain = async () =>{
  try{
    await main();
    process.exit(0);
  }catch(error){
    console.error(error);
    process.exit(1);
  }
}

runMain();