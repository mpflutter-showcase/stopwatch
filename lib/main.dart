import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

import 'stopwatch.dart';

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
        '/': (context) => StopWacth(),
      },
      navigatorObservers: [MPCore.getNavigationObserver()],
    );
  }
}
