// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/Univ2Pool.sol";

contract UniV2PoolTest is Test {
    UniV2Pool public pool;

    function setUp() public {
        pool = new UniV2Pool();
    }

    function testSetNumber(uint256 x) public {
    }
}
