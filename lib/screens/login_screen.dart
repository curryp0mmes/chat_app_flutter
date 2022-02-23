import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/general_decorations.dart';
import 'package:flutter/cupertino.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
            child: TextField(decoration: CommonDecorations.getLoginFormInputDecoration(labelText: "E-Mail"), controller: _emailController,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(decoration: CommonDecorations.getLoginFormInputDecoration(labelText: "Password"), controller: _passwordController, obscureText: true),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      AuthenticationTools.signIn(_emailController.text, _passwordController.text);
                    });
                  },
                  child: const Text("Login")
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      AuthenticationTools.register(_emailController.text, _passwordController.text);
                    });
                  },
                  child: const Text("Sign Up"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
