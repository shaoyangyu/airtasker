# frozen_string_literal: true

require 'thor'
class Hammer < Thor
  include Thor::Actions
  source_root '.'
end

class Hash
  def method_missing(methodname, *params)
    if self.class == Hash
      self[methodname] || self[methodname.to_s]
    else
      super
    end
  end
end

namespace :docker do
  config = JSON.parse(File.read('docker/dockerconfig.json'))
  TAG = ENV['TAG'] || 'latest'
  debug_yml = ENV['DEBUG_YAML'] || config.debug_yml
  prod_yml = ENV['PROD_YAML'] || config.prod_yml
  docker_repo = ENV['DOCKER_REPO'] || config.docker_repo
  task :bash, [:service] do |_t, args|
    exec_cmd("TAG=#{TAG} docker-compose -f #{debug_yml} exec #{args[:service] || config.service_name} #{config.shell_command}")
  end

  desc 'destroy all services container'
  task :down do |_t, _args|
    exec_cmd("TAG=#{TAG} docker-compose -f #{debug_yml} down")
  end

  desc 'start service with docker with prod env'
  task :run do
    exec_cmd("TAG=#{TAG} docker-compose -f #{prod_yml} up  -d")
  end

  desc 'build as docker image '
  task :build do
    exec_cmd(config.package_command.to_s)
    exec_cmd("TAG=#{TAG} docker build -t #{config.image_name}:#{TAG} -f #{config.docker_file} .")
  end

  desc 'release docker image '
  task :release do |_t, _args|
    if `TAG=#{TAG} docker images -f reference=#{config.image_name}:#{TAG} -q`.chop.empty?
      hammer.say('There is no local image for push')
    else
      remote_image = "#{docker_repo}/#{config.image_name}:#{TAG}"
      tag_cmd = "TAG=#{TAG} docker tag #{config.image_name}:#{TAG} #{remote_image}"
      exec_cmd(tag_cmd)
      push_cmd = "TAG=#{TAG} docker push #{remote_image}"
      exec_cmd(push_cmd)
      rmi_cmd = "TAG=#{TAG} docker rmi #{remote_image}"
      exec_cmd(rmi_cmd)
      hammer.say('pls commit code and push it manually！！')
    end
  end

  private

  def exec_cmd(*cmdstr, **opt)
    hammer.say cmdstr.join(' ')
    ret = hammer.run(cmdstr.join(' '), opt)
    exit -1 unless ret
    ret
  end

  def hammer
    Hammer.new
  end
end
