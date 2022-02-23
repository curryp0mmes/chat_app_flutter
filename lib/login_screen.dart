import 'package:chat_app/firebase/authentication.dart';
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
      appBar: AppBar(title: const Text("Login"), elevation: 0, actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))]),
      body: Column(
        children: [
          TextField(controller: _emailController,),
          TextField(controller: _passwordController, obscureText: true),
          Row(
            children: [
              TextButton(onPressed: () {
                setState(() {
                  AuthenticationTools.signIn(_emailController.text, _passwordController.text);
                });
              }, child: const Text("Login")),
              TextButton(onPressed: () {
                setState(() {
                  AuthenticationTools.register(_emailController.text, _passwordController.text);
                });
              }, child: const Text("Sign Up")),
            ],
          )
        ],
      ),
    );
  }
}
