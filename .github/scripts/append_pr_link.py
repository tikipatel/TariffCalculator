import os
import requests

# Get relevant PR details
pr_number = os.environ["PR_NUMBER"]
repo = os.environ["REPO"]

# Get the token to use
token = os.environ["GITHUB_TOKEN"]

# PR link to append
pr_link = f"https://github.com/{repo}/pull/{pr_number}"
append_text = f"\n\n🔗 PR link: {pr_link}"

# Get current PR data
api_url = f"https://api.github.com/repos/{repo}/pulls/{pr_number}"
headers = {
    "Authorization": f"token {token}",
    "Accept": "application/vnd.github.v3+json"
}
response = requests.get(api_url, headers=headers)
if response.status_code != 200:
    print(f"Failed to fetch PR: {response.status_code} {response.text}")
    exit(1)

current_body = response.json().get("body") or ""

if pr_link in current_body:
    print("PR link already exists in description. Skipping update.")
else:
    new_body = current_body + append_text
    update_payload = {"body": new_body}
    update_response = requests.patch(api_url, headers=headers, json=update_payload)
    if update_response.status_code == 200:
        print("PR description updated successfully.")
    else:
        print(f"Failed to update PR: {update_response.status_code} {update_response.text}")
