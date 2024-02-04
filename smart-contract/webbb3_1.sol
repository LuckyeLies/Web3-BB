// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

struct Participant {
    string name;
    string image;
}

struct Voting {
    string[] ids;
    uint[] votes;  // vote count for each option
    uint maxDate;
}

struct Vote {
    uint choice; // index of the chosen option
    uint date;
}

contract Webbb3_1 {
    address owner;
    uint public currentVoting = 0;
    Voting[] public votings;
    mapping(uint256 => mapping(address => Vote)) public votes;  // In the voting nº x, the address voted on the y choice: votes[x][address] gives de choice of the address on the voting nº x
    mapping(uint256 => Participant) public participants;    // Create administrative function to add all participants available

    constructor() {
        owner = msg.sender;
    }

    function setOwner(address newOwner) public {
        require(msg.sender == owner, "Invalid sender");
        owner = newOwner;
    }

    function getCurrentVoting() public view returns (Voting memory) {
        return votings[currentVoting];
    }

    function addVoting(string[] memory ids, uint timeToVote) public {
        require(msg.sender == owner, "Invalid sender");

        if(votings.length != 0) {
            currentVoting++;
        }

        Voting memory newVoting;
        newVoting.ids = ids;
        newVoting.maxDate = timeToVote + block.timestamp;

        // Initialize votes array with zeros
        newVoting.votes = new uint[](ids.length);
        votings.push(newVoting);
    }

    function addVote(uint choice) public {
        require(choice > 0, "Choice needs to be > 0");
        require(choice <= getCurrentVoting().ids.length, "Invalid choice");
        require(getCurrentVoting().maxDate > block.timestamp, "No open voting");
        require(votes[currentVoting][msg.sender].date < (block.timestamp - 3600), "You already voted on this voting in the last hour");

        votes[currentVoting][msg.sender].choice = choice;
        votes[currentVoting][msg.sender].date = block.timestamp;

        votings[currentVoting].votes[choice - 1]++;
    }
}

/*
- permitir 2, 3 ou 4 participantes na votação;

- cadastro da foto (somente URL) dos participantes na blockchain; struct com nome, url, informações básicas

- funcionalidade de troca de owner;

- permitir votos da mesma pessoa, mas apenas um por hora;

*/