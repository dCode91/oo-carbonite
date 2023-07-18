########################################################################################################################
#!!
#! @input server_ip: Carbonite host
#! @input server_port: Carbonite port
#!
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception"s stack trace if operation failed. Empty otherwise.
#!!#
########################################################################################################################
namespace: opentext_carbonite.operations
operation:
  name: start_job
  inputs:
    - server_ip
    - server_port: '6326'
    - access_token:
        sensitive: true
    - job_id
  python_action:
    use_jython: false
    script: "import requests\nimport json\n\n# do not remove the execute function\ndef execute(server_ip, server_port, job_id, access_token):\n    # Replace the following variables with your actual API endpoint, headers, and payload (if required).\n    api_url = f\"https://{server_ip}:{server_port}/api/jobs/{job_id}/start\"\n    api_headers = {\n        \"Authorization\": f\"Bearer {access_token}\"\n        \"Content-Type\" : \"application/json\"\n    }\n\n    response_data, error_message = call_carbonite_api(api_url, api_headers)\n    if response_data:\n        return {\"return_result\": response_data, \"return_code\": \"0\" }\n    else if error_message:\n        return {\"exception\": error_message, \"return_code\": \"-1\"}\n        \n        \n# you can add additional helper methods below.\ndef call_carbonite_api(api_url, headers, payload=None):\n    try:\n        response = requests.post(api_url, headers=headers, json=payload)\n        # Check the response status code for success or error handling\n        if response.status_code == 200:\n            return response.json(), None\n        else:\n            error_message = f\"API call failed with status code: {response.status_code} /n {response.text}\"\n            return None, error_message\n    except requests.exceptions.RequestException as e:\n        error_message = f\"API call failed with exception: {e}\"\n        return None, error_message"
  outputs:
    - return_result
    - return_code
    - exception
  results:
    - SUCCESS: '${return_code == 0}'
    - FAILURE
