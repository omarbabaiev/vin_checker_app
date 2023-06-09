import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vin_checker_app/models/data_model.dart';
import 'package:vin_checker_app/screens/home_screen.dart';
import 'package:vin_checker_app/screens/result_screen.dart';
import 'package:vin_checker_app/utils/input_formatter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;



class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  GetStorage box = GetStorage();
  var vin = "";
  late VinModel json;
  var listVin,
      listMan,
      listMod,
      listDate;

  Future<void> _fetchAndSendData(vinCode) async {
      final response = await http.get(Uri.parse(
          "https://vpic.nhtsa.dot.gov/api/vehicles/decodevin/${vinCode}?format=json"));
      json = VinModel.fromJson(jsonDecode(response.body.toString()));

    }

    @override
    void initState() {
      // TODO: implement initState
      listVin = box.read("historyVinCodes") ?? [];
      listMan = box.read("historyCarManufacturers") ?? [];
      listMod = box.read("historyCarModels") ?? [];
      listDate = box.read("historyDateTime") ?? [];
      super.initState();
    }
    @override
    Widget build(BuildContext context) {
      var _width = MediaQuery
          .of(context)
          .size
          .width;


      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text("Recent VIN codes", style: GoogleFonts.aldrich(
              fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),),
        ),

        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: AnimationLimiter(
                child: ListView.builder(
                    itemCount: box
                        .read("historyVinCodes")
                        .length,
                    itemBuilder: (BuildContext context, index) {
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
                                onTap: () async {
                                  await _fetchAndSendData(
                                      listVin[index].toString());
                                  Navigator.push(context, CupertinoPageRoute(
                                      builder: (context) =>
                                          ResultScreen(json,
                                              listVin[index].toString())));
                                },
                                title: Text("${box.read(
                                    "historyCarManufacturers")[index]} ${
                                    listMod =
                                    box.read("historyCarModels")[index]}",
                                  style: GoogleFonts.aldrich(
                                      fontWeight: FontWeight.bold),),
                                subtitle: Text(
                                  box.read("historyVinCodes")[index],
                                  style: GoogleFonts.aldrich(),),
                                trailing: Text(
                                  box.read("historyDateTime")[index].toString(),
                                  style: GoogleFonts.aldrich(),),
                              ),
                              margin: EdgeInsets.only(bottom: _width / 20),
                              height: _width / 6,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20)),
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
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bacground.jpg",),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.red, BlendMode.colorBurn)

                )
            ),
          ),
        ),
      );
    }
  }

