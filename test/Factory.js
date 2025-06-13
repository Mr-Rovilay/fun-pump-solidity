const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Factory", function () {
  const FEE = ethers.parseUnits("0.01", 18);

  async function deployFactoryFixture() {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy(FEE);
    return { factory }; // ✅ Wrap it in an object
  }

  describe("Deployment", function () {
    it("should set the fee", async function () {
      const { factory } = await loadFixture(deployFactoryFixture);
      expect(await factory.fee()).to.equal(FEE);
    });
  });
});
