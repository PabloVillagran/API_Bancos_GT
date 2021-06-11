import service_prototype from '../service_prototype.js';
import { inherits } from 'util';
import mysql from 'mysql';
import axios from 'axios';

function Registro_service(){
    Registro_service.apply(this, arguments);
}

inherits(Registro_service, service_prototype);

var this_service = Registro_service.prototype;

this_service.puerto = 'port.usuario.registro';
this_service.nombre = 'Servicio Registro';

this_service.registro = function(req, res){
    let usuario = mysql.escape(req.body.usuario);//sanitiza ingresos de usuario
    let correo = mysql.escape(req.body.correo);//sanitiza ingresos de usuario
    let banco = mysql.escape(req.params.banco);

    if(!banco){
        res.sendStatus(404);
        return;
    };

    let q = "SELECT api.idAPI as id, api.endpoint as endpoint FROM api_banco as api join banco as b on api.Banco_idBanco1 = b.idBanco where api.servicio = 'registro' and b.Nombre = "+banco+"";

    this_service.query_promise(q).then((result)=>{
        //consumir web service de mockup
        axios.post(result[0].endpoint,{"usuario": req.body.usuario, "password": req.body.password})
        .then(serviceResponse => {
            let token = mysql.escape(serviceResponse.data.token);
            //Insertar transacción en tabla
            let insert = "INSERT INTO `sesion_usuario`(`Nombre_usuario`, `Token`, `fecha_hora_expira`, `correo_electrónico`, `API_Banco_idAPI`) VALUES ("+usuario+","+token+",date_add(now(), interval 30 MINUTE),"+correo+",'"+result[0].id+"')"
            this_service.query_promise(insert)
            .then(res.json({success:true, "token":serviceResponse.data.token}))
            .catch(error=>{
                console.log(error);
                res.json({success:false, error});
            });
        })
        .catch(error=>{
            console.log(error);
            res.json({success:false, error});
        });
    }).catch(error=>{
        console.log(error);
        res.json({success:false, error});
    })
    ;

}

this_service.add_endpoint('POST', '/reg/:banco', (req, res) => {this_service.registro(req, res)});

this_service.start_service();

export default Registro_service;