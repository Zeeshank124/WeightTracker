import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddWeigh extends StatefulWidget {
  const AddWeigh({Key? key}) : super(key: key);

  @override
  State<AddWeigh> createState() => _AddWeighState();
}

class _AddWeighState extends State<AddWeigh> {
  TextEditingController weight = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight Tracker"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: weight,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                fillColor: Colors.green,
                hintText: "Your Weight",
                prefixIcon: Icon(
                  Icons.monitor_weight,
                  color: Colors.grey,
                ),
              ),
              onSaved: (e) {
                setState(() {
                  weight.text = e!;
                });
              },
            ),
            TextButton.icon(
                onPressed: () {
                  addWeightEntry();
                },
                icon: Icon(Icons.add),
                label: Text("Add"))
          ],
        ),
      ),
    );
  }

  void addWeightEntry() {
    if (_formKey.currentState!.validate()) {
      try {
        DateTime dt = DateTime.now();
        Timestamp ts = Timestamp.fromDate(dt);
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('weight-tracker')
            .add({'date_time': ts, 'weight': double.parse(weight.text)});
        Fluttertoast.showToast(msg: "Added Successfully");
        Navigator.of(context).pop();
      } catch (e) {
        Fluttertoast.showToast(msg: "Please enter a valid value");
      }
    }
  }
}
