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

function get_estado_cuenta(req, res){
    let detalle_aleatorio = generarRandom(req.body.fecha_ini, req.body.fecha_fin);
    res.json({
        success:true, 
        numero_cuenta: req.numero_cuenta,
        detalle:detalle_aleatorio
    });
}

function generarRandom(start, end){
    let s = start.replace(/'/g,"").split('-');
    let e = end.replace(/'/g,"").split('-');
    let s_date = new Date(s[0], s[1]-1, s[2]);
    let e_date = new Date(e[0], e[1]-1, e[2]);

    console.log(start, end, s, e);

    let arr = new Array();
    for(let i = 0; i<Math.ceil(Math.random() * 6); i++){
        arr.push({desc: getRandomDesc(), 
            monto: Math.round(((Math.random() * - 1000) + 500)*100)/100,
            fecha: getRandomDate(s_date, e_date)
        });
    }
    return arr;
}

function getRandomDesc() {
    let r = Math.floor(Math.random()*5);
    let descs = ['Compras online','Wallmart','5B','Transferencia','McDonalds','Cheque'];
    return descs[r];
}

//getRandomDate(new Date(2021, 0, 1), new Date(2021, 5, 1))
function getRandomDate(start, end) {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
}  

function get_saldo(req, res){
    let sdisponible = Math.round(((Math.random() * 10000))*100)/100;
    let sreserva = Math.round(((Math.random() * -500))*100)/100;
    let sflotante = Math.round(((Math.random() * -500))*100)/100;
    res.json(
        {
            "nombre_cuenta": req.body.numero_cuenta,
            "disponible": sdisponible,
            "reserva": sreserva,
            "flotante": sflotante,
            "total": Math.round((sdisponible + sreserva + sflotante)*100)/100
        }
    );
}

app.post('/mockup/inicio_sesion', (req, res) => {get_token(req,res)});
app.post('/mockup/c/estado_cuenta', (req, res) => {get_estado_cuenta(req,res)})
app.post('/mockup/c/saldo', (req, res) => {get_saldo(req, res)})

app.listen(puerto, () => console.log(nombre +" @ port " + puerto));
