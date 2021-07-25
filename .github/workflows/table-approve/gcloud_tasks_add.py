import os
from google.cloud import tasks_v2
from google.protobuf import timestamp_pb2, duration_pb2
import json
from pathlib import Path


def add_to_queue(
    client,
    dataset,
    table,
    limit,
    project,
    queue,
    location,
    url,
    service_account_email,
    in_seconds=None,
    task_name=None,
):

    payload = dict(dataset=dataset, table=table, limit=None)

    # Construct the fully qualified queue name.
    parent = client.queue_path(project, location, queue)

    # Construct the request body.
    task = {
        "http_request": {  # Specify the type of request.
            "http_method": tasks_v2.HttpMethod.POST,
            "url": url,
            "oidc_token": {"service_account_email": service_account_email},
        },
        "dispatch_deadline": duration_pb2.Duration(
            seconds=60 * 30
        ),  # 30m is maximum :/
        # "name": f"{dataset}-{table}",
    }

    if payload is not None:
        # The API expects a payload of type bytes.
        converted_payload = json.dumps(payload).encode()

        # Add the payload to the request.
        task["http_request"]["body"] = converted_payload
        task["http_request"]["headers"] = {"Content-type": "application/json"}

    # Use the client to build and send the task.
    response = client.create_task(request={"parent": parent, "task": task})

    print("Created task {}".format(response.name))
    print(f"Dataset: {dataset} Table: {table}")


def main():

    client = tasks_v2.CloudTasksClient()

    files = json.load(Path("/github/workspace/files.json").open("r"))

    for f in files:

        folder, *rest = f.split("/")

        if folder == "bases":

            dataset, table, *_ = rest

            if table not in ("README.md", "code"):

                add_to_queue(
                    client,
                    dataset=dataset,
                    table=table,
                    limit=None,
                    project=os.environ.get("INPUT_PROJECT_ID"),
                    queue=os.environ.get("INPUT_QUEUE"),
                    location=os.environ.get("INPUT_LOCATION"),
                    url=os.environ.get("INPUT_TASKURL"),
                    service_account_email=os.environ.get("INPUT_SERVICE_ACCOUNT"),
                )


if __name__ == "__main__":
    main()
