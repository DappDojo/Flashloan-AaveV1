//SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "./aave/FlashLoanReceiverBase.sol";
import "./aave/ILendingPoolAddressesProvider.sol";
import "./aave/ILendingPool.sol";

contract Flashloan is FlashLoanReceiverBase {

    constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public payable{}

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
        override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        //
        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!
        //

        // Tx hash: 0xc013e7d64cb877004b9b1469a9bd119ee1e549c812578dbd7ad074de06eff3d6
        
        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

    /**
        Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
        Contract Address: 0x21f745e8788d788B93F80cbc7581aAc83D4e81Ea
        
        Ether Reserve (Ropsten): 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE

        Tx hash1: 0xc013e7d64cb877004b9b1469a9bd119ee1e549c812578dbd7ad074de06eff3d6
        Tx hash2: 0x06fdde4d19e39563a93c809df09d976b33791b0179e2177cade18242d8d9e916
     */
    function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint amount = .0001 ether;
        
        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }
}
