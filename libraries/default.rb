module PhpFpm
  module Helpers
    def ubuntu13xm?
      node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 13.10
    end
  end
end
