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
    }

   function invariantRebaseOptInKeepsBalance() public {
     uint256 prevBalance = ousd.balanceOf(agent);
     vm.prank(agent);
     ousd.rebaseOptIn();
     assertEq(ousd.balanceOf(agent), prevBalance);
   }


    function invariantCanBurnBalance() public {
        vm.startPrank(agent);
        uint256 agentBalance = ousd.balanceOf(agent);
        if (agentBalance > 0) {
            ousd.burn(agentBalance);
        }
        vm.stopPrank();
    }

    // Legit bug
    // ---------
    // function testNonRebasingFailToBurn() public {
    //     vm.startPrank(agent);

    //     ousd.mint(100e18);
    //     ousd.increaseSupply(150e18); // greater than the mint before
    //     ousd.rebaseOptOut();

    //         ousd.burn(1);
    //         ousd.burn(ousd.balanceOf(agent)); // Reverts
        
    // }

    function testStrangeMintBug() public {
        vm.startPrank(agent);
        ousd.mint(128);
        assertEq(ousd.balanceOf(agent), 128);
        ousd.burn(128);
    }

    function invariantBalanceLessThanTotalSupply() public {
        assertLe(ousd.balanceOf(address(alice)), ousd.totalSupply());
    }

    function invariantNonRebasingLessThanTotalSupply() public {
        assertLe(ousd.nonRebasingSupply(), ousd.totalSupply());
    }
    
    // Legit
    // ---------
    // function testMint() public {
    //     vm.prank(vault);
    //     ousd.mint(alice, 100e18);
        
    //     vm.prank(vault);
    //     ousd.changeSupply(250e18);

    //     vm.prank(vault);
    //     ousd.mint(alice, 1);
    //     assertEq(ousd.balanceOf(alice), ousd.totalSupply());
    //     assertEq(ousd.balanceOf(alice), 250e18+1);
    // }
}
