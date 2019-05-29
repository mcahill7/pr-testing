require 'json'
require 'aws-sdk'
require 'octokit'

def handler(event:, context:)
  github_token = ENV['GITHUB_TOKEN']
  begin
    pull_request_branch_sha = event['detail']['additional-information']['source-version']
    github_repo = event['detail']['additional-information']['source']['location']

    puts pull_request_branch_sha.to_s
    puts github_repo.to_s
    client = Octokit::Client.new(:access_token => github_token)


  rescue StandardError
    puts 'No Event'
  end
end
