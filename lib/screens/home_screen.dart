import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin_checker_app/models/data_model.dart';
import 'package:vin_checker_app/screens/history_screen.dart';
import 'package:vin_checker_app/screens/result_screen.dart';
import 'package:vin_checker_app/utils/input_formatter.dart';
import 'package:vin_checker_app/utils/qr_code_screen.dart';

import '../utils/page_transitions.dart';

class HomeScreen extends StatefulWidget {
  final String barcode;

  HomeScreen(this.barcode);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController _vcController = TextEditingController();
  var vin = "";
  var _isLoading = false;
  late VinModel json;

  Future<void>_fetchAndSendData(vinCode)async{
    if(vin.length == 17){
      setState(() {
        _isLoading = true;
      });
      final response = await http.get(Uri.parse("https://vpic.nhtsa.dot.gov/api/vehicles/decodevin/${vinCode}?format=json"));
      if(response.statusCode==200){
        json = VinModel.fromJson(jsonDecode(response.body.toString()));
        setState(() {
          _isLoading = false;
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.statusCode}")));
      }
    }


  }

@override
  void initState() {
      _vcController.text = widget.barcode.toString();


    _isLoading = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF570C05),
      appBar: AppBar(
        actions: [],
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bacground.jpg", ),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)

            )
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(child: Image.asset("assets/logo.png"),height: 100, width: 100, ),
                  SizedBox(height: _height/7,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Stay informed and make informed decisions with our user-friendly VIN Code checker app.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.alatsi(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
                  ),
                  SizedBox(height: _height/6,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex: 2,
                          child: Container(child: FittedBox(child:
                            IconButton(icon: Icon(Icons.qr_code_scanner_rounded, color: Colors.indigoAccent,),
                              onPressed: () {
                             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BarcodeScannerWithZoom()));
                              },)),
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17)

                            ),
                          ),
                        ),

                        Spacer(),
                        Expanded(flex: 2,
                          child: Container(child: FittedBox(child:
                         _vcController.text == "" ? IconButton(icon: Icon(Icons.paste_outlined, color: Colors.indigoAccent,),
                            onPressed: ()  async {
                              Clipboard.getData(Clipboard.kTextPlain).then((value){
                                setState(() {
                                  vin =  value!.text.toString();
                                  _vcController.text =  value!.text.toString();

                                });
                              });
                            },) : IconButton(icon: Icon(Icons.clear, color: Colors.red,),
                           onPressed: (){
                            setState(() {
                              _vcController.clear();
                              vin = "";

                            });
                           },) ),
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17)

                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(flex: 2,
                          child: Container(child: FittedBox(child:
                          IconButton(icon: Icon(Icons.history, color: Colors.indigoAccent,),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HistoryScreen()));
                            },)),
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17)

                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,),
                  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.white
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: TextField(
                            cursorOpacityAnimates: true,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            inputFormatters: [
                              UpperCaseTextFormatter()
                            ],
                            selectionHeightStyle: BoxHeightStyle.max,
                            onChanged: (value){
                              setState(() {
                             vin = value.toUpperCase();
                              });
                            },
                            controller: _vcController,
                            style: GoogleFonts.aldrich(fontSize: 18, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintStyle: GoogleFonts.aldrich(fontSize: 18),
                            // suffix: ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.search, color: Colors.black,), label: Text("Check", style: GoogleFonts.aldrich(color: Colors.white),),
                            //   style: ElevatedButton.styleFrom(backgroundColor: _vcController.text.length == 17 ? Colors.green : Colors.red,  ),),
                            hintText: "Check your VIN",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none
                            ),
          ),

    ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: ()async{
                              FocusManager.instance.primaryFocus?.unfocus();
                              if(vin.length == 17){
                                try{
                                  await _fetchAndSendData(vin);
                                  if(mounted){

                                    Navigator.push(
                                        context, SlideTransition1(ResultScreen(json, vin)));
                                  }
                                }catch(e){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                }
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  showCloseIcon: true,
                                  content: Text("Vin code should be less than 17 characters", style: GoogleFonts.aldrich(color: Colors.white, fontWeight: FontWeight.bold)),
                                  behavior: SnackBarBehavior.floating,));
                              }
                            },

                            child: _isLoading ? Center(child: CircularProgressIndicator(),) : Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.search),
                                  Text("Check", style: GoogleFonts.aldrich(color: Colors.black, fontWeight: FontWeight.bold),)
                                ],
                              ),
                              width: 70,
                              height: 65,
                              decoration: BoxDecoration(
                                gradient:
                                (vin.length == 0)||(vin.length == 17) ? LinearGradient(colors: [Colors.green, Colors.greenAccent]) :
                                LinearGradient(colors: [Colors.red, Colors.red.shade300]),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(17), bottomRight: Radius.circular(17))
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
                  SizedBox(
                    height: 10,
                  ),
                  SelectableText("Example: KNDJ23AU4N7154467", style: GoogleFonts.aldrich(color: Colors.white70),),
                  SizedBox(
                    height: _height/8,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Powered by \nLezginDev",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.alatsi(fontSize: 25, color: Colors.white60),),
                  ),


                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
}
