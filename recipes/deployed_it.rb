require File.join(File.dirname(__FILE__), "../lib/deployed_it.rb")

def remember_deploy(deploy_message)
  current_rev = current_revision.to_i + 1
  head_rev = real_revision
  svn_log = capture("cd #{current_path} && svn log -r #{head_rev}:#{current_rev}") rescue 'nothing'

  client = DeployedIt::Client.new('http://localhost:4567')
  client.new_deploy(application, ENV['USER'], deploy_message, svn_log, head_rev, current_rev)
end

namespace :deploy do
  desc "Remember each deploy with a custom deploy message"
  task :remember_with_message do
    deploy_message = Capistrano::CLI.ui.ask("<%= color('Deploy message (like a commit message for deploys):', BOLD, BLUE) %>")
    remember_deploy(deploy_message)
  end

  desc "Remember each deploy"
  task :remember do
    remember_deploy('')
  end
end
