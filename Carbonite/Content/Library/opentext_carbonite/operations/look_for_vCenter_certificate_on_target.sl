########################################################################################################################
#!!
#! @input server_ip: Carbonite host
#! @input server_port: Carbonite port
#!
#! @output return_result: job_id
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception"s stack trace if operation failed. Empty otherwise.
#!!#
########################################################################################################################
namespace: opentext_carbonite.operations
operation:
  name: look_for_vCenter_certificate_on_target
  inputs:
    - server_ip
    - server_port: '6326'
    - access_token:
        sensitive: true
    - vCenter_server
  python_action:
    use_jython: false
    script: "import requests\nimport json\n\n# do not remove the execute function\ndef execute(server_ip, server_port, access_token, vCenter_server):\n    # Replace the following variables with your actual API endpoint, headers, and payload (if required).\n    api_url = f\"https://{server_ip}:{server_port}/api/vra_service/certificate_needed?vim_server={vCenter_server}\"\n    api_headers = {\n        \"Authorization\": f\"Bearer {access_token}\",\n        \"Content-Type\" : \"application/json\"\n    }\n    \n    \n\n    response_data, error_message = call_carbonite_api(api_url, api_headers, api_payload)\n    if response_data:\n        return {\"return_result\": str(response_data), \n            \"return_code\": \"0\", \n            \"logical_rules\": str(response_data.get(\"logicalRules\")),\n            \"physical_rules\": str(response_data.get(\"physicalRules\")),\n            \"id\": str(response_data.get(\"id\")),\n            \"recovery_image_data_path\": str(response_data.get(\"recoveryImageDataPath\")),\n            \"server\": str(response_data.get(\"server\")),\n            \"workload_type_name\": str(response_data.get(\"workloadTypeName\"))\n        }\n    else if error_message:\n        return {\"exception\": error_message, \"return_code\": \"-1\"}\n        \n        \n# you can add additional helper methods below.\ndef call_carbonite_api(api_url, headers, payload=None):\n    try:\n        response = requests.get(api_url, headers=headers)\n        # Check the response status code for success or error handling\n        if response.status_code == 200:\n            return response.json(), None\n        else:\n            error_message = f\"API call failed with status code: {response.status_code} /n {response.text}\"\n            return None, error_message\n    except requests.exceptions.RequestException as e:\n        error_message = f\"API call failed with exception: {e}\"\n        return None, error_message"
  outputs:
    - return_result
    - return_code
    - exception
    - logical_rules
    - physical_rules
    - server
    - id
    - recovery_image_data_path
    - workload_type_name
  results:
    - SUCCESS: '${return_code == 0}'
    - FAILURE
