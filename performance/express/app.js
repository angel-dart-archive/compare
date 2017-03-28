var express = require('express');
var app = express();

app.get('/json', function (req, res) {
    res.header('content-type', 'application/json').json({
        foo: "bar",
        one: [2, "three"],
        bar: { baz: "quux" }
    });
});

module.exports = app;