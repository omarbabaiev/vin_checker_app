import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin_checker_app/models/data_model.dart';
import 'package:vin_checker_app/utils/input_formatter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_storage/get_storage.dart';



class ResultScreen extends StatefulWidget {

  final VinModel data;
  final String vin;


  ResultScreen(this.data, this.vin);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var vin = "";
  var historyVinCodes = [];
  var historyCarModels = [];
  var historyCarManufacturers = [];
  var historyDateTime = [];

  GetStorage box = GetStorage();
  void _saveData(){
    historyVinCodes = box.read("historyVinCodes")??[];
    historyVinCodes.add(widget.vin);


    historyCarModels = box.read("historyCarModels")??[];
    historyCarModels.add(widget.data.results[9].value);

    historyCarManufacturers = box.read("historyCarManufacturers")??[];
    historyCarManufacturers.add(widget.data.results[7].value);

    historyDateTime = box.read("historyDateTime")??[];
    historyDateTime.add("${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
  }
@override
  void initState() {
_saveData();

    super.initState();
  }
  @override
  void dispose() {
    box.write("historyVinCodes", historyVinCodes);
    box.write("historyCarModels", historyCarModels);
    box.write("historyCarManufacturers", historyCarManufacturers);
    box.write("historyDateTime", historyDateTime);

    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;


    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Check Results", style: GoogleFonts.aldrich(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),),
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: widget.data.results.length,
                  itemBuilder: (BuildContext context, index){
                return AnimationConfiguration.staggeredList(
                  delay: Duration(milliseconds: 100),
                  child: SlideAnimation(
                    duration: Duration(milliseconds: 2500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    verticalOffset: -250,
                    child: ScaleAnimation(
                      duration: Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: Container(
                        child: ListTile(
                          title: Text(widget.data.results[index].value.toString() == "null"
                              ? "${"data not found"}" : widget.data.results[index].value, style: GoogleFonts.aldrich(fontWeight: FontWeight.bold),),
                          subtitle: Text("${widget.data.results[index].variable}", style: GoogleFonts.aldrich(),),
                        ),
                        margin: EdgeInsets.only(bottom: _width / 20),
                        height: _width / 6,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  position: index,

                );
              }),
            ),
          ),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bacground.jpg", ),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)

              )
          ),
        ),
      ),
    );
  }
}

