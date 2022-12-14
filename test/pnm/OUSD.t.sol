import "../../lib/pnm-contracts/PTest.sol";
import "../../src/OUSD/contracts/token/OUSD.sol";

contract OUSDFuzzTest is PTest {
    OUSD ousd;
    address agent;
    address payable depositor;
    address payable vault;

    function setUp() external {
        agent = getAgent();

        ousd = new OUSD();
        ousd.initialize("OUSD", "OUSD", address(vault));

        vm.deal(depositor, 100);
        vm.prank(depositor);

        vm.deal(vault, 100);
        vm.prank(vault);
    }

    function invariantBalanceLessThanTotalSupply() public {
        assertLe(
            ousd.balanceOf(address(depositor)),
            ousd.totalSupply()
            );
    }

    function attack() public {
	// vm.prank(agent);
	// bank.withdrawFrom(agent, 2);
    }
}
