import 'package:mkship_app/firebase/authentication.dart';
import 'package:mkship_app/constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
            Image(image: AssetImage('assets/mkship-logo.png'), width: MediaQuery.of(context).size.width * 0.5),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
              child: TextField(decoration: Constants.getLoginFormInputDecoration(labelText: "E-Mail"), controller: _emailController,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(decoration: Constants.getLoginFormInputDecoration(labelText: "Password"), controller: _passwordController, obscureText: true),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          AuthenticationTools.signIn(_emailController.text, _passwordController.text);
                        });
                      },
                      child: const Text("Login")
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          AuthenticationTools.register(_emailController.text, _passwordController.text);
                        });
                      },
                      child: const Text("Sign Up"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
