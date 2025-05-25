import requests
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    url = "https://google.com"
    headers = {
        "Content-Type": "application/json"
    }
    try:
        logger.info("Sending GET request to URL: %s", url)
        r = requests.get(url, headers=headers, verify=False, timeout=10)
        logger.info("Received response with status code: %d", r.status_code)
        print(r.status_code)
        return {
            'statusCode': r.status_code,
            'body': r.text
        }
    except Exception as e:
        logger.error("Error occurred: %s", str(e))
        return {
            'statusCode': 500,
            'body': str(e)
        }
