
const openSocket = (callback) => {
    let url = "ws://localhost:8080/echo"
    let websocket = new WebSocket(url/*, protocols*/);
    
    websocket.onopen = (event) => {
        callback(websocket);
    }
}

const search = (socket, _input, _cat) => {
    let search = {
        "query": _input,
        "cat": _cat
    };
    socket.send(JSON.stringify(search))

    // Remove previous results
    let results_div = document.querySelector('.results');
    results_div.innerHTML = "<div id='0'><!--End element--></div>";
}

let results = [];
let id = 1;
const addResult = (data) => {
    let obj = JSON.parse(data);
    let { title, desc, title_score, desc_score, link } = obj;
    let current = 1.0;
    let pos = {id: 0, end: false};
    let found = false;
    for (_result in results) {
        if (title_score < _result.title_score && current > _result.title_score) {
            current = _result.title_score;
            pos.id = _result.id
            found = true;
        }
    }

    if (found == false) {
        pos.end = true;
        pos.id = 0;
    }
    let result = {
        id: id,
        title: title,
        desc: desc,
        title_score: title_score,
        desc_score: desc_score,
    };
    results.push(result);
    id += 1;

    return { result: result, pos, link }
}

/** Adds a result to the dom */
const addElement = (title, desc, id, after, link) => {
    let div = document.querySelector('.results');

    let other = document.getElementById(id);
    let new_div = document.createElement('div');
    new_div.className = "package";
    // Title
    let title_div = document.createElement('div');
    title_div.className = "package-title";
    title_div.innerHTML = title;
    new_div.appendChild(title_div);
    // desc
    let desc_div = document.createElement('div');
    desc_div.className = "package-desc";
    desc_div.innerHTML = desc;
    new_div.appendChild(desc_div);
    // href
    new_div.onclick = () => {
        window.open(`/package/${link}`, "_self");
    };
    // if (after) {
    //     div.insertBefore(new_div, other.nextSibling);
    // } else {
    div.insertBefore(new_div, other); 
    // }
}