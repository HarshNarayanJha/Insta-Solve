import 'dart:developer';
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
    log("Reading all Answers");
    log(answers.length.toString());
    // await answerBox.close();
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
      log("File to copy, $img");
      log("File copy to, $saveDir/$fileName");

      saveImg = await File('${saveDir!.path}/$fileName').create();
      await saveImg.writeAsBytes(data);

      log("File copied to, $saveImg");

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

    log("Saving ${answer.prompt}");

    // save the answer to disk
    var answerBox = await Hive.openBox<Answer>(UtilData.boxName);
    int index = await answerBox.add(answer);

    log("Saved Answer");

    // close the box
    // await answerBox.close();

    return index;
  }

  static Future<void> deleteAnswerAt(int index) async {
    final answerBox = await Hive.openBox<Answer>(UtilData.boxName);
    log("Delete answer at $index");
    await answerBox.deleteAt(index);
    // await answerBox.close();
  }

  static Future<void> deleteAnswer(dynamic key) async {
    final answerBox = await Hive.openBox<Answer>(UtilData.boxName);
    Answer? ans = answerBox.get(key);
    if (ans == null) {
      log("Answer with key $key not found!");
      return;
    }

    if (ans.imagePath != null) {
      await File(ans.imagePath!).delete();
      log("Delete image at ${ans.imagePath!}");
    }
    await answerBox.delete(key);
    log("Delete answer using key $key");
    // await answerBox.close();
  }
}
