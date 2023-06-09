import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin_checker_app/models/data_model.dart';
import 'package:vin_checker_app/screens/home_screen.dart';
import 'package:vin_checker_app/utils/input_formatter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  GetStorage box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        title: SizedBox(child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/logo.png"),
        ),height: 100, width: 100, ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.maxFinite,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bacground.jpg", ),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)

              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_text, textAlign: TextAlign.justify, style: GoogleFonts.aldrich(color: Colors.white, fontSize: 20), ),
              ),
              Spacer(flex: 3,),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: ()async{
                    await _launchUrl();
                  },
                  child: Text.rich(
                    TextSpan(
                      text:"Your continued use of the app indicates your acceptance ",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      children: [
                        TextSpan(text: "privacy and policy ",
                        style: TextStyle(color: Colors.blue, fontSize: 15)
                        ),
                        TextSpan(text: "of this terms",
                            style: TextStyle(color: Colors.white, fontSize: 15)
                        )
                      ]
                    )
                  ),
                ),
              ),

              ElevatedButton(onPressed: (){
                box.write("intro", true);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen("")));
              }, child: Text("    CONTINUE   ", style: GoogleFonts.aldrich(fontSize: 30),)),
              Spacer()
            ],
          )),
    );
  }

  String _privacyText = "Your continued use of the app indicates your acceptance of the terms outlined in this policy.";
  String _text = "Unlock the power of information with VIN Checker, the cutting-edge Android app designed to provide you with instant access to comprehensive vehicle details right at your fingertips. Whether you're buying a used car, selling your vehicle, or simply curious about its history, VIN Checker is your go-to companion for decoding the secrets hidden within a vehicle identification number (VIN).";
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
  final Uri _url = Uri.parse('https://flutter.dev');

}



