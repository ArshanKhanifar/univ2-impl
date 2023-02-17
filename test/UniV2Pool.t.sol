// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/Univ2Pool.sol";
import "solmate/tokens/ERC20.sol";
import "solmate/utils/FixedPointMathLib.sol";
import "./mocks/MockErc20.sol";

contract UniV2PoolTest is Test {
    UniV2Pool public pool;
    MockErc20 token0;
    MockErc20 token1;
    ERC20 lpToken;
    uint total0 = 80_000e18;
    uint total1 = 4e18;

    function setUp() public {
        token0 = new MockErc20("USD coin", "USDC");
        token1 = new MockErc20("Wrapped Ether", "WETH");
        token0.mint(address(this), total0);
        token1.mint(address(this), total1);
        pool = new UniV2Pool(token0, token1);
        token0.approve(address(pool), total0 * 2);
        token1.approve(address(pool), total1 * 2);
        lpToken = pool.lpToken();
    }

    function testDeposit() public {
        // Wanna set the price of eth to 10k at first
        uint curr0 = total0;
        uint curr1 = total1;

        uint in0_0 = 10_000e18;
        uint in1_0 = 1e18;
        pool.deposit(in0_0, in1_0);
        curr0 -= in0_0;
        curr1 -= in1_0;

        assertEq(token0.balanceOf(address(this)), curr0);
        assertEq(token1.balanceOf(address(this)), curr1);
        assertEq(lpToken.balanceOf(address(this)), 100e18);

        uint in0_1 = 30_000e18;
        uint in1_1 = 3e18;
        pool.deposit(in0_1, in1_1);
        curr0 -= in0_1;
        curr1 -= in1_1;

        assertEq(token0.balanceOf(address(this)), curr0);
        assertEq(token1.balanceOf(address(this)), curr1);
        assertEq(lpToken.balanceOf(address(this)), 400e18);

        uint swap_in_0 = 40_000e18;
        pool.swapExactIn(swap_in_0, 0);
        curr0 -= swap_in_0; // 0
        curr1 = 2e18; // 2e18
        assertEq(token0.balanceOf(address(this)), curr0);
        assertEq(token1.balanceOf(address(this)), curr1);

        uint swap_in_1 = 1e18;
        pool.swapExactIn(0, swap_in_1);
    }
}
