exports.handler = async () => {
  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      mensaje: "Hola mundo desde TerraFleet",
      funcion: process.env.AWS_LAMBDA_FUNCTION_NAME
    })
  };
};