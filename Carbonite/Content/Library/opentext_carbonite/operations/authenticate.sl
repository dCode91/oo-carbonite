########################################################################################################################
#!!
#! @input server_ip: Carbonite host
#! @input server_port: Carbonite port
#!
#! @output return_result: access token
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception"s stack trace if operation failed. Empty otherwise.
#!!#
########################################################################################################################
namespace: opentext_carbonite.operations
operation:
  name: authenticate
  inputs:
    - server_ip
    - server_port
    - client_id
    - client_secret:
        sensitive: true
    - grant_type
    - username
    - password:
        sensitive: true
  python_action:
    use_jython: false
    script: "import requests\nimport json\n\n# do not remove the execute function\ndef execute(server_ip, client_id, client_secret, grant_type, username, password):\n    # Replace the following variables with your actual API endpoint, headers, and payload (if required).\n    api_url = f\"https://{server_ip}:6326/oauth/token\"\n    api_headers = {\n        \"Content-Type\": \"application/x-www-form-urlencoded\"\n    }\n    api_payload = {\n        \"client_id\": client_id,\n        \"client_secret\": client_secret,\n        \"grant_type\": grant_type,\n        \"username\": username,\n        \"password\":password\n    }\n\n    response_data, error_message = call_carbonite_api(api_url, api_headers, api_payload)\n    if response_data:\n        return {\"return_result\": response_data.get(\"access_token\"), \"return_code\": \"0\" }\n    else if error_message:\n        return {\"exception\": error_message, \"return_code\": \"-1\"}\n        \n        \n# you can add additional helper methods below.\ndef call_carbonite_api(api_url, headers, payload=None):\n    try:\n        response = requests.post(api_url, headers=headers, json=payload)\n        # Check the response status code for success or error handling\n        if response.status_code == 200:\n            return response.json(), None\n        else:\n            error_message = f\"API call failed with status code: {response.status_code} /n {response.text}\"\n            return None, error_message\n    except requests.exceptions.RequestException as e:\n        error_message = f\"API call failed with exception: {e}\"\n        return None, error_message"
  outputs:
    - return_result:
        sensitive: false
    - return_code
    - exception
  results:
    - SUCCESS: '${return_code == 0}'
    - FAILURE
