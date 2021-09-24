import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: Icon(
            Icons.menu,
          ),
          title: Text('Speech to text In Flutter'),
          centerTitle: true,
        ),
        body: Speech(),
      ),
    );
  }
}

class Speech extends StatefulWidget {
  @override
  _SpeechState createState() => _SpeechState();
}

class _SpeechState extends State<Speech> {
  final FlutterTts flutterTts = FlutterTts();
  TextEditingController textEditingController = TextEditingController();
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  String _textValue = "Type to see";

  Future _speak(String text) async {
    await flutterTts.speak(text);
    //print(await flutterTts.getLanguages);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1); //0.5 to 1.5
    //await flutterTts.setSpeechRate(0.5);
  }

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        camera: _cameraOcr,
        waitTap: true,
      );

      setState(() {
        _textValue = texts[0].value;
      });
    } on Exception {
      texts.add(OcrText('Failed to recognize text.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Image(
            image: AssetImage('assets/Text-To-Speech pic.jpg'),
          )),
          SizedBox(
            height: 1,
          ),
          Container(
            width: 0.5 * MediaQuery.of(context).size.width,
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: ('Enter your text to hear audio')),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Icon(
              Icons.mic,
              size: 24,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
            onPressed: () => _speak(textEditingController.text),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'OR',
            style: TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(_textValue),
          Container(
            child: ElevatedButton(
                onPressed: () {
                  _read();
                },
                child: Text('Press here to hear scanned text'),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red))))),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
