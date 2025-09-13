#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -euo pipefail

# Set the timezone to Pacific Time for correct date generation
export TZ="America/Los_Angeles"

# --- 1. Generate Versions ---
# Version for today's release branch (e.g., 2.20250912.0)
RELEASE_VERSION="2.$(date +'%y%m%d').0"
BRANCH_NAME="release/$RELEASE_VERSION"

# Version for next week's main branch update (date of the next Thursday)
# NOTE: This will only work on GNU/Linux systems; when we move to Buildkite, we should revisit this
NEXT_VERSION="2.$(date -d "next Thursday" +'%y%m%d%T').0"

echo "--- Release Information ---"
echo "Release Branch Name: $BRANCH_NAME"
echo "Next Main Branch Version: $NEXT_VERSION"
echo "--------------------------"

# --- 2. Configure Git ---
git config --global user.name 'GitHub Actions'
git config --global user.email 'github-actions@github.com'

# --- 3. Create and Push Release Branch ---
echo "Step 1: Creating and pushing release branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"
git push origin "$BRANCH_NAME"
echo "Successfully pushed branch $BRANCH_NAME."

# --- 4. Switch Back to Main ---
echo "Step 2: Switching back to main branch."
git checkout main

# --- 5. Update Version on Main ---
echo "Step 3: Updating version on main to $NEXT_VERSION."
# make version $NEXT_VERSION
echo "$NEXT_VERSION" >> "versions.txt"

# --- 6. Commit and Push Update to Main ---
# Check if the 'make' command created any file changes
if [[ -n $(git status --porcelain) ]]; then
  echo "Detected changes. Committing and pushing to main."
  git add .
  git commit -m "Bump version to $NEXT_VERSION"
  git push origin main
  echo "Successfully pushed version update to main."
else
  echo "No changes detected after 'make version'. Nothing to commit."
fi

echo "Release process completed successfully."
