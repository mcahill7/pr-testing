require 'json'
require 'aws-sdk'

def handler(event:, context:)
    begin
        github_token = ENV['GITHUB_TOKEN']

        if event['headers'].include? 'X-GitHub-Event'
            puts "true"
        else
            puts "false"
        end

    rescue
        puts "No Event"
    end

end