import json
import os
import boto3

dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('DYNAMODB_TABLE_NAME')
table = dynamodb.Table(table_name)

def handler(event, context):
    try:
        body = json.loads(event['body'])
        user_id = body.get('user_id')
        name = body.get('name')
        email = body.get('email')

        if not user_id or not name or not email:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Missing required fields: user_id, name, or email'})
            }

        item = {
            'user_id': user_id,
            'name': name,
            'email': email
        }

        table.put_item(Item=item)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'User data added successfully', 'user_id': user_id})
        }
    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Invalid JSON in request body'})
        }
    except Exception as e:
        print(f"Error adding user: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Could not add user data'})
        }

if __name__ == "__main__":
    # Example usage for local testing
    event = {'body': '{"user_id": "user1", "name": "Raghava", "email": "raghava@gmail.com"}'}
    response = handler(event, None)
    print(response)