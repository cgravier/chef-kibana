#
# Cookbook Name:: kibana
# Recipe:: dashboard
#
# Copyright 2014, Christophe Gravier <cgravier@gmail.com>, @chgravier
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# local variable for readability
myDashboardsDir = node[:kibana][:config][:default_dashboard][:directory]
myDefaultDashboardTemplate = node[:kibana][:config][:default_dashboard][:template]

# creates the target directory where to store the dashboard if it does not exist
directory myDashboardsDir do
    owner "www-data"
    mode 0755
    recursive true
    action :create
    not_if {  Dir.exist? myDashboardsDir }
end

# build the dashboard from the specified dashboard template in any case. 
template "#{myDashboardsDir}/mydefaultdashboard.json" do
  source myDefaultDashboardTemplate
  action :create
end

# re-symlink default dashboard to the newly built dashboard. TODO: couldbe improved.
bash "symlink_dashboard" do
  user "root"
  code <<-EOH
        rm -rf #{node['kibana']['install_path']}/kibana/app/dashboards/default.json
        ln -s #{myDashboardsDir}/mydefaultdashboard.json #{node['kibana']['install_path']}/kibana/app/dashboards/default.json
        EOH
end

# END.