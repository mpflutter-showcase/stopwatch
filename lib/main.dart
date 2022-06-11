import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

import 'analog_clock.dart';

void main() {
  runApp(MyApp());
  MPCore().connectToHostChannel();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MPApp(
      title: 'MPFlutter Demo',
      color: Colors.blue,
      routes: {
        '/': (context) => MyHomePage(),
      },
      navigatorObservers: [MPCore.getNavigationObserver()],
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MPScaffold(
      name: 'Analog Clock',
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.amberAccent, Colors.amber],
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            child: AnalogClock(
              width: 300.0,
              height: 300.0,
              isLive: true,
              hourHandColor: Colors.black,
              minuteHandColor: Colors.black,
              showSecondHand: true,
              numberColor: Colors.black87,
              showNumbers: true,
              textScaleFactor: 1.4,
              showTicks: true,
              tickColor: Colors.black,
              showDigitalClock: true,
            ),
          ),
        ),
      ),
    );
  }
}
