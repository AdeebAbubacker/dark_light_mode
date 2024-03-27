import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Flutter Theme Provider',
            theme: themeNotifier.darkTheme ? darkTheme : lightTheme,
            home: HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Provider'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) => SwitchListTile(
                title: const Text("Dark Mode"),
                onChanged: (val) {
                  themeNotifier.toggleTheme();
                },
                value: themeNotifier.darkTheme,
              ),
            ),
            const Card(
              child: ListTile(
                title: Text("This is just a list tile on a card."),
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
);

class ThemeNotifier extends ChangeNotifier {
  late SharedPreferences _prefs;
  late String _key = 'theme';

  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveThemeToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _loadThemeFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  _saveThemeToPrefs() async {
    await _initPrefs();
    _prefs.setBool(_key, _darkTheme);
  }
}

// Themes app

