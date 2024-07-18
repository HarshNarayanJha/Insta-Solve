class Settings {
  final int defaultGrade;
  final bool autosave;
  final bool darkMode;

  final bool customApiKey;
  final String? userApiKey;

  Settings(
      {required this.defaultGrade,
      required this.autosave,
      required this.darkMode,
      required this.customApiKey,
      required this.userApiKey});
}
