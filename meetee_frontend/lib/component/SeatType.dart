import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // JSON

import 'package:meetee_frontend/model/Person.dart';
import 'package:meetee_frontend/model/Room.dart';

class SeatType extends StatefulWidget {
  final String roomType;
  final String date;
  final String status;

  SeatType({Key key, this.roomType, this.date, this.status}) : super(key: key);

  @override
  _SeatTypeState createState() => _SeatTypeState();
}

class _SeatTypeState extends State<SeatType> {
  List roomTypes = new List<Room>();

  Future<String> getSeatType() async {
    http.Response response = await http
        .get('https://us-central1-meetee-api.cloudfunctions.net/api/roomtypes');
    if (response.statusCode == 200) {
      print(jsonEncode(response.body));
      this.setState(() {
        List list = json.decode(response.body);
        roomTypes = list.map((model) => Room.fromJson(model)).toList();
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    this.getSeatType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true, // container stick with top bar
      itemCount: roomTypes.length,
      itemBuilder: (BuildContext context, int index) {
        if (context != null) {
          return makeListTile(roomTypes[index]);
        }
        // return CircularProgressIndicator();
      },
    ));
  }
}

// Card makeCard(Person person) => Card(
//       // elevation: 8.0,
//       // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//       child: Container(
//         decoration: BoxDecoration(),
//         child: makeListTile(person),
//       ),
//     );

ListTile makeListTile(Room room) {
  return ListTile(
      // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
          // padding: EdgeInsets.only(right: 12.0), // ข้างรูปซ้าย
          // decoration: BoxDecoration(
          //     border: Border(
          //         right: new BorderSide(width: 1.0, color: Colors.black87))),
          child: Icon(
        IconData(58418, fontFamily: 'MaterialIcons'),
        size: 60.0,
        //     Image.network(
        //   room.roomTypePic,
      )),
      title: Text(
        room.roomTypeName,
        // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Meeting Room A", style: TextStyle(color: Colors.black38)),
      subtitle: Row(
        children: <Widget>[
          Icon(
            Icons.person,
            color: Colors.grey,
            size: 16,
          ),
          Text(
            room.roomTypeCapacity.toString() +
                ' | ฿' +
                room.roomTypePrice.toString() +
                '/hr',
          )
          // style: TextStyle(color: Colors.green))
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0));
}
