import "../../lib/pnm-contracts/PTest.sol";
import "../../src/OUSDFuzzable.sol";

contract OUSDFuzzTest is PTest {
    OUSDFuzzable ousd;
    address agent;
    address alice = address(0x0100);
    address bob = address(0x0101);
    address vault = address(0x0201);

    function setUp() external {
        agent = getAgent();

        ousd = new OUSDFuzzable();
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
            ousd.burn(aliceBalance);    
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

    function testNonRebasingFailToBurn() public {
        vm.startPrank(alice);

        ousd.mint(100e18);
        ousd.increaseSupply(150e18);
        ousd.rebaseOptOut();
        ousd.burn(1);

        ousd.burn(ousd.balanceOf(alice)); // Reverts
    }
}
