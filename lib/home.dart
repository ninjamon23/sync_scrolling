import 'package:dy_app/_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../shared/searchbar.dart';

class DrillTimelineView extends StatefulWidget {
  const DrillTimelineView();

  @override
  State<DrillTimelineView> createState() => _DrillTimelineViewState();
}

class _DrillTimelineViewState extends State<DrillTimelineView> {
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
  var dayList = [0, 4, 8, 12, 16, 20, 24, 28, 31];
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _letters;
  late ScrollController _numbers;
  List<ScrollController> _scrollers = [];
  DateTime currentMonth = DateTime.now().toUtc();
  DateTime startMonth =
      Jiffy(DateTime.now().toUtc()).add(months: -6).dateTime.toUtc();
  List<DateTime> monthHeaders = [];

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _letters = _controllers.addAndGet();
    _numbers = _controllers.addAndGet();
    monthHeaders = getMonthHeaders();
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: SearchBar(onSearchApplied: (searchText) {
                    log("searchText $searchText", this);
                  }),
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
                        itemCount: monthHeaders.length,
                        itemBuilder: (BuildContext context, int index) {
                          var workingMonth = monthHeaders[index];
                          // NOTE: Color is required for the divider to show
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            height: 50.0,
                            width: 240,
                            color: Colors.transparent,
                            // color: index == 6
                            //     ? Colors.deepOrangeAccent
                            //     : Colors.transparent,
                            child: Row(children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      workingMonth.toFormat('MMM yyyy') ?? '',
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(Icons.calendar_month),
                                    Text(getTextDisplay(index))
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: buildDrillLocation(-1, index),
                              )
                            ]),
                          );
                        }),
                  ),
                ),
                // const Text(
                //   'Vertical>Horizontal',
                //   style: TextStyle(fontSize: 18),
                // ),
                Expanded(
                  flex: 8,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 9,
                    itemBuilder: (ctx, int index) {
                      _scrollers.add(_controllers.addAndGet());

                      var sampleDay = 21 + index;
                      return Card(
                          // color: Colors.orangeAccent,
                          child: ListTile(
                        title: Text('Drill # - $index'),
                        subtitle: Container(
                          // change your height based on preference
                          height: 100,
                          width: double.infinity,
                          child: ListView(
                            padding: EdgeInsets.all(2),
                            // controller: _numbers,
                            controller: _scrollers[index],
                            // set the scroll direction to horizontal
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              // add your widgets here
                              buildDrillFrame(sampleDay, 0),
                              buildDrillFrame(sampleDay, 1),
                              buildDrillFrame(sampleDay, 2),
                              buildDrillFrame(sampleDay, 3),
                              buildDrillFrame(sampleDay, 4),
                              buildDrillFrame(sampleDay, 5),
                              // NOTE: This will be from loop, middle will always have a color indicator
                              buildDrillFrame(sampleDay, 6),
                              buildDrillFrame(sampleDay, 7),
                              buildDrillFrame(sampleDay, 8),
                              buildDrillFrame(sampleDay, 9),
                              buildDrillFrame(sampleDay, 10),
                              buildDrillFrame(sampleDay, 11),
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

  getMonthHeaders() {
    List<DateTime> listOfMonth = [];
    for (var i = 0; i < 12; i++) {
      var newMonth = Jiffy(startMonth).add(months: i).dateTime.toUtc();
      listOfMonth.add(newMonth);
    }

    return listOfMonth;
  }

  String getTextDisplay(int index) {
    var returnText = '';
    switch (index) {
      case 0:
        returnText = 'PAST';
        break;
      // case 6:
      //   returnText = 'TODAY';
      //   break;
      case 11:
        returnText = 'FUTURE';
        break;
    }
    return returnText;
  }

  Widget buildDrillFrame(int day, int index,
      {Color color = Colors.transparent}) {
    // NOTE: color is required for the divider to show
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      // height: 400.0,
      width: 240,
      color: color,
      // color: Colors.transparent,
      // color: index == 5 ? Colors.redAccent : Colors.transparent,
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: VerticalDivider(
                thickness: 1,
                color: Colors.black,
              )),
          Expanded(flex: 8, child: buildDrillLocation(day, index)),
        ],
      ),
    );
  }

  Widget buildDrillLocation(int day, int index) {
    var mapIndex = -1;
    return Row(
      children: [
        ...dayList.map((e) {
          mapIndex++;
          print(mapIndex);
          return Expanded(
            child: Container(
                child: day >= e && day <= (e + 3)
                    ? Padding(
                        padding: const EdgeInsets.all(1),
                        child: CircleAvatar(
                          child: Text(
                            day.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : checkIfToday(index, e, mapIndex)
                // currentMonth.day >= e &&
                //         currentMonth.day <= (e + 3) &&
                //         index == 6
                //     ? const VerticalDivider(
                //         // height: 2,
                //         thickness: 1,
                //         color: Colors.deepOrange,
                //       )
                //     : const Divider(
                //         thickness: 1,
                //         color: Colors.black,
                //       ),
                ),
          );
        })
      ],
    );
  }

  Widget checkIfToday(
      int drillLocationIndex, int drillZone, int mapLocationIndex) {
    if (mapLocationIndex != 6) {
      return const Divider(
        thickness: 1,
        color: Colors.black,
      );
    }

    if (currentMonth.day >= drillZone &&
        currentMonth.day <= (drillZone + 3) &&
        drillLocationIndex == 6) {
      return const VerticalDivider(
        // height: 2,
        thickness: 1,
        color: Colors.deepOrange,
      );
    }
    return const Divider(
      thickness: 1,
      color: Colors.black,
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
