import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Train',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var userInputid = -1;
  void changeValue(int id) {
    if (id != userInputid) {
      userInputid = id;
      notifyListeners();
    }
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [SearchElement(), Bogie(rooms: 10)],
      ),
    );
  }
}

class SearchElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int searchvalue = -1;
    var appState = context.watch<MyAppState>();
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType
                  .number, // Set the keyboard type to accept numbers only
              onChanged: (value) {
                int? fieldValue = int.tryParse(value);
                if (fieldValue != null) {
                  searchvalue = fieldValue;
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter seat number', // Set the placeholder text
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              appState.changeValue(searchvalue);
            },
            child: Text('Search'),
          )
        ],
      ),
    );
  }
}

List<String> seatNames = [
  'Side Upper',
  'Lower',
  'Middle',
  'Upper',
  'Lower',
  'Middle',
  'Upper',
  'Side Lower'
];

class Seat extends StatelessWidget {
  final int id;
  final String name;

  Seat({required this.id}) : name = calculateSeatName(id);

  static String calculateSeatName(int seatId) {
    return seatNames[seatId % 8];
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    bool isSelected = (id == appState.userInputid);
    return Padding(
      padding: const EdgeInsets.all(0),
      child: SizedBox(
        width: 70,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Card(
              //shape: BeveledRectangleBorder(),
              color: isSelected ? Colors.blue : Colors.grey,
              child: Center(
                child: Column(children: [
                  Text(
                    id.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 8),
                  )
                ]),
              )),
        ),
      ),
    );
  }
}

class FrontRoom extends StatelessWidget {
  final int id;
  final List<int> ids;
  FrontRoom({required this.id}) : ids = calculateIds(id);

  static List<int> calculateIds(int row) {
    var bias = (row) * 8;
    return [bias + 1, bias + 2, bias + 3, bias + 7];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      //mainAxisAlignment: MainAxisAlignment.center,
      spacing: -4,
      children: [
        Seat(id: ids[0]),
        Seat(id: ids[1]),
        Seat(id: ids[2]),
        SizedBox(width: 40),
        Seat(id: ids[3])
      ],
    );
  }
}

class BackRoom extends StatelessWidget {
  final int id;
  final List<int> ids;
  BackRoom({required this.id}) : ids = calculateIds(id);

  static List<int> calculateIds(int row) {
    var bias = (row) * 8 + 3;
    return [bias + 1, bias + 2, bias + 3, bias + 5];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: -4,
      children: [
        Seat(id: ids[0]),
        Seat(id: ids[1]),
        Seat(id: ids[2]),
        SizedBox(width: 40),
        Seat(id: ids[3])
      ],
    );
  }
}

class Room extends StatelessWidget {
  final int id;
  Room({required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(children: [
        FrontRoom(id: id),
        SizedBox(
          height: 20,
        ),
        BackRoom(id: id),
      ]),
    );
  }
}

class Bogie extends StatelessWidget {
  final int rooms;
  Bogie({required this.rooms});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: rooms,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: Room(id: index),
          );
        },
      ),
    );
  }
}
