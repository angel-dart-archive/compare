var cluster = require('cluster');
var app = require('../app');
var i = 0;

if (cluster.isMaster) {
    console.log(`Master ${process.pid} is running`);

    // Fork workers.
    for (let i = 0; i < 50; i++) {
        cluster.fork();
        console.log('Spawned worker #' + (i + 1) + '...');
    }

    console.log('Node.js listening at http://localhost:3000')

    cluster.on('exit', (worker, code, signal) => {
        console.log(`worker ${worker.process.pid} died`);
    });
} else {
    var server = app.listen(3000);
}