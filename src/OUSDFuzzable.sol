// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import "./OUSD/contracts/token/OUSD.sol";


contract OUSDFuzzable is OUSD {


	function mint(uint128 _amount) external {
        _mint(msg.sender, _amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function increaseSupply(uint128 amount) external {
    	amount = amount % 1e27;
	    _changeSupply(_totalSupply + amount);
    }
}