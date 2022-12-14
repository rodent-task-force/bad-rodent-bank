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

    function invariantNonRebasingLessThanTotalSupply() public {
        assertLe(
            ousd.nonRebasingSupply(),
            ousd.totalSupply()
            );
    }

    function invariantCanBurnBalance() public {
        uint256 aliceBalance = ousd.balanceOf(alice);
        if(aliceBalance > 0){
            vm.prank(vault);
            ousd.burn(alice, aliceBalance);    
        }
    }

    function testMint() public {
        vm.prank(vault);
        ousd.mint(alice, 100e18);
        
        vm.prank(vault);
        ousd.changeSupply(250e18);

        vm.prank(vault);
        ousd.mint(alice, 1);
        assertEq(ousd.balanceOf(alice), ousd.totalSupply());
        assertEq(ousd.balanceOf(alice), 250e18+1);
    }

    function testNonRebasing() public {
        vm.prank(vault);
        ousd.mint(alice, 100e18);
        
        vm.prank(vault);
        ousd.changeSupply(250e18);

        vm.prank(alice);
        ousd.rebaseOptOut();

        vm.prank(vault);
        ousd.burn(alice, 1);

        uint256 aliceBalance = ousd.balanceOf(alice);

        vm.prank(vault);
        ousd.burn(alice, aliceBalance);

        assertEq(ousd.totalSupply(), 0);
        assertEq(ousd.balanceOf(alice), 0);
        assertEq(ousd.nonRebasingSupply(), 0);
    }
}
