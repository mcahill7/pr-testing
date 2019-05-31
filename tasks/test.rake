require 'rake'
require 'rspec/core/rake_task'
require 'json'

desc 'Run tests'
RSpec::Core::RakeTask.new('demo:test') do |t|
  t.pattern = 'spec/*_spec.rb'
end

desc 'Get Code Coverage'
task 'coverage' do
  `rspec`
  json_from_file = File.read('./coverage/.last_run.json')
  json = JSON.parse(json_from_file)
  branch_coverage = json['result']['covered_percent']
  puts "Branch Coverage: #{branch_coverage}"

  repo_url = 'https://github.com/mcahill7/pr-testing'
  repo_name = repo_url.delete_prefix('https://github.com/').partition('/').last
  repo_owner = repo_url.delete_prefix('https://github.com/').partition('/').first

  `curl -LO #{repo_url}/archive/master.zip`
  `unzip master.zip && cd #{repo_name}-master && rspec`
  json_from_file = File.read("#{repo_name}-master/coverage/.last_run.json")
  json = JSON.parse(json_from_file)
  master_coverage = json['result']['covered_percent']
  puts "Master Coverage: #{master_coverage}"
  `rm -rf #{repo_name}-master && rm master.zip`
  coverage_delta = branch_coverage - master_coverage
  puts puts "Coverage Change: #{coverage_delta}"

  if ENV['CODEBUILD_SOURCE_VERSION'] != '' && ENV['GIT_TOKEN'] != ''
    git_post = `curl \https://api.github.com/repos/#{repo_owner}/#{repo_name}/statuses/#{ENV['CODEBUILD_SOURCE_VERSION']}?access_token=#{ENV['GIT_TOKEN']}\" \
    -H \"Content-Type: application/json\" \
    -X POST \
    -d \"{\"state\": \"success\", \"description\": \"Coverage Change: #{coverage_delta}%\"}\"
  `
  end
end
