const express=require('express');
const mongoose=require('mongoose');
const authRouter=require('./routes/auth');
const cors=require('cors');
const http=require('http');
const documentRouter = require('./routes/document');
const app=express();

var server=http.createServer(app);
var io=require('socket.io')(server);
const PORT=process.env.PORT | 3001;
app.use(cors());
app.use(express.json());

app.use(authRouter);
app.use(documentRouter);
const DB="mongodb+srv://darpan:darpan2004@cluster0.dy4em.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

mongoose.connect(DB).then(()=>{
    console.log("Connected to MongoDB");
}).catch((error)=>{
    console.log("Error",error);
});
io.on('connection',(socket)=>{
    console.log('connection' +socket.id);
    
    socket.on("join",(documentId)=>{       console.log('joined');
        socket.join(documentId);
        console.log('joined');
        
    })    ;
});
server.listen(PORT,"0.0.0.0",()=>{
    console.log(`Server is running on port ${PORT}`);
});