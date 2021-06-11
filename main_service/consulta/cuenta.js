import service_prototype from '../service_prototype.js';
import { inherits } from 'util';
import mysql from 'mysql';
import axios from 'axios';

function Estado_service(){
    Estado_service.apply(this, arguments);
}

inherits(Estado_service, service_prototype);

var this_service = Estado_service.prototype;

this_service.puerto = 'port.consulta.cuenta';
this_service.nombre = 'Servicio Consulta estado cuenta';

this_service.consulta = function(req, res){
    //:banco/:numCuenta/:fechaIni/:fechaFin
    let token = mysql.escape(req.body.token);//sanitiza ingresos de usuario
    let num_cuenta = mysql.escape(req.params.numCuenta);//sanitiza ingresos de usuario
    let banco = mysql.escape(req.params.banco);
    let fecha_ini = mysql.escape(req.params.fechaIni);
    let fecha_fin = new Date().toISOString().replace(/T.*$/g, '');
    if(req.params.fechaFin){
        fecha_fin = mysql.escape(req.params.fechaFin);
    }

    let q = "SELECT api.idAPI as id, api.endpoint as endpoint FROM api_banco as api join banco as b on api.Banco_idBanco1 = b.idBanco where api.servicio = 'c_cuenta' and b.Nombre = "+banco+"";

    this_service.query_promise(q).then((result)=>{
        //consumir web service de mockup
        axios.post(result[0].endpoint, {
            "numero_cuenta":num_cuenta,
            "fecha_ini":fecha_ini,
            "fecha_fin":fecha_fin
        })
        .then(serviceResponse => {
            // //Insertar transacción en tabla
            res.json({success:true, datos: serviceResponse.data});
        })
        .catch(error=>{
            console.log(error);
            res.json({success:false, error});
        });
    }).catch(error=>{
        console.log(error);
        res.json({success:false, error});
    });

}

this_service.add_endpoint('POST', '/c/cuenta/:banco/:numCuenta/:fechaIni/:fechaFin', (req, res) => {this_service.consulta(req, res)});

this_service.start_service();

export default Estado_service;