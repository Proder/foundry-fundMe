//SPDX-License-Identifier: MIT

//Deploys mocks when we are on a local anvil chain
//Keep track of contract address cross different chains
//Sepolia ETH/USD price feed
//Mainner ETH/USD price feed

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
//If we are on a local anvil chain, deploy mock contracts
//Otherwise, grab the existing address from the live network

contract HelperConfig is Script{
NetworkConfig public activeNetworkConfig;

constructor(){
    if(block.chainid == 11155111){
        activeNetworkConfig = getSepoliaEthConfig();
    }else{
        activeNetworkConfig = getAnvilEthConfig();
    }
}

struct NetworkConfig {
    address priceFeed;
    
}

function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
  NetworkConfig memory sepoliaConfig=NetworkConfig({
    priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
  });
    return sepoliaConfig;
}



function getAnvilEthConfig() public returns (NetworkConfig memory){

    if (activeNetworkConfig.priceFeed != address(0)){
        return activeNetworkConfig;
    }
    //Deploying and then returning mock address
    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8,2000e8);
    vm.stopBroadcast();

    NetworkConfig memory anvilConfig=NetworkConfig({
    priceFeed:address(mockPriceFeed)
    });
    return anvilConfig; 
}

}
