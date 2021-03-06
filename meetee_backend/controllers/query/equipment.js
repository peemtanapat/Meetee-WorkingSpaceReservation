const { Pool } = require("pg");
const pool = new Pool({
  connectionString: process.env.POSTGRES_CONNECTION_URL
});
const { ErrorHandler, handlerError } = require("../../helpers/error");

exports.getFacilityCategoryDetail = (request, response, next) => {
  const cateId = request.params.id;
  const statement = `SELECT * from meeteenew.view_faccate_detail
    WHERE cateId = $1`;
  const value = [cateId];
  pool.query(statement, value, (error, results) => {
    try {
      if (cateId == null) {
        throw new ErrorHandler(400, "Bad Request");
      } else if (error) {
        console.log(error);
        throw new ErrorHandler(500, "Database Error");
      } else {
        response.status(200).send(results.rows[0]);
      }
    } catch (error) {
      console.log(error);
      next(error);
    }
  });
};
