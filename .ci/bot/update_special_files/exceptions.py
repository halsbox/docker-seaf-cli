

class RequiredEnvVarNotFound(Exception):

    def __init__(self, environment_variable, message="Required environment variable not found"):
        self.environment_variable = environment_variable
        self.message = message

    def __str__(self):
        return f"{self.environment_variable}: {self.message}"


class MergeRequestNotYetApproved(Exception):

    def __init__(self, merge_request_iid, message="Merge request has not been approved"):
        self.merge_request_iid = merge_request_iid
        self.message = message

    def __str__(self):
        return f"{self.merge_request_iid}: {self.message}"


class MergeRequestAlreadyApprovedByBotMarvin(Exception):
    def __init__(self, message="Merge request has already been approved by @bot_marvin"):
        self.message = message

    def __str__(self):
        return f"{self.message}"