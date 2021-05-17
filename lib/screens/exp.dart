import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:wordxray/models/appBar.dart';

class Experiment extends StatefulWidget {
  final String word;
  Experiment({this.word});
  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  var result2;
  Future getData() async {
    http.Response response = await http.get(Uri.parse(
        "https://api.dictionaryapi.dev/api/v2/entries/en_US/${widget.word}"));
    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        result2 = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Text returnText() {
    if (result2[0]['meanings'][0]['definitions'][0]['synonyms'] == null)
      return Text(
        "No Synonyms Found",
        style: TextStyle(fontSize: 23, color: Colors.red.shade600),
      );
    return Text(
      'Synonyms: ${result2[0]['meanings'][0]['definitions'][0]['synonyms'].toString()}',
      style: TextStyle(fontSize: 23, color: Colors.green.shade900),
    );
  }

  Text returnHeadText() {
    if (widget.word == null)
      return Text("Please enter a word",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold));
    return Text(
      widget.word,
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }

  Text phonetics() {
    if (result2[0]['phonetics'][0]['text'].isEmpty) {
      return Text('Not Available');
    } else
      return Text(
        'Phonetics: ${result2[0]['phonetics'][0]['text']}'.toString(),
        style: TextStyle(fontSize: 23),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(),
      body: result2 == null
          ? Container(
              child: Center(
                // child: Text(
                //   "Loading",
                //   style: TextStyle(fontSize: 25),
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadingText(
                      "Loading....",
                      style: TextStyle(fontSize: 25),
                    ),
                    DelayedDisplay(
                      delay: Duration(seconds: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Taking longer than usual! There might be some typos.. or word is not available.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      returnHeadText(),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          phonetics(),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      await assetsAudioPlayer.open(
                                        Audio.network(
                                            "${result2[0]['phonetics'][0]['audio']}"),
                                      );
                                    } catch (t) {
                                      //mp3 unreachable
                                    }
                                  },
                                  // AudioPlayer()
                                  //     .play("result2[0]['phonetics'][0]['audio']");

                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.orange,
                                    child: Icon(
                                      Icons.volume_up,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Definition: ${result2[0]['meanings'][0]['definitions'][0]['definition']}'
                            .toString(),
                        style: TextStyle(
                            fontSize: 25, color: Colors.green.shade700),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Synonyms:",
                        style: TextStyle(fontSize: 23, color: Colors.black),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: result2[0]['meanings'][0]['definitions'][0]
                                    ['synonyms'] ==
                                null
                            ? 1
                            : result2[0]['meanings'][0]['definitions'][0]
                                    ['synonyms']
                                .length,
                        itemBuilder: (context, index) {
                          // return returnText();
                          return result2[0]['meanings'][0]['definitions'][0]
                                      ['synonyms'] ==
                                  null
                              ? Text(
                                  'No Synonyms Found',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red),
                                )
                              : Text(
                                  result2[0]['meanings'][0]['definitions'][0]
                                          ['synonyms'][index]
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 23,
                                      color: Colors.green.shade900),
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
