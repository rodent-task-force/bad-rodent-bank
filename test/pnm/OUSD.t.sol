import "../../lib/pnm-contracts/PTest.sol";
import "../../src/OUSD/contracts/token/OUSD.sol";

contract OUSDFuzzTest is PTest {
    OUSD ousd;
    address agent;
    address alice = address(0x0100);
    address bob = address(0x0101);
    address vault = address(0x0201);

    function setUp() external {
        agent = getAgent();

        ousd = new OUSD();
        ousd.initialize("OUSD", "OUSD", address(vault));

        vm.deal(payable(alice), 1e18);
        vm.deal(payable(bob), 1e18);
        vm.deal(payable(vault), 1e18);
        
    }

    function invariantBalanceLessThanTotalSupply() public {
        assertLe(
            ousd.balanceOf(address(alice)),
            ousd.totalSupply()
            );
    }

    function testMint() public {
        vm.prank(vault);
    	ousd.mint(alice, 100e18);
        
        vm.prank(vault);
        ousd.changeSupply(250e18);

        vm.prank(vault);
        ousd.mint(alice, 1);
    }
}
