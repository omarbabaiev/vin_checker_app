import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vin_checker_app/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class BarcodeScannerWithZoom extends StatefulWidget {
  const BarcodeScannerWithZoom({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWithZoomState createState() => _BarcodeScannerWithZoomState();
}

class _BarcodeScannerWithZoomState extends State<BarcodeScannerWithZoom>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? barcode;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
  );

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen("")));
        }, icon: Icon(Icons.cancel_outlined, color: Colors.white,),),

        actions: [

        ],
        backgroundColor: Colors.transparent,
        title:  SizedBox(child: Image.asset("assets/logo.png"),height: 80, width: 100, ),
        centerTitle: true,
      ),      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bacground.jpg", ),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)

                    )
                ),
                child: MobileScanner(
                  placeholderBuilder: (BuildContext context, Widget){
                    return Container(
                      child: Image.asset("assets/logo.png"),
                    );

                },
                  controller: controller,
                  fit: BoxFit.contain,
                  onDetect: (barcode) {
                    // Navigator.pop(context, MaterialPageRoute(builder: (context)=>HomeScreen(barcode!.barcodes.first.rawValue.toString())));
                    showBottomSheet(context: context, builder: (context){
                      return Container(
                        height: 300,
                        child: AlertDialog(
                          title: Text(barcode!.barcodes.first.rawValue.toString()),
                          actions: [
                            ElevatedButton(onPressed: (){
                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(barcode!.barcodes.first.rawValue.toString())));

                            }, child: Text("Accept")),
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text("Cancel")),


                          ],
                        ),
                      );
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  barcode?.barcodes.first.rawValue ??
                      'Loading',
                  overflow: TextOverflow.fade,
                    style: GoogleFonts.alatsi(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white)
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
