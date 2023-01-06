import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  const Timeline({super.key});

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              buildMarker(250, 250, 1, true, false),
              buildMarker(250, 250, 25, true, false),
              buildMarker(250, 250, 31, false, true),
              // buildMarker(500, 500, 20, false, true),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMarker(
      double width, double height, double day, bool isComplete, bool isLast) {
    double computeCenter(double h) {
      var half = h / 2;
      return half - 12;
    }

    double computeMarkerPosition(double w, double d) {
      var multiplier = w / 31;
      var retVal = d * multiplier;
      if (day == 1) {
        retVal = retVal - 15;
      } else {
        retVal = retVal - 25;
      }

      return retVal;
    }

    return Container(
      width: width,
      height: height,
      // decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Stack(children: [
        Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Container(
            // decoration:
            //     BoxDecoration(border: Border.all(color: Colors.deepOrange)),
            height: height / 2.5,
            width: width,
            child: Column(
                children: [Text('Date'), Text('Title'), Text('mroe info')]),
          ),
        ),
        Positioned(
          left: -8,
          top: computeCenter(height) - 50,
          child: const Padding(
            padding: EdgeInsets.only(right: 20),
            child: SizedBox(
              height: 100,
              child: VerticalDivider(
                color: Colors.black,
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: Divider(
            color: Colors.black,
          ),
        ),
        Positioned(
            left: computeMarkerPosition(width, day),
            top: computeCenter(height),
            child: Icon(isComplete ? Icons.check_circle : Icons.pending)),
        if (isLast)
          Positioned(
            left: width - 10,
            top: computeCenter(height) - 50,
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: SizedBox(
                height: 100,
                child: VerticalDivider(
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
