require 'docker'
require_relative 'constants'

desc 'Build Docker Image'
task 'docker:build' do
  image = Docker::Image.build_from_dir('.', 't' => 'demo:latest')

  File.write('demo-image-id', image.id)

  puts 'Docker Image: demo built.'
end
