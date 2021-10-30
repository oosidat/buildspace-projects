const main = async () => {
  const [owner, _randomPerson] = await hre.ethers.getSigners();

  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log(
    `contract deployed_to: ${waveContract.address}, deployed_by: ${owner.address}`
  );

  let waveCount;
  waveCount = await waveContract.getTotalWaveCount();
  console.log(waveCount.toNumber());

  let waveTxn = await waveContract.wave("some message");
  await waveTxn.wait();

  const [_, randomPerson] = await hre.ethers.getSigners();
  waveTxn = await waveContract.connect(randomPerson).wave("Another message!");
  await waveTxn.wait();

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);

  waveCount = await waveContract.getTotalWaveCount();
  console.log(waveCount.toNumber());
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
