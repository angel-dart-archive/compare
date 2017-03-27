# Routing
All complete server-side frameworks should have some type of routing mechanism.
Below is an objective comparison of routing support, as well as middleware support.
Code examples are included.

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
app.patch('/foo/bar', { 'foo': 'bar' });
app.delete('<path>', ...);
app.head('<path>', ...);
app.addRoute('<method>', '<path>', ...);
```

Angel also supports infinitely nested route groups.

```dart
app.group('/api/books', (router) {
    router.get('/', fetchBooks;

    router.group('/:id', (router) {
        router.get('/', (id) => fetchBookById(id));

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

## Jaguar

## Redstone

## shelf