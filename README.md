# CodeAlpha Blockchain Development Tasks

This repository contains implementations for the CodeAlpha internship blockchain tasks. Each task is a Solidity smart contract demonstrating fundamental blockchain concepts including storage management, Ether distribution, voting systems, and time-locked deposits.

---

## Task 1: Simple Storage Smart Contract

This basic Solidity smart contract demonstrates the use of state variables and functions on the Ethereum blockchain.

### Contract Overview

The `SimpleStorage` contract stores a single unsigned integer value and provides functions to:  
- **Increment** the value by 1.  
- **Decrement** the value by 1 with underflow protection.  
- **Read** the current value.

### Functions

- `get()`  
  - *Visibility:* public view  
  - *Returns:* (uint256) The currently stored value.  
  - *Purpose:* Allows anyone to read the value stored in the contract.

- `increment()`  
  - *Visibility:* public  
  - *Purpose:* Increases the stored value by 1. Modifies the blockchain state and requires gas.

- `decrement()`  
  - *Visibility:* public  
  - *Purpose:* Decreases the stored value by 1. Includes a `require` statement to prevent the value becoming negative.

### Deployment & Testing

- Compile `SimpleStorage.sol` with Solidity compiler version `^0.8.0`.
- Deploy to the Remix VM (JavaScript VM).
- Test by calling:  
  - `get()` — should return 0 initially.  
  - `increment()`, then `get()` — should return 1.  
  - `decrement()`, then `get()` — should return 0.  
  - Call `decrement()` again — should fail with error "Value cannot be negative".
 
  - <img width="281" height="232" alt="image" src="https://github.com/user-attachments/assets/5ece3e7c-e07f-4fda-9388-f1b1c8ef1abd" />
  - <img width="289" height="282" alt="image" src="https://github.com/user-attachments/assets/f19431ca-e9ae-488d-bcee-97aa1fbf30e4" />



---

## Task 2: Multi-Send Smart Contract

This contract enables sending an equal amount of Ether to multiple addresses in a single transaction, efficiently splitting the funds.

### Contract Overview

The `MultiSend` contract features one payable function:  
- Accepts an array of recipient addresses.  
- Distributes the sent Ether equally among recipients.  
- Refunds any leftover Wei due to division.

### Functions

- `sendEther(address[] calldata recipients)`  
  - *Visibility:* external payable  
  - *Parameters:* recipients — array of recipient Ethereum addresses.  
  - *Purpose:* Distributes Ether equally to each address while performing safety checks for sufficient funds and successful transfers.

### Deployment & Testing

- Compile and deploy `MultiSend.sol`.
- Use test accounts from Remix to prepare recipient addresses.
- From the deploying account, call `sendEther` with an array like `["0x...", "0x...", "0x..."]` and a `VALUE` field specifying Ether amount (e.g., 2 ETH).
- Verify sender's balance decreased (plus gas), and recipients received equal shares.

### Notes

- Uses `.call{value:}()` method for safest Ether transfers.
- <img width="291" height="201" alt="image" src="https://github.com/user-attachments/assets/0b324c30-c3d8-4083-8f84-c83cc60eaf77" />
- <img width="286" height="311" alt="image" src="https://github.com/user-attachments/assets/70c862c1-b978-4ea0-9731-a72d46b33601" />



---

## Task 3: Polling System Smart Contract

A decentralized voting system allowing creation of polls, secure voting, and result tallying after a deadline.

### Contract Overview

The `PollingSystem` contract manages poll lifecycles:  
- Poll creation with title, options, and deadline.  
- Each address can vote once before poll end time.  
- Result calculation returns winning option after poll ends.

### Functions

- `createPoll(string memory _title, string[] memory _options, uint256 _durationInMinutes)`  
  - *Visibility:* public  
  - *Purpose:* Creates a new poll.

- `vote(uint256 _pollId, uint256 _optionIndex)`  
  - *Visibility:* public  
  - *Purpose:* Casts vote for an option in a poll, preventing double-voting and late votes.

- `getWinningOption(uint256 _pollId)`  
  - *Visibility:* public view  
  - *Returns:* `(uint256 winningOptionIndex, uint256 voteCount)`  
  - *Purpose:* Returns winning option index and vote count post poll end.

- `getPollDetails(uint256 _pollId)`  
  - *Visibility:* public view  
  - *Purpose:* Retrieves poll details (title, options, end time, status).

### Deployment & Testing

- Compile and deploy `PollingSystem.sol`.
- Create a poll: `createPoll("Poll Title?", ["Option1", "Option2", "Option3"], 5)` for 5-minute poll.
- Vote from different accounts: `vote(0, X)` where `X` is option index.
- Attempt double-vote on same account — should fail.
- After deadline (or via Remix time jump), call `getWinningOption(0)`.
- <img width="286" height="329" alt="image" src="https://github.com/user-attachments/assets/a783554b-cf11-45d7-97d4-d6e185948f14" />
- <img width="292" height="377" alt="image" src="https://github.com/user-attachments/assets/16866b3d-fe27-4b51-bde4-e8810a63e298" />
- <img width="664" height="312" alt="image" src="https://github.com/user-attachments/assets/cb281903-9a2b-449a-8c9c-24b3c1080a3b" />




---

## Task 4: Personal Portfolio (Crypto Locking) Smart Contract

This contract allows users to deposit Ether or tokens with a time lock, enforcing withdrawal restrictions based on time.

### Contract Overview

- Users deposit Ether and specify lock-in time.  
- Each user’s deposit and unlock time stored with mappings.  
- Withdraw function only allows access after lock period has passed, using `block.timestamp`.

### Functions

- `deposit(uint lockTimeInSeconds)`  
  - *Visibility:* public payable  
  - *Purpose:* User deposits Ether and sets a lock time.

- `withdraw()`  
  - *Visibility:* public  
  - *Purpose:* Allows withdrawal only after the lock time ends.

### Deployment & Testing

- Compile and deploy `CryptoLock.sol`.
- Deposit Ether with a lock time (seconds).  
- Attempt withdrawal before unlock time — should revert.  
- Withdraw after unlock time — should succeed and return funds.
- <img width="268" height="323" alt="image" src="https://github.com/user-attachments/assets/099053fe-b320-4110-9ad7-b4076d396035" />
- <img width="657" height="328" alt="image" src="https://github.com/user-attachments/assets/4033fe61-c846-40ab-82f0-44a6ce1a0855" />



---

## License

All projects are licensed under the MIT License.
