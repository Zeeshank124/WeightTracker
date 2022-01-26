import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighttracker/Models/UserModel.dart';
import 'package:weighttracker/Screens/HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? errorMessage;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isChecked = false;
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontFamily: "Times New Roman",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [buildPinkText("Name*")],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return ("Enter name");
                    }
                    return null;
                  },
                  onSaved: (e) {
                    setState(() {
                      _firstName.text = e!;
                    });
                  },
                  controller: _firstName,
                  decoration: InputDecoration(
                      isDense: true,
                      fillColor: Colors.green,
                      hintText: "Your name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.green, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0))),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [buildPinkText("Email*")],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (e) {
                    setState(() {
                      _email.text = e!;
                    });
                  },
                  validator: (e) {
                    if (e!.isEmpty) {
                      return ("Enter email");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      isDense: true,
                      fillColor: Colors.green,
                      hintText: "xyz@gmail.com",
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.green, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0))),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [buildPinkText("Password*")],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: _isObscure,
                  onSaved: (e) {
                    setState(() {
                      _password.text = e!;
                    });
                  },
                  validator: (e) {
                    if (e!.length < 6) {
                      return ("Password should be atleast 6 characters");
                    }
                    if (e.isEmpty) {
                      return ("Password is empty");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: "Password",
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.green, width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0))),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    SignUp(_email.text, _password.text);
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                        color: Colors.black, fontFamily: "Times New Roman"),
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 30),
                      primary: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text buildPinkText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Times New Roman",
          color: Colors.pink,
          fontWeight: FontWeight.bold,
          fontSize: 12),
    );
  }

  Future<void> SignUp(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((_) {
          postDetailsToFirestore();
        }).catchError((e) {
          Fluttertoast.showToast(msg: e.toString());
        });
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.uid = user!.uid;
    userModel.email = user.email;
    userModel.name = _firstName.text;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
