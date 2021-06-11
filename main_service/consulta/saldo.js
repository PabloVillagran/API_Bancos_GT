import service_prototype from '../service_prototype.js';
import { inherits } from 'util';
import mysql from 'mysql';
import axios from 'axios';

function Estado_service(){
    Estado_service.apply(this, arguments);
}

inherits(Estado_service, service_prototype);

var this_service = Estado_service.prototype;

this_service.puerto = 'port.consulta.saldo';
this_service.nombre = 'Servicio Consulta saldo';

this_service.consulta = function(req, res){
    //:banco/:numCuenta
    let token = mysql.escape(req.body.token);//sanitiza ingresos de usuario
    let num_cuenta = mysql.escape(req.params.numCuenta);//sanitiza ingresos de usuario
    let banco = mysql.escape(req.params.banco);

    
    let select_id_session = "select id as sesion from sesion_usuario where token = "+token;
    
    this_service.query_promise(select_id_session).then((result)=>{
        let session_id = result[0].sesion;
        if(session_id){
            let q = "SELECT api.idAPI as id, api.endpoint as endpoint FROM api_banco as api join banco as b on api.Banco_idBanco1 = b.idBanco where api.servicio = 'c_saldo' and b.Nombre = "+banco+"";
            this_service.query_promise(q).then((result2)=>{
                //consumir web service de mockup
                axios.post(result2[0].endpoint, {
                    "numero_cuenta":num_cuenta
                })
                .then(serviceResponse => {
                    let insert_cuenta_asociada = "INSERT INTO `cuenta_asociada`(`numero_cuenta`, `sesion_usuario_id`, `isCredito`) VALUES ("+num_cuenta+",'"+session_id+"','0')";//soporta cuentas corrientes, TODO: credito
                    
                    this_service.query_promise(insert_cuenta_asociada).then((res_insert) => {
                        //Insertar transacción en tabla
                        let insert = "INSERT INTO `consulta_saldo`(`nombre_cuenta`, `saldo_disponible`, `saldo_reserva`, `saldo_flotante`, `saldo_total`, `moneda`, `API_Banco_idAPI`, `cuenta_origen`, `session_id`) VALUES ("+serviceResponse.data.nombre_cuenta+",'"+serviceResponse.data.disponible+"','"+serviceResponse.data.reserva+"','"+serviceResponse.data.flotante+"','"+serviceResponse.data.total+"','Q','"+result2[0].id+"',"+num_cuenta+",'"+session_id+"')";
                        this_service.query_promise(insert)
                        .then(res.json({success:true, "token":serviceResponse.data.token, datos: serviceResponse.data}))
                        .catch(error=>{
                            console.log(error);
                            res.json({success:false, error});
                        });
                    })
                    .catch(error=>{
                        res.json({success:false, reason:"token expired"});
                    });
                })
                .catch(error=>{
                    console.log(error);
                    res.json({success:false, error});
                });
            }).catch(error=>{
                console.log(error);
                res.json({success:false, error});
            });
        } else {
            res.json({success:false, reason: "session expired"});
        }
    }).catch(error=>{
        console.log(error);
        res.json({success:false, error});
    });
}

this_service.add_endpoint('POST', '/c/saldo/:banco/:numCuenta', (req, res) => {this_service.consulta(req, res)});

this_service.start_service();

export default Estado_service;