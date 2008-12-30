require 'net/http'
require 'uri'

module DeployedIt
  class Client
    def initialize(service_root)
      @service_root = service_root
    end

    def new_deploy(app_name, user, title, scm_log, head_rev, current_rev)
      args = {'user'        => user,
              'title'       => title,
              'scm_log'     => scm_log,
              'head_rev'    => head_rev,
              'current_rev' => current_rev,
              'project'     => app_name }

      url = URI.parse(@service_root + '/deploys')
      Net::HTTP.post_form(url, args)
    end
  end
end
