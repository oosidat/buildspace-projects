const main = async () => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();

  console.log(`deploying contracts with account: ${deployer.address}`);
  console.log(`accountBalance: ${accountBalance.toString()}`);

  const token = await hre.ethers.getContractFactory("WavePortal");
  const wavePortal = await token.deploy();
  await wavePortal.deployed();

  console.log(`WavePortal address: ${wavePortal.address}`);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();
