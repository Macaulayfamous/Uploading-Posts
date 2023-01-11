import 'package:chat_app_course/utilities/snack.dart';
import 'package:chat_app_course/views/auth/register_screen.dart';
import 'package:chat_app_course/views/screens/main_screen.dart';
import 'package:flutter/material.dart';

import '../../controllers/auth_controllers.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController();

  late String _emailAdress;

  bool _isLoading = false;

  late String _password;

  _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(_emailAdress, _password);

      if (res == 'logged in') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MainScreen();
        }));

        setState(() {
          _isLoading = false;
        });

        _formKey.currentState!.reset();
      } else {
        setState(() {
          _isLoading = false;
        });

        return snackBarShow(context, res);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return snackBarShow(context, 'Please Fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Login Account ',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(
                onChanged: (value) {
                  _emailAdress = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Email Adress Must not be empty';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(labelText: "Enter Email Address"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextFormField(
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else {
                    return ' Please Password Must not be empty';
                  }
                },
                decoration: InputDecoration(labelText: 'Enter  Password'),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () {
                _loginUser();
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Center(
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Need  An Account ?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterScreen();
                    }));
                  },
                  child: Text('Register '),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
