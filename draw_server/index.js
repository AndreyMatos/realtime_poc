import express from 'express'
import WebSocket from 'ws'
const app = express()
const port = 3000

app.use(express.json())
app.use(express.static(`static`))

function broadcast(data, ws) {
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN && client !== ws)
            client.send(JSON.stringify(data))
    })
}

app.get('/draw', (req, res) => {
    res.sendFile(`${__dirname}/static/index.html`);
})

const server = app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})

const wss = new WebSocket.Server({
    server: server
})

wss.on('connection', async (ws, req) => {
    console.log(`new connection ${req.socket.remoteAddress}`)
    ws.on('message', (data) => {
        broadcast(data, ws)
    })
})
