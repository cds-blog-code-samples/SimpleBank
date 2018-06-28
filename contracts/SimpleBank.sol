pragma solidity ^0.4.13;


contract SimpleBank {

    mapping (address => uint) private balances;
    mapping (address => bool) private customers;

    address public owner;

    event LogDepositMade(address accountAddress, uint amount);

    modifier isCustomer(address _address) {
        require (
            customers[msg.sender] == true,
            "User is not a bank customer"
        );
        _;
    }

    modifier isNotCustomer() {
        require (
            customers[msg.sender] == false,
            "User is already a bank customer"
        );
        _;
    }

    // Constructor, can receive one or many variables here; only one allowed
    constructor() public {
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function () public {
        revert();
    }

    /// @notice Enroll a customer with the bank, giving them 1000 tokens for free
    /// @return The balance of the user after enrolling
    function enroll()
      public isNotCustomer()
      returns (uint)
    {
        // add new customer and set balance
        customers[msg.sender] = true;

        balances[msg.sender] = 1000;
        return balances[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    // Add the appropriate keyword so that this function can receive ether
    function deposit() public payable returns (uint) {
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public payable returns (uint remainingBal) {
        /* If the sender's balance is at least the amount they want to withdraw,
           Subtract the amount from the sender's balance, and try to send that amount of ether
           to the user attempting to withdraw. IF the send fails, add the amount back to the user's balance
           return the user's balance.*/

        require(balances[msg.sender] >= withdrawAmount);
        balances[msg.sender] -= withdrawAmount;
        return balances[msg.sender];
    }

    /// @notice Get balance
    /// @return The balance of the user
    // A SPECIAL KEYWORD prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function balance() public constant returns (uint) {
        /* Get the balance of the sender of this transaction */
        return balances[msg.sender];
    }
}
