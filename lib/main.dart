import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_contact_app/Classes/Preferences.dart';
import 'package:flutter_ios_contact_app/Pages/Home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => Preferences(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<Preferences>(context);
    final isDarkMode = preferences.isDarkMode;

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts',
      theme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        barBackgroundColor: isDarkMode
            ? CupertinoColors.darkBackgroundGray
            : CupertinoColors.lightBackgroundGray,
      ),
      home: const HomePage(),
    );
  }
}
