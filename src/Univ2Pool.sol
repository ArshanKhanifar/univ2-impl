import "forge-std/console2.sol";
import "solmate/tokens/ERC20.sol";
import {FixedPointMathLib as Math} from "solmate/utils/FixedPointMathLib.sol";
pragma solidity ^0.8.0;

contract LPToken is ERC20 {
    address public owner;

    constructor(
        string memory name,
        string memory symbol
    ) ERC20(name, symbol, 18) {
        owner = msg.sender;
    }

    error NotOwner();

    function mint(address to, uint amount) public {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _mint(to, amount);
    }
}

contract UniV2Pool {
    ERC20 token0;
    ERC20 token1;
    LPToken public lpToken;
    uint256 currPrice = 0;
    uint256 liquidity = 0;
    uint immutable PRICE_DECIMALS = 1e10;

    function r0() public view returns (uint256) {
        return token0.balanceOf(address(this));
    }

    function r1() public view returns (uint256) {
        return token1.balanceOf(address(this));
    }

    constructor(ERC20 _token0, ERC20 _token1) {
        token0 = _token0;
        token1 = _token1;
        string memory name = string(
            abi.encodePacked(token0.symbol(), "-", token1.symbol(), " LP Token")
        );
        string memory sym = string(
            abi.encodePacked(token0.symbol(), "-", token1.symbol(), " LP")
        );
        lpToken = new LPToken(name, sym);
    }

    function deposit(uint256 amount0, uint256 amount1) public {
        if (currPrice == 0) {
            currPrice = (amount1 * PRICE_DECIMALS) / amount0;
        }
        uint r = ((amount1 * PRICE_DECIMALS) / amount0);

        uint in0;
        uint in1;

        if (r > currPrice) {
            in0 = amount0;
            in1 = (currPrice * amount0) / PRICE_DECIMALS;
        } else {
            in0 = ((amount1 * PRICE_DECIMALS) / currPrice);
            in1 = amount1;
        }
        token0.transferFrom(msg.sender, address(this), in0);
        token1.transferFrom(msg.sender, address(this), in1);

        uint lp_amount = Math.sqrt(in0 * in1);
        liquidity += lp_amount;
        lpToken.mint(msg.sender, lp_amount);
    }

    function swapExactIn(uint256 amount0, uint256 amount1) public {
        if (amount0 < amount1) {
            token1.transferFrom(msg.sender, address(this), amount1);
            uint256 amountOut = (amount1 * r0()) / r1();
            token0.transfer(msg.sender, amountOut);
        } else {
            token0.transferFrom(msg.sender, address(this), amount0);
            uint256 amountOut = (amount0 * r1()) / r0();
            token1.transfer(msg.sender, amountOut);
        }
    }
}
