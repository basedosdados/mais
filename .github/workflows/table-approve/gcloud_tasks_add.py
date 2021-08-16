import json
import os
from pathlib import Path

from google.cloud import tasks_v2
from google.protobuf import duration_pb2


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

    # construct the fully qualified queue name
    parent = client.queue_path(project, location, queue)

    # construct the request body
    task = {
        "http_request": {  # specify the type of request
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
        # the API expects a payload of type bytes
        converted_payload = json.dumps(payload).encode()

        # add the payload to the request
        task["http_request"]["body"] = converted_payload
        task["http_request"]["headers"] = {"Content-type": "application/json"}

    # use the client to build and send the task
    response = client.create_task(request={"parent": parent, "task": task})

    print("Created task {}".format(response.name))
    print(f"Dataset: {dataset} Table: {table}")


def gcloud_tasks_add():
    client = tasks_v2.CloudTasksClient()

    files = Path("/home/runner/work/mais/mais/files.json").open("r")
    files = json.load(files)

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
                    project=os.environ.get("PROJECT_ID"),
                    queue=os.environ.get("QUEUE"),
                    location=os.environ.get("LOCATION"),
                    url=os.environ.get("TASKURL"),
                    service_account_email=os.environ.get("SERVICE_ACCOUNT"),
                )


if __name__ == "__main__":
    gcloud_tasks_add()
