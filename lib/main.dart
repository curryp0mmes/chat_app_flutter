import 'package:chat_app/app_theme.dart';
import 'package:chat_app/firebase/authentication.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  //Firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Initialize Firebase Messaging Service
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AuthenticationTools.setupAuth();
  runApp(const ChatApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}"); //TODO Background Notifications work, but in-app messaging will be implemented later
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: MainAppTheme.theme, //Theme located in app_theme.dart for better accessibility
      navigatorKey: navigatorKey,
      home: const DefaultScreen(),
    );
  }
}

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool signedIn = AuthenticationTools.isSignedIn();

    return signedIn ?
      const HomePageScreen()
      : const LoginScreen();
  }
}