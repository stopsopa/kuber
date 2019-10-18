
var http        = require('http');

var server      = http.createServer().listen(80);

const os        = require('os');

process.on('SIGINT', function (signal) {
    console.log(`signal SIGINT..., signal: ${signal}`)
    process.exit(0);
});
process.on('SIGTERM', function (signal) {
    console.log(`signal SIGTERM..., signal: ${signal}`)
    process.exit(0);
});

let content = `
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Test HOSTNAME</title>
    <link id="favicon" rel="shortcut icon" type="image/png" href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACcklEQVRYR+2Xy2sTURTGvzuTZkximpZk0UglXfhYCHZhoYKKCNWCC6uIUIt/gIq4Kl3EFIRC61I3XZQu3EiFtvioD5SioESFYnSpRlsjJZG0qU2aTNPM5I7cCU3aoDB3FhOFnl0gc7/fOec753IJrmtCoDkVJBAuA/DDmkhooMOxee8gCYwshoggDFiju1lFo7SftIwuxS3MvDrPBAPQapH9uuYWwP9bgQaJoPeAAx8XVExEC6ZtZLoCIx0uHA/YoWlA570Mor+KpiBMAez3iXjQVV8WDIVl3Pm0Zh3A0GEnuvdKumAqT3FsPIOVgrlp5qpAe5MNuxtFvfceiegA7xIKnscUKBQIxxXMpSlXJQwDOGwEMz0euOpKwn+Kqy9zmJrlM6RhgJ1uAQ+73HDaCOxiCaJQ1DCbpjqUKACn7meQyvO1wjDAesa3O7fjaHOd/jOSVHF2aoWr5NV/5gZgbfA5BP2cyegael/J1gE0SgSRCw1lwZuRVdz6kLcOYJ9XxKPTlfkPhmWMmZx/U7fhQb8NYyfd5YyvvMjh8VzF9cybA4ecYJVJysbMyOWBdr8NdzcAXJzO4llM0YGYOFtQ5/ZI6JhI45vBfcAFUL2C+17nMP6lgJZ6ATeOuMAW1dflIk5MZmAsf4ALoMlJ8PZ8xYTsJvy8VMSZXXZ9N7C90PMki/dJ1bAxuQDYqW+6PfC7SmO4MVZVDWwTTv8otcRocANcat2GvjbHpvNnfqq4FpYRXea/krkBBAIwiFafiPksxdPvChiA2eAGMCv0t++2AP6JCtT2aRYYXQwR1OhxCtpP9Of5jlSQCBY/zykdjsW9g78B9iQPwFgy4RUAAAAASUVORK5CYII=">
    <link href="https://fonts.googleapis.com/css?family=IBM+Plex+Sans:300,400,500,700&display=swap" rel="stylesheet">
    <style>
        * { 
            font-family: 'IBM Plex Sans', "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", Geneva, Verdana, sans-serif;                   
            font-style: normal; 
            font-variant: normal; 
            font-weight: 700; 
            line-height: 26.4px; 
            color: #3a3a3a;
        } 
        body {
            background-color: lightgray;
        }
        .center {
            position: absolute;
            top: 50%;
            left: 50%;            
            -webkit-transform: translate(-50%, -50%);
            -ms-transform: translate(-50%, -50%);
            transform: translate(-50%, -50%);
        }
        textarea {
            font-size: 9px;
            width:  350px;
        }
    </style>
</head>
<body>

    <div class="center">
        <div>
        <center><img src="data:image/png;base64,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" alt=""></center>
            <h1>Kubernetes test app</h1>
            <div>host: HOSTNAME</div>
            <div>visits: COUNT</div>
            <div>manual: manual test</div>
            <div>release: 0.0.12</div>
            <div>status: <span class="status">online</span></div>
        </div>
    </div>
    <script>
    
        const status = document.querySelector('.status');
        
        ;(function test() {
            
            fetch('/delay?time=' + (new Date()).toISOString().substring(0, 19).replace('T', '-'))
                .then(res => res.text())
                .then(function (text) {
                    
                    status.innerHTML = text;
                    
                    test();
                    
                }, function () {
                    
                    status.innerHTML = 'offline';
                    
                    setTimeout(test, 1000)
                });
        }())    
    </script>
</body>
</html>    
`;

content = content.replace(/HOSTNAME/g, os.hostname());

let i = 0;

server.on('request', function (req, res) {

    if (/^\/delay/.test(req.url)) {

        const time = req.url.replace(/^.*?\?time=(.*)$/, '$1')

        return setTimeout(() => res.end(`online: ${time}`), 1000);
    }

    if (req.url !== '/favicon.ico') {

        i += 1;
    }

    res.setHeader('Content-Type', 'text/html; charset=utf-8');

    return res.end(content.replace(/COUNT/g, i));
});
