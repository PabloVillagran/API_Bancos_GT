import express from 'express';
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

const app = express();
app.use(express.urlencoded({extended : true}));
app.use(express.json());

function Service(){
    this.puerto = '';
    this.nombre = '';
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

Service.prototype.dbConnect = (err) =>{
    if ( !err ) {
        console.log("Connected to MySQL");
    } else if ( err ) {
        console.log(err);
    }
}

Service.prototype.dbDisconnect = function(){
    console.log('disconnecting');
    connection.end();
}

Service.prototype.connection = connection;

Service.prototype.query_promise = (query) => new Promise((resolve, reject) => {
    connection.query(query, function (err, rows, fields) {
        if (err) {
            return reject(err);
        }
        resolve(rows);
    });
});

Service.prototype.query = (query) => {
    connection.query(query, (error, results) => {
        if(error) return error;
        else{
            return results;
        }
    });
}

export default Service;
