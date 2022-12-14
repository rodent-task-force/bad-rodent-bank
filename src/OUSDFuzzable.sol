// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import "./OUSD/contracts/token/OUSD.sol";


contract OUSDFuzzable is OUSD {


	function mint(uint256 _amount) external {
        _mint(msg.sender, _amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function increaseSupply(uint256 amount) external {
    	require(amount < 1e18);

	    _changeSupply(_totalSupply + amount);
    }
}