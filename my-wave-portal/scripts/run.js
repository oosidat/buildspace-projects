const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();

  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log(`contract deployed_to: ${waveContract.address}`);
  console.log(`contract deployed_by: ${owner.address}`);

  let waveCount;
  waveCount = await waveContract.getTotalWaveCount();

  let waveTxn = await waveContract.wave();
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaveCount();

  waveTxn = await waveContract.connect(randomPerson).wave();
  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaveCount();

  let wavers = await waveContract.getWavers();
  console.log("wavers: ", wavers);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
