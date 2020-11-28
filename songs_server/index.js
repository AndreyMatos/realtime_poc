import express from 'express'
import {
    Database
} from 'sqlite3'
import {
    open
} from 'sqlite'
import WebSocket from 'ws'
const app = express()
const port = 3000

app.use(express.json())

async function openDB() {
    return await open({
        filename: './db/favorite_songs.db',
        driver: Database
    })
}

async function getAllSongs() {
    let db = await openDB()
    const sql = "SELECT * FROM songs"
    const res = db.all(sql)
    db.close()
    return res
}

async function insertSong(songObj) {
    let db = await openDB()
    let stmt = "INSERT INTO songs(song_title, artist, spotify_url) VALUES (?, ?, ?)"
    let result = db.run(stmt, songObj.song_title, songObj.artist, songObj.spotify_url)
    db.close()
    return result
}

async function deleteSong(songID){
    let db = await openDB()
    let stmt = "DELETE FROM songs WHERE id = ?"
    let result = db.run(stmt, songID)
    db.close()
    return result
}

function broadcast(data) {
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN)
            client.send(JSON.stringify(data))
    })
}

app.get('/songs', async (req, res) => {
    let songs = await getAllSongs()
    res.json(songs)
})

app.post('/new_song', async (req, res) => {
    try {
        let result = await insertSong(req.body)
        if(result.changes > 0){
            broadcast(await getAllSongs())
        }
        res.send(result)
    } catch (err) {
        res.send(err)
    }
})

app.delete("/song/:id", async (req, res) => {
    try{
        let result = await deleteSong(req.params.id)
        if(result.changes > 0){
            broadcast(await getAllSongs())
        }
        res.send(result)
    }catch(err){
        res.send(req.params.id)
    }
})

const server = app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})

const wss = new WebSocket.Server({
    server: server
})

wss.on('connection', async (ws, req) => {
    console.log(`new connection ${req.socket.remoteAddress}`)
    let songs = await getAllSongs()
    ws.send(JSON.stringify(songs))
})
