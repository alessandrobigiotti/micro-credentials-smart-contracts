const path = require('path');
const fs = require('fs');

const Initiator = artifacts.require("Initiator");
const Finalizer = artifacts.require("Finalizer");
const DataStorage = artifacts.require("DataStorage");
const SimpleToken = artifacts.require("SimpleERC20Token");
const SimpleERC721 = artifacts.require("SimpleERC721Token");
const SamplesStorage = artifacts.require("SamplesStorage");
const SamplesCalculateAverage = artifacts.require("SamplesCalculateAverage");


module.exports = async function (deployer, network) {
    console.log("Nothing to initialise...");
}
