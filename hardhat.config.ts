import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  networks: {
    // hardhat 内置测试网络（选填）
    hardhat: {
      // 可以设置一个固定的gasPrice，在测试gas消耗的时候会很有用
      gasPrice: 1000000000,
    },
    // 你可以在这里配置任意网络
    // // rinkeby 测试网络
    // rinkeby: {
    //   // 请将 INFURA_ID 替换成你自己的
    //   url: 'https://rinkeby.infura.io/v3/{INFURA_ID}',
    //   // 填写测试账户的私钥，可填写多个
    //   accounts: ["0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80", "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"]
    // }
  },
  solidity: {
    version:"0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  etherscan: {
    apiKey: "SZQEEEV3QWGAMAQP783R6UA3ESP659IASE",
  },
};

export default config;
