
import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/screens/login_and_register/widget/form_field.dart';
import 'package:habit_tracker_application_main/services/firebase_auth.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';

import 'package:provider/provider.dart';

class RegisterationPage extends StatefulWidget {
  const RegisterationPage({Key? key}) : super(key: key);

  @override
  _RegisterationPageState createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  bool? isAgree = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String error = '';
  bool loading = false;

  bool autoValidate = false;
  bool isPassword = true;
  bool isconformPassword = true;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthServices>(context);
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, right: 15, left: 15),
                  child: Form(
                    key: _formKey,
                    // autovalidate: autoValidate,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            controller: _nameController,
                            lableText: 'Full Name',
                            prefixIcon: Icons.person,
                            validator: (val) =>
                                val.isEmpty ? 'Enter Your Full Name' : null,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FormWidget(
                            onTap: () {},
                            prefixIcon: Icons.mail,
                            controller: _emailController,
                            lableText: 'Email',
                            validator: (val) =>
                                val.isEmpty ? 'Enter Your Email' : null,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FormWidget(
                              controller: _passwordController,
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
                              lableText: 'Password',
                              isPassword: isPassword,
                              validator: (val) => val.length < 4
                                  ? 'Enter Your Password'
                                  : null),
                          const SizedBox(
                            height: 10,
                          ),
                          CheckboxListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              selected: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              title: TextButton(
                                child: RichText(
                                  text: const TextSpan(
                                      text: 'I agree to the',
                                      style: TextStyle(color: kBlack54),
                                      children: [
                                        TextSpan(
                                            text: ' Terms and Conditions',
                                            style: TextStyle(
                                                color: kFullGreenColor))
                                      ]),
                                ),
                                onPressed: () {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => AppPrivacy()));
                                },
                              ),
                              value: isAgree,
                              onChanged: (newValue) {
                                setState(() {
                                  isAgree = newValue;
                                });
                              }),
                          if (isAgree == true)
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  // awa  Future.delayed(const Duration(seconds: 2));

                                  await _auth.signUp(
                                      _emailController.text,
                                      _passwordController.text,
                                      _nameController.text,
                                      context);
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
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: kFullGreenColor, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          );
  }
}
