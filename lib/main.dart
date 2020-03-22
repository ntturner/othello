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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
            // Create a grid with 8 columns and 64 objects total.
            crossAxisCount: 8,
            children: List.generate(64, (index) {
              return Container(
                // Hard coded the indices for the highlighting box and for the circles for example code.
                // TODO: Split functionality, render highlighting buttons and game tiles dynamically.
                child: (index == 20 || index == 29 || index == 34 || index == 43) ? FlatButton(
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
                  onPressed: () => {
                    print('Pressed')
                  }
                ) 
                : (index == 27 || index == 36) ? FractionallySizedBox(
                  widthFactor: 0.75,
                  heightFactor: 0.75,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle
                    ),
                  ),
                ) 
                : (index == 28 || index == 35) ? FractionallySizedBox(
                  widthFactor: 0.75,
                  heightFactor: 0.75,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                  ),
                ) 
                : Container(),
                  decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  )
                ) 
              );
            }),
          )
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
