import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(const StriderApp());
}

class StriderApp extends StatelessWidget {
  const StriderApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return MaterialApp(
      title: 'Strider',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
double lastL = 0.0;
double lastR = 0.0;

class MainPageState extends State<MainPage> {
  BluetoothState bTS = BluetoothState.UNKNOWN;

  void _axisChange(bool lR, double value) {
    setState(() {
      if (lR) {
        lastL = value;
      } else {
        lastR = value;
      }
    });
    calculateInput();
  }

  void bluetoothWrite(String input) {}

  void calculateInput() {
    if (lastL > 0.125) {
      if (lastR > 0.125) {
        bluetoothWrite("W");
      } else if (lastR < -0.125) {
        bluetoothWrite("D");
      } else {
        bluetoothWrite("Q");
      }
    } else if (lastL < -0.125) {
      if (lastR > 0.125) {
        bluetoothWrite("A");
      } else if (lastR < -0.125) {
        bluetoothWrite("S");
      } else {
        bluetoothWrite("Y");
      }
    } else {
      if (lastR > 0.125) {
        bluetoothWrite("E");
      } else if (lastR < -0.125) {
        bluetoothWrite("C");
      } else {
        bluetoothWrite("0");
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: lastL,
              min: -1.0,
              max: 1.0,
              divisions: 200,
              onChanged: (value) {
                _axisChange(true, value);
              },
              onChangeEnd: (value) {
                setState(() {
                  lastL = 0.0;
                });
              },
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: FractionallySizedBox(
              widthFactor: 0.75,
              child: FloatingActionButton(
                  child: connected
                      ? const Text("Disconnect")
                      : const Text("Connect to a nearby Strider"),
                  onPressed: () {
                    future() async {
                      if (connected) {
                        await FlutterBluetoothSerial.instance.requestDisable();
                      } else {
                        await FlutterBluetoothSerial.instance.requestEnable();
                      }
                    }

                    future().then((value) {
                      setState(() {
                        connected = !connected;
                      });
                    });
                  })),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: lastR,
              min: -1.0,
              max: 1.0,
              divisions: 200,
              onChanged: (value) {
                _axisChange(false, value);
              },
              onChangeEnd: (value) {
                setState(() {
                  lastR = 0.0;
                });
              },
            ),
          ),
        ),
      ]),
    );
  }
}
