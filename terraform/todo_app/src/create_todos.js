
const AWS = require('aws-sdk')
var uuid = require('uuid')

const documentClient = new AWS.DynamoDB.DocumentClient();

exports.handler = async function (event, context) {
  console.log("create todos called")

  let statusCode = 0
  let responseBody = {}

  var input = JSON.parse(event.body)


  let params = {
    TableName: process.env.TABLE_NAME,
    Item: {
      Id: uuid.v4(),
      label: input.label,
      description: input.description
    }
  }  

  try {
    const data = await documentClient.put(params).promise()
    responseBody = JSON.stringify(data)
    statusCode = 201
  } catch (err) {
    responseBody = `Unable to put Todo: ${err}`
    statusCode = 403
  }

  var response = {
    statusCode: statusCode,
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(responseBody),
  }

  return response
}