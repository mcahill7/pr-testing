load_paths = Dir["./vendor/bundle/ruby/2.5.0/gems/**/lib"]
$LOAD_PATH.unshift(*load_paths)

require 'json'
require 'aws-sdk'
require 'rspec'

def handler(event:, context:)
    github_token = ENV['GITHUB_TOKEN']

       repo_url = event['detail']['additional-information']['source']['location']
       branch_sha = event['detail']['additional-information']['source-version']
       repo_name = repo_url.delete_prefix('https://github.com/').partition("/").last
        puts "repo url: #{repo_url}"
        puts "branch sha: #{branch_sha}"
        puts "repo name: #{repo_name}"
        `cd /tmp && curl -LO #{repo_url}/archive/master.zip`
        puts `ls /tmp && unzip /tmp/master.zip -d /tmp`
        #`cd /tmp/#{repo_name}-master && rspec`
        RSpec::Core::Runner.run(["/tmp/#{repo_name}-master/spec"])
        json_from_file = File.read("/tmp/master/coverage/.last_run.json")
        json = JSON.parse(json_from_file)
        coverage = json['result']['covered_percent']
        puts coverage
        `cd /tmp && curl -LO https://github.com/mcahill7/pr-testing/archive/#{branch_sha}.zip`
        `unzip /tmp/#{repo_name}-#{branch_sha}.zip -d /tmp`

        #`cd /tmp/#{branch_sha} && rspec`
        RSpec::Core::Runner.run(["/tmp/#{repo_name}-#{branch_sha}/spec"])
        json_from_file = File.read("/tmp/#{repo_name}-#{branch_sha}/coverage/.last_run.json")
        json = JSON.parse(json_from_file)
        coverage = json['result']['covered_percent']
        puts coverage

end