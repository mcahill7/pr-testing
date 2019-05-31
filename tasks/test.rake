require 'rake'
require 'rspec/core/rake_task'
require 'json'

desc 'Run tests'
RSpec::Core::RakeTask.new('demo:test') do |t|
  t.pattern = 'spec/*_spec.rb'
end

desc 'Get Code Coverage'
task 'coverage' do
  repo_url = 'https://github.com/mcahill7/pr-testing'
  repo_name = repo_url.delete_prefix('https://github.com/').partition('/').last
  repo_owner = repo_url.delete_prefix('https://github.com/').partition('/').first
  token = ENV['GIT_TOKEN']
  source = ENV['CODEBUILD_SOURCE_VERSION']

  # Calculate coverage from current branch
  `rspec`
  json_from_file = File.read('./coverage/.last_run.json')
  json = JSON.parse(json_from_file)
  branch_coverage = json['result']['covered_percent']

  # pull master branch from github and calculate coverage for master branch
  `curl -LO #{repo_url}/archive/master.zip`
  `unzip master.zip && cd #{repo_name}-master && rspec`
  json_from_file = File.read("#{repo_name}-master/coverage/.last_run.json")
  json = JSON.parse(json_from_file)
  master_coverage = json['result']['covered_percent']

  # Remove master branch files
  `rm -rf #{repo_name}-master && rm master.zip`
  coverage_delta = if (branch_coverage - master_coverage) >= 0
                     '+' + (branch_coverage - master_coverage).to_s + '%'
                   else
                     '-' + (branch_coverage - master_coverage).to_s + '%'
                   end

  # Check if we are running in Codebuild, if so post results to github
  if ENV['CODEBUILD_SOURCE_VERSION'] != '' && ENV['GIT_TOKEN'] != ''
    `curl \"https://api.github.com/repos/#{repo_owner}/#{repo_name}/statuses/#{source}?access_token=#{token}\" -H \"Content-Type: application/json\" -X POST -d '{\"context\": \"Coverage Change\", \"state\": \"success\", \"description\": \"#{coverage_delta}\"}'`
  end
end
