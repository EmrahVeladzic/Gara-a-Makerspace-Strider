import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermission(Permission.bluetooth);
  requestPermission(Permission.bluetoothConnect);
  requestPermission(Permission.bluetoothScan);
  runApp(const StriderApp());
}

Future<void> requestPermission(Permission permission) async {

    await permission.request();
  
}

class StriderApp extends StatelessWidget {
  const StriderApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      title: 'Strider',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 253, 203, 0),
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Controller'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

bool connected = false;
String lasIn = "X";

class MainPageState extends State<MainPage> {
  BluetoothState bTS = BluetoothState.UNKNOWN;
  late BluetoothDevice striderInstance;
  late BluetoothConnection connectionToStrider;
 

  void bluetoothWrite(String input) {
    if(connected==true &&input!=lasIn){
    connectionToStrider.output.add(utf8.encode(input));
    lasIn=input;
    }
  }


  @override
  void initState() {
    super.initState();
    btsGetter();
    stateListener();
  }

  btsGetter() {
    FlutterBluetoothSerial.instance.state.then((state) {
      bTS = state;
      setState(() {});
    });
  }

  stateListener() {
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bTS = state;

      setState(() {});
    });
  }

  Future<bool> getDevice() async {
    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();

    for (BluetoothDevice dev in devices) {
      if (dev.name == "Strider") {
        try {
        striderInstance = dev;
        connectionToStrider =
          await BluetoothConnection.toAddress(striderInstance.address);
        return true;

        }catch(e){
            //No Need to do anything

        }
        
      }
    }

    return false;
  }

  throwDevice() {
    connectionToStrider.close();
    connectionToStrider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255,0,0,0),
        
        title: Text(widget.title ,style:const TextStyle(color:  Color.fromARGB(255, 253, 203, 0))),
      ),
      body: Wrap(children: [
     
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FractionallySizedBox(
              widthFactor: 0.75,
             
              child: FloatingActionButton(
                 backgroundColor: const Color.fromARGB(255, 253, 203, 0),
                  child: connected
                  
                      ? const Text("Disconnect")
                      : const Text("Connect to a nearby Strider"),
                  onPressed: () async {
                    bool connectedStatus = false;

                    if (connected) {
                      await FlutterBluetoothSerial.instance.requestDisable();
                      throwDevice();
                    } else {
                      await FlutterBluetoothSerial.instance.requestEnable();
                      connectedStatus = await getDevice();
                    }

                    setState(() {
                      connected = connectedStatus;
                    });
                  })),
),

 SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/4,
),

SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FractionallySizedBox(
              widthFactor: 0.25,
             
              child: FloatingActionButton(
                 backgroundColor: const Color.fromARGB(255, 253, 203, 0),
                 child: const Text("↑",textScaler:TextScaler.linear(2)),
                  
                  onPressed: () async {
                   
                   bluetoothWrite("W");

                   
                  })),
),

SizedBox(
 width: MediaQuery.of(context).size.width,
child: FractionallySizedBox(widthFactor: 0.75,

child: Row(
  children: <Widget>[
    Expanded(
       child: FloatingActionButton(
                 backgroundColor: const Color.fromARGB(255, 253, 203, 0),
                 child: const Text("<",textScaler:TextScaler.linear(2)),
                  
                  onPressed: () async {
                   
                     bluetoothWrite("A");
                   
                  }),
    ),
    Expanded(
      child: FloatingActionButton(
                 backgroundColor: const Color.fromARGB(255, 253, 203, 0),
                 child: const Text("·",textScaler:TextScaler.linear(2)),
                  
                  onPressed: () async {
                   
                     bluetoothWrite("X");
                   
                  }),
    ),
    Expanded(
      child: FloatingActionButton(
                 backgroundColor: const Color.fromARGB(255, 253, 203, 0),
                 child: const Text(">",textScaler:TextScaler.linear(2)),
                  
                  onPressed: () async {
                   
                     bluetoothWrite("D");
                   
                  })
    )
  ],
),


)


),


SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FractionallySizedBox(
              widthFactor: 0.25,
             
              child: FloatingActionButton(
                 backgroundColor: const Color.fromARGB(255, 253, 203, 0),
                 child: const Text("↓",textScaler:TextScaler.linear(2)),
                  
                  onPressed: () async {
                   
                       bluetoothWrite("S");
                   
                  })),
),




]
    ));
  }
}
