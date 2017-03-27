# Routing
All complete server-side frameworks should have some type of routing mechanism.
Below is an objective comparison of routing support, as well as middleware support.
Code examples are included.

# Contents

* [Angel](#angel)
* [Aqueduct](#aqueduct)
* [Jaguar](#jaguar)
* [Redstone](#redstone)
* [shelf](#shelf)

## Angel
[Angel](https://github.com/angel-dart/angel/wiki)'s routing API was inspired by
that of ExpressJS, but goes further. The `Angel` server class, as well as all
[`Service` classes](https://github.com/angel-dart/angel/wiki/Service-Basics),
extend the `Router` base class, which provides modular routing, and allows for routes
to be encapsulated within groups.

[Request handlers](https://github.com/angel-dart/angel/wiki/Requests-&-Responses#return-values)
can be any Dart object, whether a function, or a plain Dart object.
Plain objects will be serialized automatically. See
[Basic Routing](https://github.com/angel-dart/angel/wiki/Basic-Routing) for more information.

```dart
app.get('/', (req, res) async => ...);
app.post('/some/:param', (param) => ...);
app.patch('/custom/:regex([0-9]+)', { 'foo': 'bar' });
app.delete('/optional/:param?', ...);
app.head('<path>', ...);
app.addRoute('<method>', '<path>', ...);
```

Angel also supports infinitely nested route groups.

```dart
app.group('/api/books', (router) {
    router.get('/', fetchBooks;

    router.group('/:id', (router) {
        router.get('/', (id) => fetchBookById(id));
        router.post(...);
        router.addRoute(...);

        router.group('/pages', (router) {
            router.get('/:pageId/word-count', (pageId) => ...);
        });
    });
});
```

And to boot,
[`package:angel_route`](https://github.com/angel-dart/route)
 runs everywhere, and even has additional
browser routing support.

Angel supports `Controller` classes powered by annotations, should you prefer a more
declarative approach to routing. At startup, these are automatically converted into the
aforementioned dynamic routes. In addition, they are injected into the application as
singleton dependencies.

```dart
main() async {
    var app = new Angel();
    await app.configure(new QuestionController());
    var server = await app.startServer(...);
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
```

### Middleware
Angel's middleware follow the same rules as request handlers, and can be easily attached
to routes.

```dart
// The following three all do the same thing:
app.chain([myMiddleware, anotherOne]).get('/', ...);

app.chain(myMiddleware).chain(anotherOne).get('/', ...);

app.get('/', ..., middleware: [myMiddleware, anotherOne]);
```

## Aqueduct
Aqueduct's routing system consists of `HTTPController`s nested within each other.

```dart
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
  QuizRequestSink(ApplicationConfiguration options) : super (options);

  @override
  void setupRouter(Router router) {
    router
      .route("/questions")
      .generate(() => new QuestionController());
  }
}
```

Aqueduct's routing system is strongly typed, but does not allow the same flexibility as
Angel. For example, all request handlers must return a `Response`. This concept, also
seen in `shelf`, can make it compplicated to implement a powerful middleware pipeline.

### Middleware
Aqueduct's `HTTPController`s can only generate certain routes (i.e. `/note` or `/note/:index`), and 
are declared with static
annotations, such as `@httpGet`. Dart annotations must be compile-time constant, which means
that functionality such as dynamic middleware (i.e. middleware returned from a function) cannot be
declared in the same spot as a route. For example:

```dart
// You can't do this!
@HttpMethod('get', middleware: const [
    someDynamicFunction(),
    onlyATopLevelMiddleware,
    whichHasToReadParametersFromAStaticSource
])
Future<Response> getAllFoo();
```

The concept of routes being declared via annotations is seen in Jaguar and Redstone as well, and
limits them in the same way.

Ultimately, the weaknesses of Aqueduct's routing, compared to Angel's, are:
* Controllers can only generate a few routes - adding other requires creating an entirely new 
controller class
* Middleware must be constant, and not declared where the route is
* Only `RequestController`s can be used as classes.
* All request handlers must return the same class

## Jaguar

## Redstone

## shelf