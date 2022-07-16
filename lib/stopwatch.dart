import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mpcore/mpkit/mpkit.dart';

class StopWacth extends StatefulWidget {
  const StopWacth({Key? key}) : super(key: key);

  @override
  State<StopWacth> createState() => _StopWacthState();
}

class _StopWacthState extends State<StopWacth> {
  var _started = false;
  DateTime? _startTime;
  Duration? _stopOnDuration;
  DateTime? _lastStepTime;
  final List<Duration> _steps = [];

  void _doStart() {
    setState(() {
      _started = true;
      if (_startTime != null && _stopOnDuration != null) {
        _startTime = DateTime.now().add(-_stopOnDuration!);
        _lastStepTime = DateTime.now();
      } else {
        _startTime = DateTime.now();
        _lastStepTime = DateTime.now();
      }
    });
  }

  void _doStop() {
    setState(() {
      if (_startTime != null) {
        _stopOnDuration = DateTime.now().difference(_startTime!);
      }
      _started = false;
    });
  }

  void _doReset() {
    setState(() {
      _startTime = null;
      _stopOnDuration = null;
      _lastStepTime = null;
      _steps.clear();
    });
  }

  void _doStep() {
    if (_lastStepTime == null) return;
    final currentStep = DateTime.now().difference(_lastStepTime!);
    _lastStepTime = DateTime.now();
    setState(() {
      _steps.add(currentStep);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MPScaffold(
      name: 'StopWatch',
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 66),
          WacthSurface(
            startTime: _startTime,
            started: _started,
          ),
          SizedBox(height: 66),
          Row(
            children: [
              SizedBox(width: 36),
              _started ? _renderStepButton() : _renderResetButton(),
              Spacer(),
              _started ? _renderStopButton() : _renderStartButton(),
              SizedBox(width: 36),
            ],
          ),
          SizedBox(height: 18),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final currentStep = _steps[_steps.length - 1 - index];
                final m = currentStep.inMinutes.toString().padLeft(2, '0');
                final s =
                    (currentStep.inSeconds % 60).toString().padLeft(2, '0');
                final ms = ((currentStep.inMilliseconds % 1000) / 10)
                    .toStringAsFixed(0)
                    .padLeft(2, '0');
                return Container(
                  height: 36,
                  child: Row(
                    children: [
                      SizedBox(width: 36),
                      Text(
                        '计次 ${(_steps.length - index).toString()}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Spacer(),
                      Text(
                        '$m:$s.$ms',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(width: 36),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: 32, right: 32),
                  height: 1,
                  color: Colors.white10,
                );
              },
              itemCount: _steps.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderResetButton() {
    return ClipOval(
      child: GestureDetector(
        onTap: () {
          _doReset();
        },
        child: Container(
          width: 72,
          height: 72,
          color: Colors.blueGrey.withOpacity(0.5),
          child: Center(
            child: const Text(
              '复位',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderStepButton() {
    return ClipOval(
      child: GestureDetector(
        onTap: () {
          _doStep();
        },
        child: Container(
          width: 72,
          height: 72,
          color: Colors.blueGrey.withOpacity(0.5),
          child: Center(
            child: const Text(
              '计次',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderStartButton() {
    return ClipOval(
      child: GestureDetector(
        onTap: () {
          _doStart();
        },
        child: Container(
          width: 72,
          height: 72,
          color: Colors.green,
          child: Center(
            child: const Text(
              '启动',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderStopButton() {
    return ClipOval(
      child: GestureDetector(
        onTap: () {
          _doStop();
        },
        child: Container(
          width: 72,
          height: 72,
          color: Colors.red,
          child: Center(
            child: const Text(
              '停止',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class WacthSurface extends StatefulWidget {
  final DateTime? startTime;
  final bool started;

  WacthSurface({
    Key? key,
    this.startTime,
    required this.started,
  }) : super(key: key);

  @override
  State<WacthSurface> createState() => _WacthSurfaceState();
}

class _WacthSurfaceState extends State<WacthSurface> {
  Duration _currentTime = Duration.zero;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WacthSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.started && _timer == null) {
      _setupTimer();
    } else if (!widget.started && _timer != null) {
      _timer?.cancel();
      _timer = null;
    } else if (widget.startTime == null) {
      setState(() {
        _currentTime = Duration.zero;
      });
    }
  }

  void _setupTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 32), (timer) {
      if (widget.startTime == null) return;
      if (!widget.started) return;
      setState(() {
        _currentTime = DateTime.now().difference(widget.startTime!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final m = _currentTime.inMinutes.toString().padLeft(2, '0');
    final s = (_currentTime.inSeconds % 60).toString().padLeft(2, '0');
    var ms = ((_currentTime.inMilliseconds % 1000) / 10)
        .toStringAsFixed(0)
        .padLeft(2, '0');
    if (ms.length >= 3) {
      ms = "99";
    }
    return Container(
      height: 72,
      child: MPText(
        '$m:$s.$ms',
        style: TextStyle(
          fontSize: 64,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        noMeasure: true,
      ),
    );
  }
}
