const path = require('path');
const fs = require('fs');

const ELearningPlatform = artifacts.require("ELearningPlatform");

module.exports = async function (deployer, network) {
  console.log('Make deploy on Network: ', network);

  let deployTime = Date.now();
  console.log("Start time: ", deployTime);

  await deployer.deploy(ELearningPlatform, deployer.options.from);
  eLearningPlatformAddress = ELearningPlatform.address;
  console.log('Total deploy time:');
  console.log(Date.now() - deployTime);

  writeFile(network, eLearningPlatformAddress);
}

function writeFile(network, eLearningPlatformAddress) {
  let folderPath = path.resolve(__dirname, '..', 'contractAddresses', network);
  let content = {};

  try {
    if(!fs.existsSync(folderPath)){
      fs.mkdirSync(folderPath, {recursive:true});
    }
    if(!fs.existsSync(folderPath+'/addresses.json')) {
        fs.openSync(folderPath+'/addresses.json', 'w');
    }
    content["ELearningPlatform"] = eLearningPlatformAddress;
    fs.writeFileSync(folderPath+'/addresses.json', JSON.stringify(content));
  }

  catch (err) {
    console.log(err);
  }
}
