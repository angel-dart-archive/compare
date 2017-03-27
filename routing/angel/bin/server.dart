import 'dart:io';
import 'package:angel_common/angel_common.dart';

main() async {
  var app = new Angel();
  await app.configure(new QuestionController());
  var server = await app.startServer(InternetAddress.LOOPBACK_IP_V4, 8080);
  print(
      'Angel /questions up at http://${server.address.address}:${server.port}');
}

@Expose('/questions')
class QuestionController extends Controller {
  List<String> questions = [
    "How much wood can a woodchuck chuck?",
    "What's the tallest mountain in the world?"
  ];

  @Expose('/')
  List<String> allQuestions() => questions;

  @Expose('/:index')
  String questionAtIndex(String index) {
    try {
      var i = int.parse(index);

      if (i < 0 || i > questions.length)
        throw new AngelHttpException.notFound(
            message: 'No question at index $i.');

      // JSON-encoded by default
      return questions[i];
    } catch (e) {
      // Rethrow the 404 if necessary
      if (e is AngelHttpException) rethrow;

      // Invalid index
      throw new AngelHttpException.badRequest();
    }
  }
}
