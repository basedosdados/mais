import base64
import csv
import json
import os

from google.oauth2 import service_account
from googleapiclient.discovery import build


def encode_credential(credential):
    credential = json.dumps(credential)
    credential = credential.encode("utf-8")
    credential = base64.b64encode(credential)
    return credential


def decode_credential(credential):
    credential = base64.b64decode(credential)
    credential = credential.decode("utf-8")
    credential = json.loads(credential)
    return credential


def read_report():
    with open("./report.csv", "r") as file:
        reader = csv.reader(file)
        values = [row for row in reader]
        values[1:] = sorted(values[1:], key=lambda x: x[-1])
        return {"values": values}


def write_sheet(spreadsheet_id, range_name, credential, scopes):
    credentials = service_account.Credentials.from_service_account_info(
        credential, scopes=scopes
    )

    service = build("sheets", "v4", credentials=credentials)
    sheet = service.spreadsheets()
    result = (
        sheet.values()
        .update(
            spreadsheetId=spreadsheet_id,
            range=range_name,
            valueInputOption="RAW",
            body=read_report(),
        )
        .execute()
    )

    return result


if __name__ == "__main__":
    spreadsheet_id = os.environ["SPREADSHEET_ID"]
    range_name = os.environ["RANGE_NAME"]

    credential = os.environ["GDOCS_SERVICE_ACCOUNT"]
    credential = decode_credential(credential)

    scopes = ["https://www.googleapis.com/auth/spreadsheets"]

    write_sheet(spreadsheet_id, range_name, credential, scopes)
