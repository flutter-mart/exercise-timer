import "package:flutter/material.dart";
import 'package:flutter_spinbox/material.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:audioplayers/audio_cache.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise Timer Route',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => ExerciseStart(),
        '/start': (BuildContext context) => Exercise(),
        '/finished': (BuildContext context) => ExerciseFinished(),
      },
    ),
  );
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Exercise(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class ExerciseTime {
  double exerciseTime;
  double exerciseBreakTime;
  double exerciseTotalCycle;

  ExerciseTime(
      {this.exerciseTime, this.exerciseBreakTime, this.exerciseTotalCycle});
}

class ExerciseStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Timer"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        heightFactor: 14.0,
        child: RaisedButton(
          child: Text("Start Exercise"),
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
        ),
      ),
    );
  }
}

class Exercise extends StatefulWidget {
  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  ExerciseTime _exercise;

  @override
  // ignore: must_call_super
  void initState() {
    this._exercise = ExerciseTime();
    this._exercise.exerciseTime = 0;
    this._exercise.exerciseBreakTime = 0;
    this._exercise.exerciseTotalCycle = 0;
  }

  void _handleChangeExerciseTime(event) {
    try {
      this._exercise.exerciseTime = event;
    } catch (ex) {
      print(ex.toString());
    }
  }

  void _handleChangeExerciseBreak(event) {
    try {
      this._exercise.exerciseBreakTime = event;
    } catch (ex) {
      print(ex.toString());
    }
  }

  void _handleChangeExerciseTotalTime(event) {
    try {
      this._exercise.exerciseTotalCycle = event;
    } catch (ex) {
      print(ex.toString());
    }
  }

  void _handleSubmit() {
    print(this._exercise);
    if (this._exercise.exerciseTime != 0 &&
        this._exercise.exerciseTotalCycle != 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Timer(
            exercise: this._exercise,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Exercise Timer"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Transform.translate(
        offset: Offset(0, -50),
        child: Center(
          child: Container(
            width: 180,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ExerciseInput(
                    inputText: "Exercise time",
                    setHandler: this._handleChangeExerciseTime,
                  ),
                  ExerciseInput(
                    inputText: "Exercise break time",
                    setHandler: this._handleChangeExerciseBreak,
                  ),
                  ExerciseInput(
                    inputText: "Exercise total cycle",
                    setHandler: this._handleChangeExerciseTotalTime,
                  ),
                  ExerciseButton(
                    buttonText: "Start",
                    setHandler: this._handleSubmit,
                  ),
                ],
              ),
            ),
            // : Timer(),
          ),
        ),
      ),
    );
  }
}

class ExerciseFinished extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Timer"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              heightFactor: 15.0,
              child: Text(
                "Finished!",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -200),
              child: Center(
                child: RaisedButton(
                  child: Text("Restart"),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Timer extends StatefulWidget {
  final ExerciseTime exercise;

  Timer({this.exercise});

  @override
  _Timer createState() => _Timer(exercise: this.exercise);
}

// ignore: must_be_immutable
class _Timer extends State<Timer> {
  int index = 0;
  int totalCycles = 0;
  int cycleCount = 1;
  bool continues = false;
  List<double> exerciseDuration;
  List<String> exerciseText;
  List<Color> customColors;

  AudioCache audioCache = AudioCache();

  final ExerciseTime exercise;
  _Timer({this.exercise});

  @override
  // ignore: must_call_super
  void initState() {
    if (exercise.exerciseBreakTime != 0) {
      this.exerciseText = ["Workout time", "Break Time"];
      this.customColors = [Colors.purple, Colors.red];
      this.exerciseDuration = [
        exercise.exerciseTime,
        exercise.exerciseBreakTime
      ];
      this.totalCycles = (2 * exercise.exerciseTotalCycle.toInt()) - 1;
    } else {
      this.continues = true;
      this.exerciseText = ["Workout time"];
      this.customColors = [Colors.purple];
      this.exerciseDuration = [exercise.exerciseTime];
      this.totalCycles = exercise.exerciseTotalCycle.toInt();
    }

    if (exercise.exerciseTime == exercise.exerciseBreakTime) {
      this.continues = true;
    }
  }

  void changeTimer() {
    setState(() {
      this.index = ++this.index % this.exerciseDuration.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Exercise Timer"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              heightFactor: 3.0,
              child: TimeCircularCountdown(
                unit: CountdownUnit.second,
                countdownTotal: this.exerciseDuration[this.index].toInt(),
                countdownTotalColor: Colors.white,
                countdownCurrentColor: Colors.grey,
                countdownRemainingColor: this.customColors[this.index],
                diameter: 200.0,
                textStyle: TextStyle(
                  fontSize: 50,
                  color: Colors.grey,
                ),
                repeat: this.continues,
                onUpdated: (unit, remainingTime) async {
                  if (this.totalCycles == this.cycleCount &&
                      remainingTime == 1) {
                    audioCache.play('audios/Finish.mp3');
                  } else if (this.exercise.exerciseBreakTime == 0 &&
                      remainingTime == 1) {
                    audioCache.play('audios/Continue_Exercise.mp3');
                  } else if ((this.cycleCount % 2 != 0 && remainingTime == 1) ||
                      (this.continues == true &&
                          remainingTime == 1 &&
                          this.exercise.exerciseTime !=
                              this.exercise.exerciseBreakTime)) {
                    print("play workout over sound " +
                        this.cycleCount.toString());
                    audioCache.play('audios/Break_Time.mp3');
                  } else if (this.cycleCount % 2 == 0 && remainingTime == 1) {
                    print(
                        "play break over sound " + this.cycleCount.toString());
                    audioCache.play('audios/Exercise_Time.mp3');
                  }
                },
                onFinished: () {
                  if (this.cycleCount < this.totalCycles) {
                    this.cycleCount++;
                    if (this.cycleCount == this.totalCycles) {
                      this.continues = false;
                    }
                    this.changeTimer();
                  } else {
                    Navigator.pushReplacementNamed(context, "/finished");
                  }
                },
              ),
            ),
            Center(
              child: Text(
                exerciseText[index],
                style: TextStyle(
                  fontSize: 30,
                  color: this.customColors[this.index],
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExerciseButton extends StatelessWidget {
  final String buttonText;
  final Function setHandler;

  ExerciseButton({this.buttonText, this.setHandler});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.purple,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        child: Text(
          this.buttonText,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        onPressed: this.setHandler,
      ),
    );
  }
}

class ExerciseInput extends StatelessWidget {
  final String inputText;
  final Function setHandler;

  ExerciseInput({this.inputText, this.setHandler});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Transform.translate(
            offset: Offset(0, 50),
            child: Text(
              this.inputText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SpinBox(
          incrementIcon: Icon(null),
          decrementIcon: Icon(null),
          min: 0,
          max: 100000,
          value: 0,
          onChanged: (value) => this.setHandler(value),
          direction: Axis.vertical,
          textStyle: TextStyle(fontSize: 30),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(20),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return "Please enter a number greater than 0";
            }
            return null;
          },
        ),
      ],
    );
  }
}
