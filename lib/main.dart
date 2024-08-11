import 'package:flutter/material.dart';
import 'package:insta_solve/data/preferences_service.dart';
import 'package:insta_solve/models/settings.dart';
import 'package:insta_solve/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/models/answer.dart';
import 'package:insta_solve/pages/answer_detail_page.dart';
import 'package:insta_solve/pages/answer_page.dart';
import 'package:insta_solve/pages/home.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/theme/theme.dart';
import 'package:insta_solve/theme/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init hive
  await Hive.initFlutter();
  // register the adapter
  Hive.registerAdapter<Answer>(AnswerAdapter());
  // open a box
  await Hive.openBox<Answer>(UtilData.boxName);

  final prefs = PreferencesService();
  Settings savedPrefs = await prefs.getSettings();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(savedPrefs.darkMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(this.darkMode, {super.key});

  final bool darkMode;

  static bool themeLoaded = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Baloo 2");
    MaterialTheme theme = MaterialTheme(textTheme);

    if (!themeLoaded) {
      Provider.of<ThemeProvider>(context, listen: false)
          .setTheme(darkMode ? Brightness.dark : Brightness.light);
      themeLoaded = true;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insta Solve',
      theme: Provider.of<ThemeProvider>(context).userTheme == Brightness.light
          ? theme.light()
          : theme.dark(),
      home: const HomePage(),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ScanPage.routeName: (context) => const ScanPage(),
        AnswerPage.routeName: (context) => const AnswerPage(),
        AnswerDetailPage.routeName: (context) => const AnswerDetailPage(),
      },
    );
  }
}
