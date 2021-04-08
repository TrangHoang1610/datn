var mysql = require("mysql");
// var pool =
module.exports = mysql.createPool({
  connectionLimit: 50,
  host: "localhost",
  user: "root",
  password: "",
  database: "smart_shop",
});
