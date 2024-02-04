// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

struct Voting {
    string option1;
    uint votes1;
    string option2;
    uint votes2;
    uint maxDate;
}

struct Vote {
    uint choice; // 1 or 2
    uint date;
}

contract Webbb3 {
    address owner;
    uint public currentVoting = 0;
    Voting[] public votings;
    mapping(uint256 => mapping(address => Vote)) public votes;  // In the voting nº x, the address voted on the y choice: votes[x][address] gives de choice of the address on the voting nº x

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

    function addVoting(string memory option1, string memory option2, uint timeToVote) public {
        require(msg.sender == owner, "Invalid sender");

        if(votings.length != 0) {
            currentVoting++;
        }

        Voting memory newVoting;
        newVoting.option1 = option1;
        newVoting.option2 = option2;
        newVoting.maxDate = timeToVote + block.timestamp;
        votings.push(newVoting);
    }

    function addVote(uint choice) public {
        require(choice == 1 || choice == 2, "Invalid choice");
        require(getCurrentVoting().maxDate > block.timestamp, "No open voting");
        require(votes[currentVoting][msg.sender].date == 0, "You already voted on this voting");

        votes[currentVoting][msg.sender].choice = choice;
        votes[currentVoting][msg.sender].date = block.timestamp;

        if(choice == 1) {
            votings[currentVoting].votes1++;
        } else if (choice == 2) {
            votings[currentVoting].votes2++;
        }
    }
}

/*

TODO:
- permitir 2, 3 ou 4 participantes na votação;

- cadastro da foto (somente URL) dos participantes na blockchain; struct com nome, url, informações básicas

- funcionalidade de troca de owner;

- permitir votos da mesma pessoa, mas apenas um por hora;

*/