const connStatus = document.getElementById("conn_status")
const canvas = document.getElementById("canvas")
const context = canvas.getContext("2d")

const ws = new WebSocket("ws://localhost:3000")

ws.onopen = function onOpen(event){
    console.log(event)
    connStatus.innerText = "Connected"
}

ws.onmessage = function onMessage(data){
    try{
        let str = data.data
        let mData = JSON.parse(JSON.parse(str))
        console.log(mData)
        context.canvas.width  = mData.width;
        context.canvas.height = mData.height;
        for(let i=0;i<mData.lines.length; i++){
            let line = mData.lines[i];
            let width = line.width
            let color = line.wipe ? "#FFFFFF" : toHexColor(line.color)
            context.beginPath()
            for(let j=0;j<line.points.length;j++){
                let point = mData.lines[i].points[j]
                if(j == 0){
                    context.moveTo(point.x, point.y)
                }else{
                    context.lineTo(point.x, point.y)
                }
            }
            context.strokeStyle = color
            context.lineWidth = width
            context.stroke()
        }
    }catch(err){
        console.error(err);
    }
}

function toHexColor(originalColor){
    let intColor = parseInt(originalColor)
    return "#"+intColor.toString(16).substr(2)
}