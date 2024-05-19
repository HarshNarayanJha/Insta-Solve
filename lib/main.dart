import 'package:flutter/material.dart';
import 'package:insta_solve/pages/answer_page.dart';
import 'package:insta_solve/pages/home.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/theme/theme.dart';
import 'package:insta_solve/theme/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});                                                                             

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Baloo 2");
    MaterialTheme theme = MaterialTheme(textTheme);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instasolve',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      
      home: const HomePage(),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ScanPage.routeName: (context) => const ScanPage(),
        AnswerPage.routeName: (context) => const AnswerPage(),
      },
    );
  }
}