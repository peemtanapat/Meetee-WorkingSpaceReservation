const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const bcrypt = require("bcrypt");
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.middleware = async (request, response, next) => {
  const username = request.body.username;
  const userPassword = request.body.password;

  const statement = `select id, password from meeteenew.users
        where username = $1`;
  const values = [username];
  var userPasswordDB = null;

  pool.query(statement, values, (err, res) => {
    try {
      if (username == "guest") {
        request.userId = res.rows[0].id;
        next();
      } else if (username == null || userPassword == null) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (err) {
        throw new ErrorHandler(500, "Database Error");
      } else if (res.rowCount == 0) {
        throw new ErrorHandler(
          400,
          "User with the specified username does not exists."
        );
      } else {
        request.userId = res.rows[0].id;
        userPasswordDB = res.rows[0].password;
        bcrypt.compare(userPassword, userPasswordDB, (err, loginPass) => {
          try {
            if (loginPass) {
              next();
            } else if (err) {
              throw new ErrorHandler(500, "Database Error");
            } else {
              throw new ErrorHandler(400, "Wrong password");
            }
          } catch (error) {
            console.log(error);
            next(error);
          }
        });
      }
    } catch (error) {
      console.log(error);
      next(error);
    }
  });
};
