fetch('http://localhost:8083/todo')    
    .then(response => response.json())
    .then(data => console.log(data));