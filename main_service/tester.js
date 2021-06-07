import service_prototype from './service_prototype.js';
import { inherits } from 'util';

function Tester_service(){
    Tester_service.apply(this, arguments);
}

inherits(Tester_service, service_prototype);

var this_service = Tester_service.prototype;

this_service.puerto = 'port.tester';
this_service.nombre = 'Servicio Hola Mundo';

this_service.get_db_date = function(req, res){
    this_service.query('select now() as date ', res);
}

this_service.add_endpoint('GET', '/db_date', (req, res) => {this_service.get_db_date(req, res)});

this_service.start_service();

export default Tester_service;
