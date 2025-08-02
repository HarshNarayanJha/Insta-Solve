import 'package:hive/hive.dart';

part 'answer.g.dart';

@HiveType(typeId: 0)
class Answer extends HiveObject {
  @HiveField(0)
  String? imagePath;

  @HiveField(1)
  String prompt = "";

  @HiveField(2)
  String subject = "";

  @HiveField(3)
  String grade = "";

  @HiveField(4)
  String response = "";

  Answer(
      {this.imagePath,
      required this.prompt,
      required this.subject,
      required this.grade,
      required this.response});
}
