import 'package:flutter/material.dart';

import 'package:habit_tracker_application_main/screens/login_and_register/register_page.dart';
import 'package:habit_tracker_application_main/screens/login_and_register/widget/form_field.dart';
import 'package:habit_tracker_application_main/services/firebase_auth.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthServices>(context);
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(
                          height: 80,
                        ),
                        Image.asset(
                          'assets/logo/logo.png',
                          height: 200,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        FormWidget(
                          onTap: () {},
                          prefixIcon: Icons.mail,
                          validator: (val) =>
                              val.isEmpty ? 'Enter Email Address' : null,
                          onChange: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          lableText: 'Email',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FormWidget(
                          onTap: () {},
                          prefixIcon: Icons.lock,
                          sufixIcon: IconButton(
                            icon: Icon(
                              isPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_rounded,
                              size: 20,
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                isPassword = !isPassword;
                              });
                            },
                          ),
                          validator: (val) =>
                              val.length < 2 ? 'Enter Your Password' : null,
                          isPassword: isPassword,
                          onChange: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          lableText: 'Password',
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              await _auth.signIn(email, password, context);
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: kFullGreenColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Dont Have an Account? ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            InkWell(
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: kFullGreenColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterationPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
