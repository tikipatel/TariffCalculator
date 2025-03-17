const core = require('@actions/core');
const github = require('@actions/github');

async function run() {
  try {
    // Get inputs from the workflow
    const token = core.getInput('github-token', { required: true });
    
    // Create an authenticated Octokit client
    const octokit = github.getOctokit(token);
    
    // Get the current context (PR information)
    const context = github.context;
    
    if (!context.payload.pull_request) {
      core.setFailed('This action only works on pull request events.');
      return;
    }
    
    // Get PR details
    const prNumber = context.payload.pull_request.number;
    const repo = context.repo;
    
    // The PR URL we want to append
    const prUrl = context.payload.pull_request.html_url;
    
    // Get the current PR description
    const { data: pullRequest } = await octokit.rest.pulls.get({
      owner: repo.owner,
      repo: repo.repo,
      pull_number: prNumber
    });
    
    const currentBody = pullRequest.body || '';
    
    // Check if the PR URL is already in the description
    if (currentBody.includes(prUrl)) {
      console.log('PR URL is already in the description. No changes needed.');
      return;
    }
    
    // Prepare new body with appended PR link
    let newBody;
    if (currentBody.trim() === '') {
      newBody = `\n\n---\n\nPull Request URL: ${prUrl}`;
    } else {
      newBody = `${currentBody}\n\n---\n\nPull Request URL: ${prUrl}`;
    }
    
    // Update the PR description
    await octokit.rest.pulls.update({
      owner: repo.owner,
      repo: repo.repo,
      pull_number: prNumber,
      body: newBody
    });
    
    console.log('Successfully appended PR URL to the description.');
    
  } catch (error) {
    core.setFailed(`Action failed with error: ${error.message}`);
  }
}

run();
