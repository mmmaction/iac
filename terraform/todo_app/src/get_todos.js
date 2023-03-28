
const AWS = require('aws-sdk')

const documentClient = new AWS.DynamoDB.DocumentClient()

var params = {
  TableName: process.env.TABLE_NAME
}

exports.handler = async function (event, context) {
  console.log("get todos called")


  let statusCode = 0
  let responseBody = {}

  try {
    const items = await documentClient.scan(params).promise()
    var data = {
      data: items.Items
    }
    responseBody = JSON.stringify(data)
    statusCode = 200
  } catch (err) {
    responseBody = `Unable to get Products: ${err}`
    statusCode = 403
  }

  const response = {
    statusCode: statusCode,
    headers: {
      "Content-Type": "application/json"
    },
    body: responseBody
  }

  return response
}