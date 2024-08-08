import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:insta_solve/data/preferences_service.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/models/settings.dart';
import 'package:insta_solve/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingSheet extends StatefulWidget {
  const SettingSheet({super.key});

  @override
  State<SettingSheet> createState() => _SettingSheetState();
}

class _SettingSheetState extends State<SettingSheet> {
  final preferencesService = PreferencesService();

  String? defaultGrade = UtilData.grades.first;
  bool autosave = false;
  bool darkMode = true;

  bool customApiKey = false;
  TextEditingController userApiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    final savedSettings = await preferencesService.getSettings();

    if (!mounted) return;

    setState(() {
      defaultGrade = UtilData.grades[savedSettings.defaultGrade];
      autosave = savedSettings.autosave;
      darkMode = savedSettings.darkMode;
      customApiKey = savedSettings.customApiKey;
      userApiKeyController.text = savedSettings.userApiKey ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FluentIcons.settings_24_filled),
                  const SizedBox(width: 10),
                  Text(
                    "Preferences",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Text("Default Grade"),
              leadingAndTrailingTextStyle:
                  Theme.of(context).textTheme.bodyLarge,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    menuMaxHeight: 250,
                    alignment: Alignment.centerRight,
                    underline: const SizedBox(),
                    value: defaultGrade,
                    icon: Container(
                      padding: const EdgeInsets.only(left: 16),
                      child:
                          const Icon(FluentIcons.video_person_star_24_filled),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        defaultGrade = value;
                        _saveSettings();
                      });
                    },
                    items: UtilData.grades
                        .map<DropdownMenuItem<String>>((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              thumbIcon: const WidgetStatePropertyAll(
                  Icon(Icons.bookmark_added_rounded)),
              title: const Text("Autosave Answers"),
              subtitle:
                  const Text("This is automatically save all your answers"),
              value: autosave,
              onChanged: (newValue) => setState(() {
                autosave = newValue;
                _saveSettings();
              }),
            ),
            SwitchListTile(
              thumbIcon:
                  const WidgetStatePropertyAll(Icon(Icons.dark_mode_rounded)),
              title: const Text("Dark Mode Enabled"),
              value: darkMode,
              onChanged: (newValue) => setState(() {
                darkMode = newValue;
                Provider.of<ThemeProvider>(context, listen: false)
                    .setTheme(newValue ? Brightness.dark : Brightness.light);
                _saveSettings();
              }),
            ),
            SwitchListTile(
              thumbIcon: const WidgetStatePropertyAll(Icon(Icons.key_rounded)),
              title: const Text("Use Custom Gemini API Key"),
              value: customApiKey,
              onChanged: (newValue) => setState(
                () {
                  customApiKey = newValue;
                  userApiKeyController.clear();
                  _saveSettings();
                },
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      autocorrect: false,
                      enableSuggestions: false,
                      enabled: customApiKey,
                      maxLength: 39,
                      controller: userApiKeyController,
                      scribbleEnabled: false,
                      onChanged: (apiKey) {
                        // setState(() => userApiKeyController.text = apiKey);
                      },
                      onTapOutside: (_) {
                        _saveSettings();
                      },
                      onEditingComplete: () {
                        _saveSettings();
                      },
                      decoration: const InputDecoration(
                        label: Text("Your Gemini API Key"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                _saveSettings();
                Navigator.of(context).pop();
              },
              child: const Text("Save Settings"),
            ),
            // const Spacer(),
            const Divider(),
            AboutListTile(
              applicationVersion: "v1.0.0+4",
              applicationName: "Insta Solve",
              icon: const Icon(Icons.info_rounded),
              applicationLegalese: "©️ 2024 Harsh Narayan Jha",
              aboutBoxChildren: [
                const Text(""),
                const Text("Developed for the Google Gemini API Competition"),
                const Text("Built with Flutter, VSCode, and Zed"),
                const Text(""),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _launchURL("https://harshnj.is-a.dev/instasolve");
                        },
                        child: IconButton(
                          icon: const Row(children: [
                            Icon(Icons.open_in_new_rounded),
                            Text("Website")
                          ]),
                          onPressed: () {},
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchURL(
                              "https://github.com/HarshNarayanJha/Insta-Solve");
                        },
                        child: IconButton(
                          icon: const Row(children: [
                            Icon(Icons.open_in_new_rounded),
                            Text("GitHub")
                          ]),
                          onPressed: () {},
                        ),
                      ),
                    ])
              ],
              // applicationIcon: ImageIcon(ExactAssetImage("assets/launcher/icon.png")),
            ),
            const ListTile(
              title: Text("Created with ❤️ by Harsh Narayan Jha"),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri urlParsed = Uri.parse(url);

    if (await canLaunchUrl(urlParsed)) {
      await launchUrl(urlParsed, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _saveSettings() {
    final newSettings = Settings(
        autosave: autosave,
        defaultGrade:
            UtilData.grades.indexOf(defaultGrade ?? UtilData.grades.first),
        darkMode: darkMode,
        customApiKey: customApiKey,
        userApiKey: userApiKeyController.text);

    preferencesService.saveSettings(newSettings);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Preferences Saved!")));
  }
}
