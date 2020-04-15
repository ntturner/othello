import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Othello',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.black,
      ),
      home: Othello(title: 'Othello'),
    );
  }
}

class Othello extends StatefulWidget {
  Othello({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _OthelloState createState() => _OthelloState();
}

class _OthelloState extends State<Othello> {
  static const _positionChecks = [-9, -8, -7, -1, 1, 7, 8, 9];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String currentColor = 'black';
  List<String> _spaceTypes = [];
  List<Widget> _gameBoard = [];

  _generateGameBoard(BuildContext context) {
    var spaces = List.generate(64, (index) {
      return (index == 19 || index == 26 || index == 37 || index == 44) ? _gameBoardSpace(context, 'highlight', index)
          : (index == 28 || index == 35) ? _gameBoardSpace(context, 'black') 
          : (index == 27 || index == 36) ? _gameBoardSpace(context, 'white')
          : _gameBoardSpace(context);
    });
    
    setState(() {
      _gameBoard = spaces;
    });
  }

  _resetGameBoard(BuildContext context) {
    setState(() {
      currentColor = 'black';
      _spaceTypes = [];
      _gameBoard = [];

      _generateGameBoard(context);
    });
  }

  Widget _gameBoardSpace(BuildContext context, [String spaceType, int index]) {
    setState(() {
      _spaceTypes.add(spaceType);
    });

    return Container(
      child: 
        (spaceType == 'highlight') ? _highlightedButton(context, index)
        : (spaceType == 'black') ? _blackToken() 
        : (spaceType == 'white') ? _whiteToken()
        : Container(),
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(
            width: 1,
            color: Colors.white,
          )
        )
    );
  }

  Widget _whiteToken() {
    return FractionallySizedBox(
      widthFactor: 0.75,
      heightFactor: 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle
        ),
      ),
    );
  }

  Widget _blackToken() {
    return FractionallySizedBox(
      widthFactor: 0.75,
      heightFactor: 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle
        ),
      ),
    );
  }

  _assignTokens(int index, List<String> newSpaceTypes, List<Widget> gamePieces) {
    for (int position in _positionChecks) {
      if (index + position > -1 && index + position < 64) {
        if (newSpaceTypes[index + position] != currentColor && newSpaceTypes[index + position] != null) {
          var inline = -1;
          var loopPosition = position;
          while (index + loopPosition > -1 && index + loopPosition < 64) {
            if (newSpaceTypes[index + loopPosition] == currentColor) {
              inline = index + loopPosition; 
              break;
            } else if (newSpaceTypes[index + loopPosition] == null) {
              inline = -1;
              break;
            } else {
              if ((index + loopPosition) % 8 == 0 || (index + loopPosition) % 8 == 7) {
                if (position == -9 || position == -1 || position == 7 || position == 9 || position == 1 || position == -7) {
                  inline = -1;
                  break;
                }
              }
              loopPosition += position;
            }
          }

          if (inline > -1) {
            loopPosition = position;
            while (index + loopPosition != inline) {
              // TODO: Investigate visual changes.
              // AnimationController. Timer event, maybe 100 ms or something. Disable user interface.
              // On the timer complete, call the set state.
              gamePieces[index + loopPosition] = currentColor == 'black' ? _gameBoardSpace(context, 'black') : _gameBoardSpace(context, 'white');
              newSpaceTypes[index + loopPosition] = currentColor == 'black' ? 'black' : 'white';
              loopPosition += position;
            }
          }
        }
      }
    }

    return [newSpaceTypes, gamePieces];
  }

  _assignHighlight(List<String> newSpaceTypes, List<Widget> gamePieces, String newCurrentColor) {
    for(int i = 0; i < newSpaceTypes.length; i++) {
      if (newSpaceTypes[i] == newCurrentColor) {
        for (int position in _positionChecks) {
          if (i + position > -1 && i + position < 64) {
            if (newSpaceTypes[i + position] != newCurrentColor && newSpaceTypes[i + position] != 'highlight' && newSpaceTypes[i + position] != null) {
              var highlightIndex = -1;
              var loopPosition = position;

              while (i + loopPosition > -1 && i + loopPosition < 64) {
                if (newSpaceTypes[i + loopPosition] == null) {
                  highlightIndex = i + loopPosition; 
                  break;
                } else if (newSpaceTypes[i + loopPosition] == newCurrentColor || newSpaceTypes[i + loopPosition] == 'highlight') {
                  highlightIndex = -1;
                  break;
                } else {
                  if ((i + loopPosition) % 8 == 0 || (i + loopPosition) % 8 == 7) {
                    if (position == 9 || position == 1 || position == -7 || position == -9 || position == -1 || position == 7) {
                      highlightIndex = -1;
                      break;
                    }
                  } 
                  loopPosition += position;
                }
              }
              
              if (highlightIndex > -1) {
                newSpaceTypes[highlightIndex] = 'highlight';
                gamePieces[highlightIndex] = _gameBoardSpace(context, 'highlight', highlightIndex);
              }
            }
          }
        }
      }
    }

    return [newSpaceTypes, gamePieces];
  }

  _highlightPress(BuildContext context, int index) {
    // Update game piece widgets array as well as space type tracking array.
    var gamePieces = List<Widget>.from(_gameBoard);
    var newSpaceTypes = List<String>.from(_spaceTypes);
    gamePieces[index] = currentColor == 'black' ? _gameBoardSpace(context, 'black') : _gameBoardSpace(context, 'white');
    newSpaceTypes[index] = currentColor == 'black' ? 'black' : 'white';

    for (int i = 0; i < newSpaceTypes.length; i++) {
      if (newSpaceTypes[i] == 'highlight') {
        newSpaceTypes[i] = null;
        gamePieces[i] = _gameBoardSpace(context);
      }
    }

    // Check the render queue. If it is not empty, check the timer. Lookup dart timer class, setTimeout.
    var results = _assignTokens(index, newSpaceTypes, gamePieces);
    newSpaceTypes = results[0];
    gamePieces = results[1];

    var newCurrentColor = currentColor == 'black' ? 'white' : 'black';
    results = _assignHighlight(newSpaceTypes, gamePieces, newCurrentColor);
    newSpaceTypes = results[0];
    gamePieces = results[1];

    bool noMove = true;
    for (var space in newSpaceTypes) {
      if (space == 'highlight') {
        noMove = false;
        break;
      }
    }

    if(noMove == true) {
      newCurrentColor = currentColor;
      results = _assignHighlight(newSpaceTypes, gamePieces, newCurrentColor);
      newSpaceTypes = results[0];
      gamePieces = results[1];

      for (var space in newSpaceTypes) {
        if (space == 'highlight') {
          noMove = false;
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text((newCurrentColor == 'black' ? 'White' : 'Black') + ' cannot move! ' + (newCurrentColor == 'black' ? 'Black' : 'White') + ' goes again.'),
            )
          );
          break;
        }
      }
    }
    
    // TODO: Await for set state, then run end game function.
    if(noMove == true) {
      setState(() {
        _gameBoard = gamePieces;
        _endGame(context);
      });
    } else {
      setState(() {
        _gameBoard = gamePieces;
        _spaceTypes = newSpaceTypes;
        currentColor = newCurrentColor;        
      });
    }
  }

  _endGame(BuildContext context) {
    var white = 0;
    var black = 0;

    for (var space in _spaceTypes) {
      if (space == 'black') {
        black++;
      } else if (space == 'white') {
        white++;
      }
    }

    var winner = black > white ? 'Black' : white > black ? 'White' : 'Tie';

    _resetDialog(context, winner != 'Tie' ? winner + ' wins!' : 'Tie game!', 'Would you like to play again?');
  }
  
  _resetDialog(BuildContext context, String title, String body) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Container(
              child: Text(body),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGameBoard(context);
              },
            ),
          ],
        );
      },
    );
  }
  
  Widget _highlightedButton(BuildContext context, int index) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[300].withOpacity(0.6),
          border: Border.all(
            width: 5, 
            color: Colors.yellow[300]
          )
        ),  
      ),
      onPressed: () => _highlightPress(context, index)
    );
  }

  Widget _currentColorIndicator(BuildContext context) {
    return Container(
      child: 
        (currentColor == 'black') ? _blackToken() 
        : _whiteToken(),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          width: 1,
          color: Colors.white,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_gameBoard.length < 1) {
      _generateGameBoard(context);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: () {
              _resetDialog(context, 'Reset game?', 'Current progress will be lost.');
            }
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: GridView.count(
                // Create a grid with 8 columns and 64 objects total.
                // TODO: Add preview widget (for current color).
                // TODO: Add replay button.
                shrinkWrap: true,
                crossAxisCount: 8,
                children: _gameBoard,
              )
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Current piece: ', 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 5.0),
              child: _currentColorIndicator(context),
            )
          )
        ],
      )
    );
  }
}
