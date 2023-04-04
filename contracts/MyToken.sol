import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract MyToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("Minato", "MTO") {
        _mint(msg.sender, initialSupply);
    }
    
    function decimals() public view override returns (uint8) {
        return 6;
    }
}