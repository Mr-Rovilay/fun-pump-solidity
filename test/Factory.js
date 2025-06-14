const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Factory", function () {
  const FEE = ethers.parseUnits("0.01", 18);
  
  async function deployFactoryFixture() {
    const [deployer, creator] = await ethers.getSigners()
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy(FEE);

    const transaction = await factory.connect(creator).create("Dapp Uni", "DAPP", {value: FEE})
    await transaction.wait()

    //get token
    const tokenAddress = await factory.tokens(0)
    const token = ethers.getContractAt("Token", tokenAddress)
    return { factory, deployer, creator, token }; // ✅ Wrap it in an object
  }

  describe("Deployment", function () {
    it("should set the fee", async function () {
      const { factory } = await loadFixture(deployFactoryFixture);
      expect(await factory.fee()).to.equal(FEE);
    });

     it("should set the owner", async function () {
      const { factory, deployer } = await loadFixture(deployFactoryFixture);
      expect(await factory.owner()).to.equal(deployer.address);
    });
  });

  describe("Creating", function () {
     it("should set the owner", async function () {
      const { factory, token } = await loadFixture(deployFactoryFixture);
      expect(await token.owner()).to.equal(await factory.getAddress());
    });
  })

  
});
