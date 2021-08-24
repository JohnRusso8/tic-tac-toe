import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'dart:async';

enum Difficuty { EASY, MEDIUM, HARD }

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // constant characters for each player
  static const String HUMAN_PLAYER = "X";
  static const String COMPUTER_PLAYER = "O";
  // Initial Text for infoLabel
  String _text = "X's Turn";
  // constant for board size
  static const BOARD_SIZE = 9;
  // Game Variables
  var gameOver = false;
  var win = 0;
  var turn = 0;
  var humanWin = 0;
  var computerWin = 0;
  var tie = 0;
  var _mBoard = ["", "", "", "", "", "", "", "", ""];
  var rnd = new Random(BOARD_SIZE);
  var _button0Press = true;
  var _button1Press = true;
  var _button2Press = true;
  var _button3Press = true;
  var _button4Press = true;
  var _button5Press = true;
  var _button6Press = true;
  var _button7Press = true;
  var _button8Press = true;
  var _gameDifficulty = 1;

  static AudioCache swish = new AudioCache();
  static AudioCache sword = new AudioCache();

  playLocal_swish() {
    swish.play('swish.mp3');
  }

  playLocal_sword() {
    sword.play('sword.mp3');
  }

  void getComputerMove() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (_gameDifficulty == 1) {
          getRandomMove();
        } else if (_gameDifficulty == 2) {
          getWinningMove();
          if (winningMove == true) {
            return;
          }
          getRandomMove();
        } else if (_gameDifficulty == 3) {
          getWinningMove();
          if (winningMove == true) {
            return;
          }
          getBlockingMove();
          if (blockingMove == true) {
            return;
          }
          getRandomMove();
        }
      });
      playLocal_sword();
    });
  }

  bool winningMove = false;
  getWinningMove() {
    winningMove = false;
    for (int i = 0; i < BOARD_SIZE; i++) {
      if (_mBoard[i] != HUMAN_PLAYER && _mBoard[i] != COMPUTER_PLAYER) {
        var curr = _mBoard[i];
        _mBoard[i] = COMPUTER_PLAYER;
        if (checkForWinner() == 3) {
          print("Computer is moving to ${i + 1}");
          winningMove = true;
          return;
        } else
          _mBoard[i] = curr;
      }
    }
  }

  bool blockingMove = false;
  getBlockingMove() {
    blockingMove = false;
    for (int i = 0; i < BOARD_SIZE; i++) {
      if (_mBoard[i] != HUMAN_PLAYER && _mBoard[i] != COMPUTER_PLAYER) {
        var curr = _mBoard[i]; // Save the current number
        _mBoard[i] = HUMAN_PLAYER;
        if (checkForWinner() == 2) {
          _mBoard[i] = COMPUTER_PLAYER;
          print("Computer is moving to ${i + 1}");
          blockingMove = true;
          return;
        } else
          _mBoard[i] = curr;
      }
    }
  }

  getRandomMove() {
    int move;
    do {
      move = rnd.nextInt(BOARD_SIZE);
    } while (_mBoard[move] == HUMAN_PLAYER || _mBoard[move] == COMPUTER_PLAYER);

    print("Computer is moving to  ${move + 1}");

    _mBoard[move] = COMPUTER_PLAYER;
  }

  void displayBoard() {
    print("");
    print(_mBoard[0] + " | " + _mBoard[1] + " | " + _mBoard[2]);
    print("-----------");
    print(_mBoard[3] + " | " + _mBoard[4] + " | " + _mBoard[5]);
    print("-----------");
    print(_mBoard[6] + " | " + _mBoard[7] + " | " + _mBoard[8]);
    print("");
  }

  int checkForWinner() {
    // Check horizontal wins
    for (int i = 0; i <= 6; i += 3) {
      if (_mBoard[i] == (HUMAN_PLAYER) &&
          _mBoard[i + 1] == (HUMAN_PLAYER) &&
          _mBoard[i + 2] == (HUMAN_PLAYER)) return 2;

      if (_mBoard[i] == (COMPUTER_PLAYER) &&
          _mBoard[i + 1] == (COMPUTER_PLAYER) &&
          _mBoard[i + 2] == (COMPUTER_PLAYER)) return 3;
    }

    // Check vertical wins
    for (int i = 0; i <= 2; i++) {
      if (_mBoard[i] == (HUMAN_PLAYER) &&
          _mBoard[i + 3] == (HUMAN_PLAYER) &&
          _mBoard[i + 6] == (HUMAN_PLAYER)) return 2;

      if (_mBoard[i] == (COMPUTER_PLAYER) &&
          _mBoard[i + 3] == (COMPUTER_PLAYER) &&
          _mBoard[i + 6] == (COMPUTER_PLAYER)) return 3;
    }

    // Check for diagonal wins
    if ((_mBoard[0] == (HUMAN_PLAYER) &&
            _mBoard[4] == (HUMAN_PLAYER) &&
            _mBoard[8] == (HUMAN_PLAYER)) ||
        (_mBoard[2] == (HUMAN_PLAYER) &&
            _mBoard[4] == (HUMAN_PLAYER) &&
            _mBoard[6] == (HUMAN_PLAYER))) return 2;

    if ((_mBoard[0] == (COMPUTER_PLAYER) &&
            _mBoard[4] == (COMPUTER_PLAYER) &&
            _mBoard[8] == (COMPUTER_PLAYER)) ||
        (_mBoard[2] == (COMPUTER_PLAYER) &&
            _mBoard[4] == (COMPUTER_PLAYER) &&
            _mBoard[6] == (COMPUTER_PLAYER))) return 3;

    for (int i = 0; i < BOARD_SIZE; i++) {
      // If we find a number, then no one has won yet
      if (!(_mBoard[i] == (HUMAN_PLAYER)) && !(_mBoard[i] == (COMPUTER_PLAYER)))
        return 0;
    }

    // If we make it through the previous loop, all places are taken, so it's a tie*/
    return 1;
  }

  void displayMessage(String text) {
    _text = text;
    print(text);
  }

  void checkGameOver(int win) {
    // Report the winner
    print("");
    if (win == 1) {
      gameOver = true;
      displayMessage("It's a tie.");
      _gameOverButtons();
    } else if (win == 2) {
      gameOver = true;
      displayMessage(HUMAN_PLAYER + " wins!");
      _gameOverButtons();
    } else if (win == 3) {
      gameOver = true;
      displayMessage(COMPUTER_PLAYER + " wins!");
      _gameOverButtons();
    } else
      displayMessage("There is a logic problem!");
    _gameOverButtons();
  }

  void _gameOverButtons() {
    _button0Press = false;
    _button1Press = false;
    _button2Press = false;
    _button3Press = false;
    _button4Press = false;
    _button5Press = false;
    _button6Press = false;
    _button7Press = false;
    _button8Press = false;
  }

  void _updateScoreBoard() {
    setState(() {
      if (checkForWinner() == 1) {
        tie++;
      } else if (checkForWinner() == 2) {
        humanWin++;
      } else if (checkForWinner() == 3) {
        computerWin++;
      }
    });
  }

  void _allButtons() {
    setState(() {
      if (checkForWinner() == 1 ||
          checkForWinner() == 2 ||
          checkForWinner() == 3) {
        checkGameOver(checkForWinner());
        displayMessage(_text);
      } else {
        getComputerMove();
      }
      displayBoard();
      Future.delayed(const Duration(seconds: 1), () {
        if (checkForWinner() == 0) {
          _text = "O Moved, X's Turn";
        } else {
          checkGameOver(checkForWinner());
        }
        displayMessage(_text);
        _updateScoreBoard();
      });
    });
  }

  void _button0() {
    _button0Press = false;
    _mBoard[0] = HUMAN_PLAYER;
    _allButtons();
  }

  void _button1() {
    _button1Press = false;
    _mBoard[1] = HUMAN_PLAYER;
    _allButtons();
  }

  void _button2() {
    _button2Press = false;
    _mBoard[2] = HUMAN_PLAYER;
    _allButtons();
  }

  void _button3() {
    _button3Press = false;
    _mBoard[3] = HUMAN_PLAYER;
    _allButtons();
  }

  void _button4() {
    _button4Press = false;
    _mBoard[4] = HUMAN_PLAYER;
    _allButtons();
  }

  void _button5() {
    _button5Press = false;
    _mBoard[5] = HUMAN_PLAYER;
    _allButtons();
  }

  void _button6() {
    _button6Press = false;
    _mBoard[6] = HUMAN_PLAYER;
    _allButtons();
  }

  void _button7() {
    _button7Press = false;
    _mBoard[7] = HUMAN_PLAYER;
    _allButtons();
  }

  void _button8() {
    _button8Press = false;
    _mBoard[8] = HUMAN_PLAYER;
    _allButtons();
  }

  void _resetScores() {
    setState(() {
      humanWin = 0;
      computerWin = 0;
      tie = 0;
    });
  }

  void _resetButton() {
    setState(() {
      gameOver = false;
      win = 0;
      turn = 0;
      _mBoard = ["", "", "", "", "", "", "", "", ""];
      rnd = new Random(BOARD_SIZE);
      _text = "X's Turn";
      _button0Press = true;
      _button1Press = true;
      _button2Press = true;
      _button3Press = true;
      _button4Press = true;
      _button5Press = true;
      _button6Press = true;
      _button7Press = true;
      _button8Press = true;
      _gameDifficulty = 1;
    });
  }

  void _aboutDialog(BuildContext context, String message) {
    showAboutDialog(
      context: context,
      applicationIcon: Image.asset(
        'assets/ttt_icon.png',
        height: 50,
        width: 50,
      ),
      applicationName: 'Tic Tac Toe',
      applicationVersion: '0.0.1',
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 15), child: Text(message))
      ],
    );
  }

  Future _settings(BuildContext context, String message) async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: new Text('Select the Difficulty Level'),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text('Easy'),
              onPressed: () {
                // Complete this code in the next step.

                Navigator.pop(context, Difficuty.EASY);
              },
            ),
            new SimpleDialogOption(
              child: new Text('Medium'),
              onPressed: () {
                Navigator.pop(context, Difficuty.MEDIUM);
              },
            ),
            new SimpleDialogOption(
              child: new Text('Hard'),
              onPressed: () {
                Navigator.pop(context, Difficuty.HARD);
              },
            ),
          ],
        );
      },
    )) {
      case Difficuty.EASY:
        _gameDifficulty = 1;
        showSnackBar(context);
        break;
      case Difficuty.MEDIUM:
        _gameDifficulty = 2;
        showSnackBar(context);
        break;
      case Difficuty.HARD:
        _gameDifficulty = 3;
        showSnackBar(context);
        break;
    }
    print('The selection was Choice = ' + '$_gameDifficulty');
  }

  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Difficulty Level = $_gameDifficulty'),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
          label: 'OK',
          textColor: Colors.blue,
          onPressed: () {
            print('Done pressed!');
          }),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
