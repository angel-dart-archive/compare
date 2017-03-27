import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

void main() {
  var app = new Application<QuizRequestSink>();
  app.start(numberOfInstances: 3);
  print('Aqueduct /questions up at http://localhost:8080');
}

class QuestionController extends HTTPController {
  var questions = [
    "How much wood can a woodchuck chuck?",
    "What's the tallest mountain in the world?"
  ];

  @httpGet
  Future<Response> getAllQuestions() async {
    return new Response.ok(questions);
  }

  @httpGet
  Future<Response> getQuestionAtIndex(@HTTPPath("index") int index) async {
    if (index < 0 || index >= questions.length) {
      return new Response.notFound();
    }

    return new Response.ok(questions[index]);  
  }
}

class QuizRequestSink extends RequestSink {
  QuizRequestSink(ApplicationConfiguration options) : super(options);

  @override
  void setupRouter(Router router) {
    router.route("/questions").generate(() => new QuestionController());
  }
}
