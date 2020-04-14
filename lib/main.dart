import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _positionChecks = [-9, -8, -7, -1, 1, 7, 8, 9];

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
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('No moves available for ' + newCurrentColor == 'black' ? 'white' : 'black' + '; ' + newCurrentColor + ' gets another turn.'),
            )
          );
          break;
        }
      }
    }
    
    // TODO: Await for set state, then run end game function.
    setState(() {
      _gameBoard = gamePieces;
      _spaceTypes = newSpaceTypes;
      currentColor = newCurrentColor;
    });
  }

  _endGame() {

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

  @override
  Widget build(BuildContext context) {
    if (_gameBoard.length < 1) {
      _generateGameBoard(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
            // Create a grid with 8 columns and 64 objects total.
            // TODO: Add preview widget (for current color).
            // TODO: Add replay button.
            crossAxisCount: 8,
            children: _gameBoard,
          )
      ),
    );
  }
}
