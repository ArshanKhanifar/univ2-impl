import "forge-std/console2.sol";
import "solmate/tokens/ERC20.sol";
pragma solidity ^0.8.0;

contract LPToken is ERC20 {
    constructor(
        string memory name,
        string memory symbol
    ) ERC20(name, symbol, 18) {}
}

contract UniV2Pool {
    ERC20 token0;
    ERC20 token1;
    ERC20 lpToken;
    uint currPrice = 0;

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
            currPrice = amount1/amount0;
        }

        token0.transfer(msg.sender, this, amount1);
        token1.transfer(msg.sender, this, amount2);
    }
}
