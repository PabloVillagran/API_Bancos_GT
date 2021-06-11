import express from 'express';
import { randomBytes } from 'crypto';

const app = express();
app.use(express.urlencoded({extended : true}));
app.use(express.json());

let puerto = '9000';
let nombre = 'Servicio mockup';

function get_token(req, res){
    let token = randomBytes(64).toString('Base64');
    res.json({success:true, token: token});
}

app.post('/mockup/inicio_sesion', (req, res) => {get_token(req,res)});

app.listen(puerto, () => console.log(nombre +" @ port " + puerto));
