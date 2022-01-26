import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weighttracker/Screens/HomeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weighttracker/Screens/SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isChecked = false;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
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
                  "Weight Tracker",
                  style: TextStyle(
                    fontFamily: "Times New Roman",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Email*",
                        style: TextStyle(
                            fontFamily: "Times New Roman",
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    setState(() {
                      email.text = value!;
                      print(email);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter email");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      isDense: true,
                      fillColor: Colors.green,
                      hintText: "abc@gmail.com",
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
                    children: [
                      Text(
                        "Password*",
                        style: TextStyle(
                            fontFamily: "Times New Roman",
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: password,
                  obscureText: _isObscure,
                  onSaved: (value) {
                    setState(() {
                      password.text = value!;
                      print(password);
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please enter password");
                    }
                    if (value.length < 6) {
                      return ("Please enter 6 characters");
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
                    signIn(email.text, password.text);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black, fontFamily: "Times New Roman"),
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 30),
                      primary: Colors.grey.shade400),
                ),
                SizedBox(
                  height: 50,
                ),
                Divider(
                  color: Colors.green,
                  endIndent: 10,
                  thickness: 2,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have any account? ",
                      style: TextStyle(
                        fontFamily: "Times New Roman",
                        color: Colors.green,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                        },
                        child: Text(
                          "Create One",
                          style: TextStyle(
                            fontFamily: "Times New Roman",
                            color: Colors.pink,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    try {
      if (_formKey.currentState!.validate()) {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  Fluttertoast.showToast(msg: "Sign In Successful"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()))
                })
            .catchError((e) {
          Fluttertoast.showToast(msg: "Sign In Unsuccesful");
        });
      }
    } catch (e) {}
  }
}
