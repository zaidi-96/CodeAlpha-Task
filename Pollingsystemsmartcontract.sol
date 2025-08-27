// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollingSystem {
    // Structure for a Poll
    struct Poll {
        string title;
        string[] options;
        uint256 endTime;
        mapping(uint256 => uint256) votesPerOption; // Option index => vote count
        mapping(address => bool) hasVoted; // Track who has voted
        bool exists;
    }
    
    // Array to store all polls
    Poll[] public polls;
    
    // Event to notify when a new poll is created
    event PollCreated(uint256 pollId, string title, uint256 endTime);
    
    // Event to notify when someone votes
    event Voted(uint256 pollId, address voter, uint256 optionIndex);
    
    // Create a new poll
    function createPoll(string memory _title, string[] memory _options, uint256 _durationInMinutes) public {
        require(_options.length >= 2, "Poll must have at least 2 options");
        
        uint256 pollId = polls.length;
        polls.push();
        Poll storage newPoll = polls[pollId];
        
        newPoll.title = _title;
        newPoll.options = _options;
        newPoll.endTime = block.timestamp + (_durationInMinutes * 1 minutes);
        newPoll.exists = true;
        
        emit PollCreated(pollId, _title, newPoll.endTime);
    }
    
    // Vote in a poll
    function vote(uint256 _pollId, uint256 _optionIndex) public {
        require(_pollId < polls.length, "Invalid poll ID");
        Poll storage poll = polls[_pollId];
        require(poll.exists, "Poll does not exist");
        require(block.timestamp < poll.endTime, "Voting period has ended");
        require(_optionIndex < poll.options.length, "Invalid option index");
        require(!poll.hasVoted[msg.sender], "You have already voted");
        
        poll.votesPerOption[_optionIndex]++;
        poll.hasVoted[msg.sender] = true;
        
        emit Voted(_pollId, msg.sender, _optionIndex);
    }
    
    // Get winning option of a poll
    function getWinningOption(uint256 _pollId) public view returns (uint256 winningOptionIndex, uint256 voteCount) {
        require(_pollId < polls.length, "Invalid poll ID");
        Poll storage poll = polls[_pollId];
        require(poll.exists, "Poll does not exist");
        require(block.timestamp >= poll.endTime, "Voting is still ongoing");
        
        winningOptionIndex = 0;
        voteCount = 0;
        
        for (uint256 i = 0; i < poll.options.length; i++) {
            if (poll.votesPerOption[i] > voteCount) {
                voteCount = poll.votesPerOption[i];
                winningOptionIndex = i;
            }
        }
        
        // In case of a tie, returns the first option with the highest votes
        return (winningOptionIndex, voteCount);
    }
    
    // Helper function to get poll details
    function getPollDetails(uint256 _pollId) public view returns (
        string memory title,
        string[] memory options,
        uint256 endTime,
        bool isActive
    ) {
        require(_pollId < polls.length, "Invalid poll ID");
        Poll storage poll = polls[_pollId];
        require(poll.exists, "Poll does not exist");
        
        return (
            poll.title,
            poll.options,
            poll.endTime,
            block.timestamp < poll.endTime
        );
    }
    
    // Helper function to check if an address has voted in a poll
    function hasAddressVoted(uint256 _pollId, address _voter) public view returns (bool) {
        require(_pollId < polls.length, "Invalid poll ID");
        Poll storage poll = polls[_pollId];
        require(poll.exists, "Poll does not exist");
        
        return poll.hasVoted[_voter];
    }
}