// Define variables that will change here

/*
  
 dataType someVariable = some initial value;

*/

// Format for method using setState() to change some variable's value

/*

void someMethod(){
  setState((){
	someVariable = newValue;
  });
}

*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        leading: IconButton(
          icon: Icon(Icons.border_all),
          onPressed: null,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.new_releases),
            onPressed: () {
              _resetButton();
            },
            tooltip: 'New Game',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _resetScores();
            },
            tooltip: 'Reset Game Scores',
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => exit(0),
            tooltip: 'Quit Game',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: GestureDetector(
                    onTap: () {
                      _aboutDialog(context,
                          "This is a simple tic-tac-toe game for Android and iOS. The buttons represent the game board and a text widget displays the game status. Moves are represented by an X for the human player and an O for the computer.");
                    },
                    child: Text(
                      'About',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              PopupMenuItem(
                  child: GestureDetector(
                onTap: () {
                  _settings(context, "Hard");
                },
                child: Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ))
            ],
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildVerticalLayout()
              : _buildHorizontalLayout();
        },
      ),
    );

    // Use of variable value from above, when changed will force GUI to rebuild
    /*

	$someVariables value;

	*/
  }

  _buildVerticalLayout() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    if (_button0Press) {
                      _button0();
                      playLocal_swish();
                    }
                  },
                  child: Text(
                    _mBoard[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    if (_button1Press) {
                      _button1();
                      playLocal_swish();
                    }
                  },
                  child: Text(
                    _mBoard[1],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    if (_button2Press) {
                      _button2();
                      playLocal_swish();
                    }
                  },
                  child: Text(
                    _mBoard[2],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    if (_button3Press) {
                      _button3();
                      playLocal_swish();
                    }
                  },
                  child: Text(
                    _mBoard[3],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    if (_button4Press) {
                      _button4();
                      playLocal_swish();
                    }
                  },
                  child: Text(
                    _mBoard[4],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    if (_button5Press) {
                      _button5();
                      playLocal_swish();
                    }
                  },
                  child: Text(
                    _mBoard[5],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    if (_button6Press) {
                      _button6();
                      playLocal_swish();
                    }
                  },
                  child: Text(
                    _mBoard[6],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    if (_button7Press) {
                      _button7();
                      playLocal_swish();
                    }
                  },
                  child: Text(
                    _mBoard[7],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              Container(
                height: 100.0,
                width: 100.0,
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    if (_button8Press) {
                      _button8();
                      playLocal_swish();
                    }
                  },
                  child: Text(
                    _mBoard[8],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30.0,
                width: 300.0,
                margin: EdgeInsets.all(10.0),
                child: Text(
                  _text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20.0,
                width: 70.0,
                margin: EdgeInsets.all(10.0),
                child: Text(
                  "Human:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              ),
              Container(
                height: 20.0,
                width: 50.0,
                margin: EdgeInsets.all(10.0),
                child: Text(
                  humanWin.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20.0,
                width: 70.0,
                margin: EdgeInsets.all(10.0),
                child: Text(
                  "Computer:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              ),
              Container(
                height: 20.0,
                width: 50.0,
                margin: EdgeInsets.all(10.0),
                child: Text(
                  computerWin.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20.0,
                width: 70.0,
                margin: EdgeInsets.all(10.0),
                child: Text(
                  "Ties:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              ),
              Container(
                height: 20.0,
                width: 50.0,
                margin: EdgeInsets.all(10.0),
                child: Text(
                  tie.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _buildHorizontalLayout() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          height: 85.0,
          width: 85.00,
          margin: EdgeInsets.all(10.0),
          child: RaisedButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              if (_button0Press) {
                _button0();
                playLocal_swish();
              }
            },
            child: Text(
              _mBoard[0],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 65.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
        Container(
          height: 85.0,
          width: 85.0,
          margin: EdgeInsets.all(10.0),
          child: RaisedButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              if (_button1Press) {
                _button1();
                playLocal_swish();
              }
            },
            child: Text(
              _mBoard[1],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 65.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
        Container(
          height: 85.0,
          width: 85.0,
          margin: EdgeInsets.all(10.0),
          child: RaisedButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              if (_button2Press) {
                _button2();
                playLocal_swish();
              }
            },
            child: Text(
              _mBoard[2],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 65.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30.0,
                  width: 300.0,
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    _text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto'),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20.0,
                  width: 70.0,
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    "Human:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto'),
                  ),
                ),
                Container(
                  height: 20.0,
                  width: 50.0,
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    humanWin.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto'),
                  ),
                )
              ],
            ),
          ],
        ),
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 85.0,
            width: 85.0,
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                if (_button3Press) {
                  _button3();
                  playLocal_swish();
                }
              },
              child: Text(
                _mBoard[3],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 65.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Container(
            height: 85.0,
            width: 85.0,
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                if (_button4Press) {
                  _button4();
                  playLocal_swish();
                }
              },
              child: Text(
                _mBoard[4],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 65.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Container(
            height: 85.0,
            width: 85.0,
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                if (_button5Press) {
                  _button5();
                  playLocal_swish();
                }
              },
              child: Text(
                _mBoard[5],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 65.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20.0,
                    width: 75.0,
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "Computer:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto'),
                    ),
                  ),
                  Container(
                    height: 20.0,
                    width: 50.0,
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      computerWin.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto'),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20.0,
                    width: 70.0,
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "Ties:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto'),
                    ),
                  ),
                  Container(
                    height: 20.0,
                    width: 50.0,
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      tie.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto'),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30.0,
                    width: 300.0,
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto'),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 85.0,
            width: 85.0,
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                if (_button6Press) {
                  _button6();
                  playLocal_swish();
                }
              },
              child: Text(
                _mBoard[6],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 65.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Container(
            height: 85.0,
            width: 85.0,
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                if (_button7Press) {
                  _button7();
                  playLocal_swish();
                }
              },
              child: Text(
                _mBoard[7],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 65.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Container(
            height: 85.0,
            width: 85.0,
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                if (_button8Press) {
                  _button8();
                  playLocal_swish();
                }
              },
              child: Text(
                _mBoard[8],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 65.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          )
        ],
      ),
    ]));
  }
}
