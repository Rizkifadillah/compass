import 'package:flutter/material.dart';
import 'package:compasstools/compasstools.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as prefix0;

//void main(){
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//      .then((_){
//    runApp(MyApp());
//  });
//}

void main() => runApp(MyApp());
//void main() async {
//  ///
//  /// Force the layout to Portrait mode
//  ///
//  await SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown
//  ]);
//
//  runApp(new MyApp());
//}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _haveSensor;
  String sensorType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkDeviceSensors();
  }

  Future<void> checkDeviceSensors()async{
    int haveSensor;

    try{
      haveSensor = await Compasstools.checkSensors;

      switch(haveSensor){
        case 0: {
          sensorType="No sensors for compass!";
        }
        break;

        case 1: {
          sensorType="AcceleroMeter + MagnetoMeter";
        }
        break;
        case 2: {
          sensorType="Gyroscope";
        }
        break;
        default: {
          sensorType="Error";
        }
        break;

      }
    }on Exception{

    }

    if(!mounted) return;
    setState(() {
      _haveSensor =haveSensor;
    });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
//                height: MediaQuery.of(context).size.height,
//                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("img/bgcompas.jpg"),fit:BoxFit.cover)
                ),
              ),
              BackdropFilter(
                filter: prefix0.ImageFilter.blur(sigmaX: 4,sigmaY: 4),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.6)
                  ),
                ),
              ),
//              Image.asset("img/bgcompas.jpg"),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder(
                    stream: Compasstools.azimuthStream,
                    builder: (BuildContext context,AsyncSnapshot<int> snapshot){
                      if(snapshot.hasData){
                        return Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation(
                                  -snapshot.data/360
                              ),
                              child: Image.asset("img/compass.png"),
                            ),
                          ),
                        );
                      }
                      else
                        return Text("Error in stream",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey
                        ),);
                    },
                  ),
                  Text("SensorType "+sensorType,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800]
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
