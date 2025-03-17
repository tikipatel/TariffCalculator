# Append PR Link Action

This GitHub Action automatically appends the pull request URL to the end of the PR description if it's not already present.

## How It Works

When a pull request is opened or edited, this action:

1. Checks if the PR URL is already in the description
2. If not, appends the URL at the end with a nice separator
3. Updates the PR description

## Usage

Create a `.github/workflows/append-pr-link.yml` file in your repository with the following content:

```yaml
name: Append PR Link to Description

on:
  pull_request:
    types: [opened, edited]

jobs:
  append-pr-link:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '16'
          
      - name: Install dependencies
        run: npm install @actions/core @actions/github
        
      - name: Append PR Link
        uses: ./.github/actions/append-pr-link
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

Then, create the action files in `.github/actions/append-pr-link/`:

- `action.yml` - Action metadata
- `index.js` - Action code
- `package.json` - Dependencies

## Requirements

- The action runs on GitHub-hosted runners and requires Node.js 16.
- It uses the automatically provided `GITHUB_TOKEN` secret for authentication.

## License

MIT
