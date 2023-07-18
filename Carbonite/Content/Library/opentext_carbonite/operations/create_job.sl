########################################################################################################################
#!!
#! @input other_servers: Stringified JSON for other servers' job credentials
#!
#! @output return_result: access token
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception"s stack trace if operation failed. Empty otherwise.
#!!#
########################################################################################################################
namespace: opentext_carbonite.operations
operation:
  name: create_job
  inputs:
    - access_token
    - source_domain
    - source_username
    - source_password:
        sensitive: true
    - source_host
    - source_port
    - target_domain
    - target_username
    - target_password:
        sensitive: true
    - target_host
    - target_port
    - other_servers:
        required: false
  python_action:
    use_jython: false
    script: "import requests\nimport json\n\n# do not remove the execute function\ndef execute(access_token, source_domain, source_username, source_password, source_host, source_port, target_domain, target_username, target_password, target_host, target_port, other_servers):\n    # Replace the following variables with your actual API endpoint, headers, and payload (if required).\n    api_url = f\"https://{server_ip}:6326/api/jobs\"\n    api_headers = {\n        \"Authorization\": f\"Bearer {access_token}\"\n    }\n    \n    source_credential = {\n        \"domain\" : source_domain,  \n        \"password\" : source_password,\n        \"userName\" : source_username\n    }\n    \n    target_credential = {\n        \"domain\" : target_domain,  \n        \"password\" : target_password,\n        \"userName\" : target_username\n    }\n    \n    source_server = {\n        \"credential\" : source_credential,\n        \"host\" : source_host,\n        \"port\" : source_port\n    }\n    \n    target_server = {\n        \"credential\" : source_credential,\n        \"host\" : source_host,\n        \"port\" : source_port\n    }\n    \n    other_servers = json.loads(other_servers)\n    \n    job_credentials = {\n        \"sourceServer\": source_server,\n        \"targetServer\": target_server,\n        \"otherServers\": other_servers\n    }\n\n    api_payload = {\n        \"jobCredentials\": job_credentials,\n        \"jobOptions\": job_options,\n        \"jobType\": job_type\n    }\n\n    response_data, error_message = call_carbonite_api(api_url, api_headers, api_payload)\n    if response_data:\n        return {\"return_result\": response_data.get(\"access_token\"), \"return_code\": \"0\" }\n    else if error_message:\n        return {\"exception\": error_message, \"return_code\": \"-1\"}\n        \n        \n# you can add additional helper methods below.\ndef call_carbonite_api(api_url, headers, payload=None):\n    try:\n        response = requests.post(api_url, headers=headers, json=payload)\n        # Check the response status code for success or error handling\n        if response.status_code == 200:\n            return response.json(), None\n        else:\n            error_message = f\"API call failed with status code: {response.status_code} /n {response.text}\"\n            return None, error_message\n    except requests.exceptions.RequestException as e:\n        error_message = f\"API call failed with exception: {e}\"\n        return None, error_message"
  outputs:
    - return_result
    - return_code
    - exception
  results:
    - SUCCESS
