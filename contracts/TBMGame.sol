/**
 * @title TBMGame
 * @author Davinder Singh
 * @notice Implements a Smart Contract for Sample turn based game.
 * A sample game where a player will guess a number(100-109) trigger by oppent player
 */

pragma solidity ^0.4.24;

contract TBMGame {
    address owner;
    uint[10] numberSet;
    uint totalPlayersOnline;
    struct Game {
        address player1;
        address player2;
        uint player1_data;
        uint player2_data;
        bool player1_turn;
        bool player2_turn;

    }
    mapping (address => string) myGameName;
    mapping (string => address) cureentGamePlayers;
    mapping (address => bool) isMyTurn;
    address[] players;

    Game CGame;

    constructor() public {
        owner = msg.sender;
        numberSet = [100,101,102,103,104,105,106,107,108,109];
    }

    function joinGame(string gameName) external returns (bool){
        require(totalPlayersOnline < 2,"Room is already full, Please wait and try.");
        bool status = false;
        if(totalPlayersOnline < 2){
            totalPlayersOnline = totalPlayersOnline + 1;
            myGameName[msg.sender] = gameName;
            cureentGamePlayers[gameName] = msg.sender;
            players.push(msg.sender);
            if(players.length == 2){
                _startGame();
            }
            status = true;
        }
        return status;
    }

    function quitGame(string gameName) external returns (bool) {
        require(cureentGamePlayers[gameName] == msg.sender,"Sender must be active player");
        bool status = true;
        if(cureentGamePlayers[gameName] == msg.sender){
           delete cureentGamePlayers[gameName];
           delete myGameName[msg.sender];
        }
        return status;
    }

    function _startGame() internal {
        Game memory game = Game({
            player1 : players[0],
            player2 : players[1],
            player1_data : 11,
            player2_data : 11,
            player1_turn : true,
            player2_turn : false
        });
        CGame = game;
    }

    function _isMyTurn() internal view returns (bool) {
        bool status = false;
        require(CGame.player1 == msg.sender || CGame.player2 == msg.sender,"You are not currenty in game.");
        if(msg.sender == CGame.player1){
            status = CGame.player1_turn;
        }else{
            status = CGame.player2_turn;
        }
        return status;
    }

    function playYourTurn(uint index) external {
        require(index < 10,"Index must be between 0-9 only.");
        require(CGame.player1 == msg.sender || CGame.player2 == msg.sender,"You are not currenty in game.");
        require(_isMyTurn() == true,"Its not your turn");
        if(msg.sender == CGame.player1){
            CGame.player1_turn = false;
            CGame.player1_data = index;
        }else{
            CGame.player2_turn = false;
            CGame.player2_data = index;
        }
    }
}