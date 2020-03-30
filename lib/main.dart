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
      onPressed: () {
        var gamePieces = new List<Widget>.from(_gameBoard);
        gamePieces[index] = currentColor == 'black' ? _gameBoardSpace(context, 'black') : _gameBoardSpace(context, 'white');

        for (int position in _positionChecks) {
          if (index + position > -1 && index + position < 64) {
            if (_spaceTypes[index + position] != currentColor && _spaceTypes[index + position] != 'highlight' && _spaceTypes[index + position] != null) {
              var inline = -1;
              var loopPosition = position;
              while (index + loopPosition > -1 && index + loopPosition < 64) {
                if (_spaceTypes[index + loopPosition] == currentColor) {
                  inline = index + loopPosition; 
                  break;
                } else {
                  loopPosition += loopPosition;
                }
              }

              if (inline > -1) {
                loopPosition = position;
                while (index + loopPosition != inline) {
                  gamePieces[index + loopPosition] = currentColor == 'black' ? _gameBoardSpace(context, 'black') : _gameBoardSpace(context, 'white');
                  loopPosition += loopPosition;
                }
              }
            }
          }
        }
        
        setState(() {
          _gameBoard = gamePieces;
          currentColor = currentColor == 'black' ? 'white' : 'black';
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            crossAxisCount: 8,
            children: _gameBoard,
          )
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
