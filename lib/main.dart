import 'package:command_accepted/Responsive/mobile_screen_layout.dart';
import 'package:command_accepted/Responsive/responsive_layout_screen.dart';
import 'package:command_accepted/Responsive/tablet_screen_layout.dart';
import 'package:command_accepted/Screens/login_screen.dart';
import 'package:command_accepted/Utils/colors_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    name: 'Command_Accepted',
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCyAbeKJi2T9qWMbR82eXHyp6GuDxSpu58',
      appId: '1:602650353463:web:06b81085460426a04b04b2',
      messagingSenderId: '602650353463',
      projectId: 'command-accepted-2997c',
      storageBucket: 'command-accepted-2997c.appspot.com',
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'Command_Accepted',
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCyAbeKJi2T9qWMbR82eXHyp6GuDxSpu58',
      appId: '1:602650353463:web:06b81085460426a04b04b2',
      messagingSenderId: '602650353463',
      projectId: 'command-accepted-2997c',
      storageBucket: 'command-accepted-2997c.appspot.com',
    ),
  );

  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Command Accepted',
      theme: ThemeData(
        dividerColor: Colors.white,
        fontFamily: GoogleFonts.paytoneOne().fontFamily,
        scaffoldBackgroundColor: primaryColor,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: highlightColor,
            fontSize: 30,
          ),
          displayMedium: TextStyle(
            color: highlightColor,
            fontSize: 25,
          ),
          displaySmall: TextStyle(
            color: blackColor,
            fontSize: 20,
          ),
          headlineLarge: TextStyle(
            color: highlightColor,
            fontSize: 80,
          ),
          headlineMedium: TextStyle(
            color: highlightColor,
            fontSize: 40,
          ),
          headlineSmall: TextStyle(
            color: highlightColor,
            fontSize: 20,
          ),
          bodyLarge: TextStyle(
            color: greyColor,
            fontSize: 20,
          ),
          bodyMedium: TextStyle(
            color: highlightColor,
            fontSize: 18,
          ),
          bodySmall: TextStyle(
            color: greyColor,
            fontSize: 15,
          ),
        ),
      ),
      color: mobileBackgroundColor,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                tabletScreenLayout: tabletScreenLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(1, 255, 255, 255),
              ),
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
