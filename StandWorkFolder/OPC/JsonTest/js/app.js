document.addEventListener("DOMContentLoaded", function() {
    let myText = document.querySelector('.codeText');
    let btnStart = document.querySelector('.HTTPStart');
    let btnStop = document.querySelector('.HTTPStop');

    btnStart.addEventListener('click', StartHTTP)
    btnStop.addEventListener('click',StopHTTP)

    let Timed = 0

    function StartHTTP() {
        getResponseSlow()
    }

    function StopHTTP() {
        clearTimeout(Timed)
    }

    function asyncTimeout(delay) {
        return (new Promise(resolve => {setTimeout(() => resolve(delay), delay)}))
            .then(d => `Waited ${d} seconds`);
    }
    
    function asyncFetch(url) {
        return fetch(url)
            .then(response => (response.text()))
            .then(text => `Fetched ${url}, and got back ${text}` );
    }

    function runTask(spec) {
        return (spec.task === 'wait') ? asyncTimeout(spec.duration) : asyncFetch(spec.url);
    }

    const starterPromise = Promise.resolve(null);

    const log = result => console.log(result);


    async function getResponseSlow() {
        const asyncThingsToDo = [
            //{task: 'wait', duration: 1000},
            {task: 'fetch', url: 'http://192.168.99.9/CmdChannel?gRES'}
        ];

        await asyncThingsToDo.reduce(
            (p, spec) => p.then(() => runTask(spec).then(log)),
            starterPromise
        );

        Timed = setTimeout(getResponseSlow, 1)
    }
        
    
    








    async function getResponse() {

        // запрашиваем JSON с данными пользователя
        let response = await fetch('https://api.openweathermap.org/data/2.5/weather?q=Almaty&appid=eb6132ec7333f86c5e9bed005c6ac9fc&units=metric');
        let weather = await response.json();
        
        console.log(weather);
        
        let responseDiv = document.createElement('div');
        responseDiv.style.width = 100 + 'px';
        responseDiv.style.height = 100 + 'px';
        responseDiv.style.backgroundColor = 'red';
        document.body.append(responseDiv);
        
        await new Promise((resolve, reject) => setTimeout(resolve, 3000));
        
        //simpleHTTPRequest();
        
        return weather;
    }


    
    function simpleHTTPRequest() {
        let AsyncRequest = new XMLHttpRequest();
        AsyncRequest.open("GET", "https://api.openweathermap.org/data/2.5/weather?q=Almaty&appid=eb6132ec7333f86c5e9bed005c6ac9fc&units=metric", true);

        AsyncRequest.onload = function (e) {
        if (AsyncRequest.readyState === 4) {
            if (AsyncRequest.status === 200) {
            console.log(AsyncRequest.responseText);
            } else {
            console.error(AsyncRequest.statusText);
            }
        }
        };

        AsyncRequest.onerror = function (e) {
        console.error(AsyncRequest.statusText);
        };

        AsyncRequest.send(null); 
    }
})


