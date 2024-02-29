// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GamingAirdrop is Ownable, VRFConsumerBase {
    // Variables for Chainlink VRF integration
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    bool private _isFulfillingRandomness = false;
    uint256 public distributionStartTime;
    uint256 public minEntriesForDistribution;

    // ERC20 token
    IERC20 public token;
    uint256 public prizePool;

    // Chainlink VRF request variable
    bytes32 private _requestId;

    // Participant struct
    struct Participant {
        address participantAddress;
        uint256 entries;
    }

    // Array to store participants
    Participant[] public participants;

    // Mapping to track participant index
    mapping(address => uint256) public participantIndex;

    // Events
    event ParticipantRegistered(address indexed participant);
    event EntriesEarned(address indexed participant, uint256 entries);
    event PrizeDistributionEvent(address[] winners, uint256[] rewards);

    // Constructor
    constructor(address _vrfCoordinator, address _linkToken, bytes32 _keyHash, uint256 _fee, address _tokenAddress) 
        Ownable(msg.sender)
        VRFConsumerBase(_vrfCoordinator, _linkToken)
    {
        keyHash = _keyHash;
        fee = _fee;
        token = IERC20(_tokenAddress);
    }

    // Function to register participants
    function registerParticipant() external {
        require(participantIndex[msg.sender] == 0, "Participant already registered");
        Participant memory newParticipant = Participant(msg.sender, 0);
        participants.push(newParticipant);
        participantIndex[msg.sender] = participants.length;
        emit ParticipantRegistered(msg.sender);
    }

    // Function to perform safe addition
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a && c >= b, "Safe addition overflow");
        return c;
    }

    // Callback function for Chainlink VRF
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        require(requestId == _requestId, "Invalid request ID");
        require(!_isFulfillingRandomness, "Function is already being executed");
        _isFulfillingRandomness = true;
        randomResult = randomness;
        selectWinnersAndDistribute(randomResult);
        _isFulfillingRandomness = false;
    }

    // Function to trigger prize distribution
    function triggerPrizeDistribution() external onlyOwner {
        require(participants.length > 0, "No participants registered");
        require(prizePool > 0, "Prize pool is empty");
        require(block.timestamp >= distributionStartTime + (1 weeks), "Distribution time not reached");
        require(getTotalEntries() >= minEntriesForDistribution, "Not enough entries for distribution");
        // Generate random number using Chainlink VRF
        _requestId = requestRandomness(keyHash, fee);
    }
    
    // Function to select winners and distribute rewards
    function selectWinnersAndDistribute(uint256 _randomNumber) internal {
        uint256 numberOfWinners = 1; 
        address[] memory winners = new address[](numberOfWinners);
        uint256[] memory rewards = new uint256[](numberOfWinners);

        for (uint256 i = 0; i < numberOfWinners && i < participants.length; i++) {
            uint256 winnerIndex = _randomNumber % participants.length;
            address winnerAddress = participants[winnerIndex].participantAddress;
            uint256 reward = calculateReward(participants[winnerIndex].entries);
            
            winners[i] = winnerAddress;
            rewards[i] = reward;
            delete participants[winnerIndex];
        }

        emit PrizeDistributionEvent(winners, rewards);

        for (uint256 i = 0; i < winners.length; i++) {
            distributeTokens(winners[i], rewards[i]);
        }
    }

    // Function to calculate reward based on entries
    function calculateReward(uint256 _entries) internal view returns (uint256) {
        return (prizePool * _entries) / getTotalEntries();
    }

    // Function to distribute ERC20 tokens to a winner
    function distributeTokens(address _winner, uint256 _amount) internal {
        require(token.balanceOf(address(this)) >= _amount, "Insufficient balance in the contract");
        token.transfer(_winner, _amount);
    }

    // Function to get total entries
    function getTotalEntries() internal view returns (uint256) {
        uint256 totalEntries;
        for (uint256 i = 0; i < participants.length; i++) {
            totalEntries += participants[i].entries;
        }
        return totalEntries;
    }

    // Additional function to set the distribution start time
    function setDistributionStartTime(uint256 _startTime) external onlyOwner {
        distributionStartTime = _startTime;
    }

    // Additional function to set the minimum entries required for distribution
    function setMinEntriesForDistribution(uint256 _minEntries) external onlyOwner {
        minEntriesForDistribution = _minEntries;
    }
}