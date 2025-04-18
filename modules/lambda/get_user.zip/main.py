import json
import os
import boto3

dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('DYNAMODB_TABLE_NAME')
table = dynamodb.Table(table_name)

def handler(event, context):
    try:
        user_id = event['queryStringParameters'].get('user_id')

        if not user_id:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Missing required query parameter: user_id'})
            }

        response = table.get_item(Key={'user_id': user_id})

        if 'Item' in response:
            return {
                'statusCode': 200,
                'body': json.dumps(response['Item'])
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': f'User with ID {user_id} not found'})
            }
    except Exception as e:
        print(f"Error getting user: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Could not retrieve user data'})
        }

if __name__ == "__main__":
    # Example usage for local testing
    event = {'queryStringParameters': {'user_id': 'user1'}}
    response = handler(event, None)
    print(response)