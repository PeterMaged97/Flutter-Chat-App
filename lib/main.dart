import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/services.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color(0xFF630000),
      systemNavigationBarColor: Color(0xFF630000),
    ));
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        hintColor: Colors.grey,
        scaffoldBackgroundColor: kPrimaryColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
          bodyText2: TextStyle(color: Colors.black54),

        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      }
    );
  }
}
