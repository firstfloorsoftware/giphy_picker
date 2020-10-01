import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giphy Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GiphyGif _gif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gif?.title ?? 'Giphy Picker Demo'),
      ),
      body: SafeArea(
        child: Center(
          child: _gif == null ? Text('Pick a gif..') : GiphyImage.original(gif: _gif),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'fab_1',
            backgroundColor: Colors.purpleAccent,
            child: Icon(Icons.search),
            onPressed: () async {
              // request your Giphy API key at https://developers.giphy.com/
              final gif = await GiphyPicker.pickGif(context: context, apiKey: '[YOUR GIPHY APIKEY]');

              if (gif != null) {
                setState(() => _gif = gif);
              }
            },
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'fab_2',
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.search),
            onPressed: () async {
              // request your Giphy API key at https://developers.giphy.com/
              final gif = await GiphyPicker.pickGif(
                context: context,
                apiKey: '[YOUR GIPHY APIKEY]',
                fullScreenDialog: false,
                decorator: GiphyDecorator(
                  showAppBar: false,
                  searchElevation: 4,
                  giphyTheme: ThemeData.dark().copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              );

              if (gif != null) {
                setState(() => _gif = gif);
              }
            },
          ),
        ],
      ),
    );
  }
}
