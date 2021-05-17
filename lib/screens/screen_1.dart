import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wordxray/ad_Helper.dart';
import 'package:wordxray/models/appBar.dart';
import 'package:wordxray/screens/exp.dart';

class ScreenOne extends StatefulWidget {
  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  BannerAd _ad;
  bool isLoaded;
  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdListener(onAdLoaded: (_) {
        setState(() {
          isLoaded = true;
        });
      }, onAdFailedToLoad: (_, error) {
        print('Ad Failed to load with error: $error');
      }),
      request: AdRequest(),
    );
    _ad.load();
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  Widget checkForAd() {
    if (isLoaded == true) {
      return Container(
        child: AdWidget(
          ad: _ad,
        ),
        width: _ad.size.width.toDouble(),
        height: _ad.size.height.toDouble(),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  final myController = TextEditingController();
  String enteredWord;

  clear() {
    myController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: RoundedAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'Word',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 80)),
                  TextSpan(
                      text: 'X-Ray',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 40)),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: myController,
                onChanged: (String newValue) {
                  enteredWord = newValue;
                },
                decoration: InputDecoration(
                  hintText: "Enter a word",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(300, 40),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Experiment(
                        word: enteredWord,
                      );
                    },
                  ),
                );
                clear();
              },
              child: Text(
                "X-Ray Word",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            checkForAd()
          ],
        ),
      ),
    );
  }
}
