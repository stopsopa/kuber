
var http        = require('http');

var server      = http.createServer().listen(80, function(err) {
    if(err) throw new Error(`General start server error: ${err}`);
    console.log(`Server launched on port ${80}`)
});

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
            <h1>Kubernetes test app</h1>
            <div>host: HOSTNAME</div>
            <div>visits: COUNT</div>
            <div>manual: yaml</div>
            <div>release: 0.0.24</div>
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
    
    <pre>ENV</pre>
    <pre>HEADERS</pre>
</body>
</html>    
`;

content = content.replace(/HOSTNAME/g, os.hostname());

content = content.replace(/ENV/g, JSON.stringify(process.env, null, 4));

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

    return res.end(
      content
        .replace(/COUNT/g, i)
        .replace(/HEADERS/g, JSON.stringify({
            method: req.method,
            url: req.url,
            headers: req.headers,

        }, null, 4))
    );
});
