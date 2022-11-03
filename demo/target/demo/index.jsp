<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
    <title>Document</title>
    <style>
        *{
            box-sizing: border-box;
            font-family: 'Roboto', sans-serif;
        }
        body {
            background-color: rgb(36, 36, 36);
        }
        main {
            margin: 0 auto;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: center;
        }
        .container-toDO {
            max-width: 350px;
            height: 400px;
            padding: 10px;
            margin: 16px;
            /* From https://css.glass */
            background: rgba(255, 213, 1, 0.866);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(6.1px);
            -webkit-backdrop-filter: blur(6.1px);
            border: 1px solid rgba(255, 213, 1, 0.6);
        }
        .check {
            margin-top: 8px;
            width: 16px;
        }
        .title {
            padding: 8px;
            border: none;
            width: 100%;
            font-size: 16px;
            font-weight: bold;
            margin: 16px 0;
            background-color: transparent;
        }
        .title:focus {
            outline: none;
        }
        .text {
            width: 100%;
            height: 65%;
            resize: none;
            border: none;
            text-align: justify;
            background-color: transparent;
            padding: 8px;
        }
        .text:focus {
            outline: none;
        }
        .glass {
            background: rgba(255, 255, 255, 0.81);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .button {
            font-weight: bold;
            width: 100%;
            padding: 8px;
            border: none;
        }
        .button:hover {
             background: rgba(247, 229, 143, 0.866);
        }
    </style>
</head>
<body>
    <main id="main">
        <div class="container-toDO">
            <input id="title" class="title glass" type="text"/>
            <textarea id="body" class="text glass"></textarea>
            <button id="add" class="glass button">+</button>
        </div>
    </main>
    
    <script>
        const main = document.getElementById('main');
        
        const add = document.getElementById('add');

        const title = document.getElementById('title')
        const body = document.getElementById('body')

        let checkboxes = new Array()

        listToDo().then(a => {

                checkboxes.map(a => {                
                    
                    a.elements.button.addEventListener('click', (e) => {
                        let body = {
                                        title: a.elements.title.value,
                                        body: a.elements.textarea.value
                                    }
                        
                        fetchOptions(`http://10.0.0.102:8080/toDo/update/${a.id}`, body, 'PUT')
                    })

                    a.elements.checkbox.addEventListener('change', (e) => {
                        let changeStatus = {

                                            "status": a.elements.checkbox.checked,
                                            "idToDo": a.id
                                        }

                        fetchOptions(`http://10.0.0.102:8080/toDo/update/status/${a.id}`, changeStatus, 'PUT')
                        
                    })
                
            })
        });

        add.addEventListener('click', async (e) => {
            e.preventDefault;
            createToDo(main, title.value, body.value)

            let toDoCreate = {
                "title": title.value,
                "body": body.value,
                "done": "F",
            }

            await fetchOptions('http://10.0.0.102:8080/toDo/create', toDoCreate, 'POST');

            title.value = "";
            body.value = "";
        })
            
        function createToDo(parentElement, titleValue, textValue) {
            let div = document.createElement('div');
            let checkbox = document.createElement('input');
            let title = document.createElement('input');
            let textarea = document.createElement('textarea');
            let button = document.createElement('button')

            div.appendChild(checkbox);
            div.appendChild(title);
            div.appendChild(textarea);
            div.appendChild(button);

            div.setAttribute('class', 'container-toDO');

            checkbox.setAttribute('type', 'checkbox');
            checkbox.setAttribute('class', 'check');

            title.setAttribute('type', 'text');
            title.setAttribute('class', 'title glass');
            title.value = titleValue;

            textarea.setAttribute('class', 'text glass');
            textarea.value = textValue;

            let text = document.createTextNode('SAVE')
            button.setAttribute('class', 'glass button');
            button.appendChild(text)


            parentElement.appendChild(div);

            return {checkbox, title, textarea, button}
        }
        
        async function listToDo() {
            let data = await getData('http://10.0.0.102:8080/toDo/list');
            
            let dataArray = new Array(...data)

            dataArray.map(a => {
                let elements = createToDo(main);
                let id = a.idToDo;

                elements.title.value = a.title;
                elements.textarea.value = a.body;
                elements.checkbox.setAttribute('id', `checkbox-${a.idToDo}`);

                checkboxes.push({ id, elements});

                if(a.done == 'F') {
                    elements.checkbox.checked = false;
                } else {
                    elements.checkbox.checked = true;
                }
            })
        }

        async function getData(url) {
            let response = fetch(url).then(data => data.json())

            return await response
        }

        async function fetchOptions(url, body, method) {
            let response = await fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json'
            },
                body: JSON.stringify(body)
            });
        }
    </script>
</body>
</html>
