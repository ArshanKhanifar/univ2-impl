// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/Univ2Pool.sol";
import "solmate/tokens/ERC20.sol";
import "./mocks/MockErc20.sol";

contract UniV2PoolTest is Test {
    UniV2Pool public pool;
    ERC20 token0;
    ERC20 token1;

    function setUp() public {
        token0 = new MockErc20("USD coin", "USDC");
        token1 = new MockErc20("Tether", "USDT");
        pool = new UniV2Pool(token0, token1);
    }

    function testSetNumber(uint256 x) public {}
}
