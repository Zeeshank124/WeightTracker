import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weighttracker/Components/Drawer.dart';
import 'package:weighttracker/Screens/AddWeights.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var editedWeight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight Tracker"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      drawer: FrostedDrawer(),
      body: new StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('weight-tracker')
            .orderBy('date_time', descending: true)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (querySnapshot.hasError) {
            return (Text("An error has occured"));
          }
          if (querySnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final list = querySnapshot.data!.docs;

            if (list.isEmpty) {
              return Center(
                child: Text(
                  "No Weight Records",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              );
            } else {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, index) {
                    Timestamp ts = list[index]['date_time'];
                    DateTime dt = ts.toDate();
                    var day = dt.day;
                    var month = dt.month;
                    var year = dt.year;
                    var time = dt.hour;
                    var min = dt.minute;
                    return Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: ListTile(
                        tileColor: Colors.grey.shade200,
                        leading: Column(
                          children: [
                            Text(
                              list[index]['weight'].toString(),
                              style: TextStyle(fontSize: 25),
                            ),
                            Text("$day-$month-$year at $time:$min"),
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Edit"),
                                      content: Container(
                                          height: 100,
                                          width: 100,
                                          child: Column(
                                            children: [
                                              TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  editedWeight = value;
                                                  print(editedWeight);
                                                },
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    DateTime dt =
                                                        DateTime.now();
                                                    Timestamp ts =
                                                        Timestamp.fromDate(dt);
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(user!.uid)
                                                        .collection(
                                                            'weight-tracker')
                                                        .doc(list[index].id)
                                                        .update({
                                                      'date_time': ts,
                                                      'weight': editedWeight
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Save"))
                                            ],
                                          )),
                                    );
                                  });
                            },
                            icon: Icon(Icons.edit)),
                        title: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(user!.uid)
                                  .collection('weight-tracker')
                                  .doc(list[index].id)
                                  .delete();
                            },
                            icon: Icon(Icons.delete)),
                      ),
                    );
                  });
            }
          }
        },
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddWeigh()));
        },
        icon: Icon(
          Icons.add,
          color: Colors.green,
        ),
      ),
    );
  }
}
