import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LinkedScrollables(),
    );
  }
}

class LinkedScrollables extends StatefulWidget {
  @override
  _LinkedScrollablesState createState() => _LinkedScrollablesState();
}

class _LinkedScrollablesState extends State<LinkedScrollables> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _letters;
  late ScrollController _numbers;
  List<ScrollController> _scrollers = [];
  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _letters = _controllers.addAndGet();
    _numbers = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _letters.dispose();
    _numbers.dispose();
    for (var element in _scrollers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Horizontal Only!',
                  style: TextStyle(fontSize: 18),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ListView.builder(
                        padding: EdgeInsets.all(2),
                        controller: _letters,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 12,
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              height: 50.0,
                              width: 300,
                              color: Colors
                                  .transparent, // Required for the divider to show
                              child: Row(children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Month $index',
                                        textAlign: TextAlign.center,
                                      ),
                                      Icon(Icons.calendar_month),
                                      Text(getTextDisplay(index))
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 8,
                                    child: Divider(
                                      height: 2,
                                      color: Colors.black,
                                    ))
                              ]),
                            )),
                  ),
                ),
                const Text(
                  'Vertical>Horizontal',
                  style: TextStyle(fontSize: 18),
                ),
                Expanded(
                  flex: 8,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 20,
                    itemBuilder: (ctx, int index) {
                      _scrollers.add(_controllers.addAndGet());
                      return Card(
                          // color: Colors.orangeAccent,
                          child: ListTile(
                        title: Text('Drill # - $index'),
                        subtitle: Container(
                          // change your height based on preference
                          height: 80,
                          width: double.infinity,
                          child: ListView(
                            padding: EdgeInsets.all(2),
                            // controller: _numbers,
                            controller: _scrollers[index],
                            // set the scroll direction to horizontal
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              // add your widgets here
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                              buildDrillFrame(1, index),
                            ],
                          ),
                        ),
                      ));
                    },
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  String getTextDisplay(int index) {
    var returnText = '';
    switch (index) {
      case 0:
        returnText = 'PAST';
        break;
      case 5:
        returnText = 'TODAY';
        break;
      case 11:
        returnText = 'FUTURE';
        break;
    }
    return returnText;
  }

  Widget buildDrillFrame(int day, int index) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      // height: 400.0,
      width: 300,
      color: Colors.transparent, // Required for the divider to show
      // color: Colors.orangeAccent,
      child: buildDrillLocation(day + index),
    );
  }

  Widget buildDrillLocation(int day) {
    var dayList = [0, 4, 8, 12, 16, 20, 24, 28, 31];
    return Row(
      children: [
        ...dayList.map((e) => Expanded(
              child: Container(
                child: day >= e && day <= (e + 3)
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          child: Text(
                            day.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // child: Column(
                        //   children: [
                        //     CircleAvatar(
                        //       child: Text(
                        //         day.toString(),
                        //         textAlign: TextAlign.center,
                        //       ),
                        //     ),
                        //     Text('more info...')
                        //   ],
                        // )
                      )
                    : const Divider(
                        height: 2,
                        color: Colors.black,
                      ),
              ),
            ))
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final String caption;
  final int? eventDay;
  final String? topLabel;
  List<int> days = [];
  _Tile(this.caption, {this.eventDay, this.topLabel});

  @override
  Widget build(_) {
    for (var i = 1; i <= 3; i++) {
      days.add(i);
    }
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      height: 100.0,
      width: 300,
      color: Colors.greenAccent,
      child: Center(
          child:
              // Text(caption)
              Row(
        children: [
          Expanded(
            flex: 1,
            child: TimelineTile(
              isFirst: true,
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              // endChild: Container(
              //   constraints: const BoxConstraints(
              //     minWidth: 120,
              //   ),
              //   color: Colors.lightGreenAccent,
              // ),
              startChild: Container(
                color: Colors.amberAccent,
                child: Text(topLabel ?? ''),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: TimelineTile(
              hasIndicator: eventDay != null,
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              endChild: Container(
                // width: 200,
                constraints: const BoxConstraints(
                  minWidth: 300,
                ),
                color: Colors.lightGreenAccent,
              ),
              startChild: Container(
                color: Colors.amberAccent,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
