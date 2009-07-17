require File.join(File.dirname(__FILE__), "../lib/deployed_it.rb")

def remember_deploy(deploy_message)
  current_rev = current_revision.to_i + 1
  head_rev = real_revision
  svn_log = capture("cd #{current_path} && svn log -r #{head_rev}:#{current_rev}") rescue 'nothing'
  app_name = exists?(:stage) ? "#{application} (#{stage})" : application

  client = DeployedIt::Client.new(deployedit_server)

  begin
    client.new_deploy(app_name, ENV['USER'], deploy_message, svn_log, head_rev, current_rev)
  rescue
    Capistrano::CLI.ui.say("<%= color('deployed_at is not available, continuing anyway ...', BOLD, BLUE) %>")
  end
end

_cset(:deployedit_server) { abort "Please specify the URL where your deployed_it server is running, set :deployedit_server, 'http://dev.example.org:4567'" }

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
