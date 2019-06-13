# PR-Testing

This repo contains codebuild project which is triggered by pull requests from this repository.
Our buildspec performs the following actions:
1. Installs our dependencies
2. Runs our rspec tests
3. Builds our docker image
4. Calculates difference in code coverage between branch and master and uses github status api to post it to PR
