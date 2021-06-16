// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// CreativeBar is the coolest bar in space. You come in with some CRTV, and leave with more! The longer you stay, the more CRTV you get.


contract CreativeBar is ERC20("CreativeBar", "xCRTV"){
    using SafeMath for uint256;
    IERC20 public crtv;

    constructor(IERC20 crtv) public {
        crtv = _crtv;
    }

 // Enter the bar. Pay some CRTVs. Earn some shares.
// Locks CRTV and mints xCRTV.
function enter(uint256 _amount) public {

        // Gets the amount of CRTV locked in the contract
        uint256 totalCRTV = crtv.balanceOf(address(this));

        // Gets the amount of xCRTV in existence
        uint256 totalShares = totalSupply();

        // If no xCRTV exists, mint it 1:1 to the amount put in
        if (totalShares == 0 || totalCRTV == 0) {
            _mint(msg.sender, _amount);
  } 
        // Calculate and mint the amount of xCRTV the CRTV is worth. The ratio will change overtime, as xCRTV is burned/minted and CRTV deposited + gained from fees / withdrawn.
        else {
            uint256 what = _amount.mul(totalShares).div(totalCRTV);
            _mint(msg.sender, what);
        }

        // Lock the CRTV in the contract
        crtv.transferFrom(msg.sender, address(this), _amount);

    }

   
     // Leave the bar. Claim back your CRTVs.
    // Unclocks the staked + gained CRTV and burns xCRTV
    function leave(uint256 _share) public {
        // Gets the amount of xCRTV in existence
        uint256 totalShares = totalSupply();
        // Calculates the amount of CRTV the xCRTV is worth
        uint256 what = _share.mul(crtv.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        crtv.transfer(msg.sender, what);
    }
}