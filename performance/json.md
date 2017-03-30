# Simple JSON
Endpoint: `/json`
Location in Angel project: `lib/src/tests/json.dart`
Location in Aqueduct project: *TODO*

Each server should respond with JSON equivalent to the following:

```json
{
    "foo": "bar",
    "one": [
        2,
        "three"
    ],
    "bar": {
        "baz": "quux"
    }
}
``` 

It is expected that the server sends a `Content-Type: application/json` header as well.