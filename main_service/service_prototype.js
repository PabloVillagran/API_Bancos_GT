import express from 'express';
const app = express();
import mysql from 'mysql';
import prop_reader from 'properties-reader';

var properties = prop_reader('./main_service/properties.ini');
var connection = mysql.createConnection({
    host: properties.get('data_base.host'),
    port: properties.get('data_base.port'),
    user: properties.get('data_base.user'),
    password: properties.get('data_base.password'),
    database: properties.get('data_base.name')
});

function Service(){
    this.puerto = '';
    this.nombre = '';

    app.use(urlencoded({extended : true}));
    app.use(json());
}

Service.prototype.start_service = function(){
    app.listen(properties.get(this.puerto), () => console.log(this.nombre +" @ port " + properties.get(this.puerto)));
}

Service.prototype.add_endpoint = function(method, url, func){
    switch(method){
        case 'POST':
            app.post(url, func);
            break;
        case 'GET':
            app.get(url, func);
            break;
        case 'PUT':
            app.put(url, func);
            break;
        case 'DELETE':
            app.delete(url, func);
            break;
    }
}

Service.prototype.query = function(query, res){
    connection.connect();
    connection.query(query, function(error, results, fields){
        if(error)res = json({success:false, result: err});
        else{
            res.json({results});
        }
    });
    connection.end();
}

export default Service;
