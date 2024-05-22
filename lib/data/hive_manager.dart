import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/models/answer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {
  static Future<List<Answer>> getAnswers() async {
    Box<Answer> answerBox = await Hive.openBox<Answer>(UtilData.boxName);
    List<Answer> answers = answerBox.values.toList();
    print("Reading all Answers");
    print(answers);
    await answerBox.close();
    return answers;
  }

  static Future<int> saveAnswer(XFile? img, String grade, String userPrompt,
      Prompt subject, String response) async {
    final Directory? saveDir = await getExternalStorageDirectory();
    Uint8List data;
    File saveImg;

    late final Answer answer;
    if (img != null) {
      data = await img.readAsBytes();
      final String fileName = basename(img.path);
      print("File to copy, $img");
      print("File copy to, " + '$saveDir/$fileName');

      saveImg = await File('${saveDir!.path}/$fileName').create();
      await saveImg.writeAsBytes(data);

      print("File copied to, $saveImg");

      // create answer instance
      answer = Answer(
          imagePath: saveImg.path,
          grade: grade,
          prompt: userPrompt,
          subject: subject.name,
          response: response);
    } else {
      answer = Answer(
          grade: grade,
          prompt: userPrompt,
          subject: subject.name,
          response: response);
    }

    print("Saving ${answer.prompt}");

    // save the answer to disk
    var answerBox = await Hive.openBox<Answer>(UtilData.boxName);
    int index = await answerBox.add(answer);

    print("Saved Answer");

    // close the box
    await answerBox.close();

    return index;
  }

  static Future<void> deleteAnswerAt(int index) async {
    final answerBox = await Hive.openBox(UtilData.boxName);
    print("Delete answer at $index");
    await answerBox.deleteAt(index);
    await answerBox.close();
  }

  static Future<void> deleteAnswer(dynamic key) async {
    final answerBox = await Hive.openBox(UtilData.boxName);
    Answer ans = await answerBox.get(key);
    if (ans.imagePath != null) {
      await File(ans.imagePath!).delete();
      print("Delete image at ${ans.imagePath!}");
    }
    await answerBox.delete(key);
    print("Delete answer using key $key");
    await answerBox.close();
  }
}
