pragma solidity ^0.8.0;
import "solmate/tokens/ERC20.sol";

contract MockErc20 is ERC20 {
    constructor(
        string memory name,
        string memory symbol
    ) ERC20(name, symbol, 18) {}

    function mint(address to, uint amount) public {
        _mint(to, amount);
    }
}
