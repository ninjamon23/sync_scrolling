import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

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
                  child: ListView.builder(
                      controller: _letters,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 12,
                      itemBuilder: (BuildContext context, int index) =>
                          _Tile('Hello ${(index + 1)}')),
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
                          color: Colors.orangeAccent,
                          child: ListTile(
                            title: Text('Drill # - $index'),
                            subtitle: Container(
                              // change your height based on preference
                              height: 80,
                              width: double.infinity,
                              child: ListView(
                                // controller: _numbers,
                                controller: _scrollers[index],
                                // set the scroll direction to horizontal
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  // add your widgets here
                                  _Tile('Hello 1'),
                                  _Tile('Hello 2'),
                                  _Tile('Hello 3'),
                                  _Tile('Hello 4'),
                                  _Tile('Hello 5'),
                                  _Tile('Hello 6'),
                                  _Tile('Hello 7'),
                                  _Tile('Hello 8'),
                                  _Tile('Hello 9'),
                                  _Tile('Hello 10'),
                                  _Tile('Hello 11'),
                                  _Tile('Hello 12'),
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
}

class _Tile extends StatelessWidget {
  final String caption;

  _Tile(this.caption);

  @override
  Widget build(_) => Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        height: 100.0,
        width: 500,
        color: Colors.greenAccent,
        child: Center(child: Text(caption)),
      );
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
