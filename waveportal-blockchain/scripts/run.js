const logContractBalance = async (address) => {
  const contractBalance = await hre.ethers.provider.getBalance(address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));
}

const main = async () => {
  const [owner, _randomPerson] = await hre.ethers.getSigners();

  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  });
  await waveContract.deployed();

  console.log(
    `contract deployed_to: ${waveContract.address}, deployed_by: ${owner.address}`
  );

  await logContractBalance(waveContract.address);

  let waveCount;
  waveCount = await waveContract.getTotalWaveCount();
  console.log(waveCount.toNumber());

  const waveTxn1 = await waveContract.wave("Wave 1");
  await waveTxn1.wait();

  const [_, randomPerson] = await hre.ethers.getSigners();
  const waveTxn2 = await waveContract.connect(randomPerson).wave("Wave 2");
  await waveTxn2.wait();

  const waveTxn2a = await waveContract.connect(randomPerson).wave("Wave 2a");
  await waveTxn2a.wait();

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);

  await logContractBalance(waveContract.address);

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
