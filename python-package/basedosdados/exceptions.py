"""
Exception classes for the package.
"""

#pylint: disable=C0301

class BaseDosDadosException(Exception):
    """Exclusive Exception from Base dos Dados"""


class BaseDosDadosAccessDeniedException(BaseDosDadosException):
    """Exception raised if the user provides a wrong GCP project ID."""

    def __init__(self):
        self.message = (
            "\nAre you sure you are using the right `billing_project_id`?"
            "\nYou must use the Project ID available in your Google Cloud"
            " console home page at https://console.cloud.google.com/home/dashboard"
            "\nIf you still don't have a Google Cloud Project, you have to "
            "create one.\n"
            "You can set one up by following these steps: \n"
            "1. Go to this link https://console.cloud.google.com/projectselector2/home/dashboard\n"
            "2. Agree with Terms of Service if asked\n"
            "3. Click in Create Project\n"
            "4. Put a cool name in your project\n"
            "5. Hit create\n"
            "6. Rerun this command with the flag `reauth=True`. \n"
            "   Like `read_table('br_ibge_pib', 'municipios', "
            "billing_project_id=<YOUR_PROJECT_ID>, reauth=True)`"
        )
        super().__init__(self.message)


class BaseDosDadosInvalidProjectIDException(BaseDosDadosException):
    """Exception raised if the user provides an invalid GCP project ID."""

    def __init__(self):
        self.message = (
            "\nYou are using an invalid `billing_project_id`.\nMake sure "
            "you set it to the Project ID available in your Google Cloud"
            " console home page at https://console.cloud.google.com/home/dashboard"
        )
        super().__init__(self.message)


class BaseDosDadosNoBillingProjectIDException(BaseDosDadosException):
    """Exception raised if the user provides no GCP billing project ID."""

    def __init__(self):
        self.message = (
            "\nWe are not sure which Google Cloud project should be billed.\n"
            "First, you should make sure that you have a Google Cloud project.\n"
            "If you don't have one, set one up following these steps: \n"
            "\t1. Go to this link https://console.cloud.google.com/projectselector2/home/dashboard\n"
            "\t2. Agree with Terms of Service if asked\n"
            "\t3. Click in Create Project\n"
            "\t4. Put a cool name in your project\n"
            "\t5. Hit create\n"
            "\n"
            "Copy the Project ID, (notice that it is not the Project Name)\n"
            "Now, you have two options:\n"
            "1. Add an argument to your function poiting to the billing project id.\n"
            "   Like `bd.read_table('br_ibge_pib', 'municipios', billing_project_id=<YOUR_PROJECT_ID>)`\n"
            "2. You can set a project_id in the environment by running the following command in your terminal: `gcloud config set project <YOUR_PROJECT_ID>`.\n"
            "   Bear in mind that you need `gcloud` installed."
        )
        super().__init__(self.message)


class BaseDosDadosAuthorizationException(BaseDosDadosException):
    """Exception raised if the user doesn't complete the authorization
    process correctly."""

    def __init__(self):
        self.message = (
            "\nAre you sure you did the authorization process correctly?\n"
            "If you were given the option to enter an authorization code, "
            "please try again and make sure you are entering the right one."
            "\nYou can try again by rerunning this command with the flag "
            "`reauth=True`. \n\tLike `read_table('br_ibge_pib', 'municipios',"
            " billing_project_id=<YOUR_PROJECT_ID>, reauth=True)`"
            "\nThen you can click at the provided link and get the right "
            "authorization code."
        )
        super().__init__(self.message)
