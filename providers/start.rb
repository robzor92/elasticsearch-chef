action :run do

  kagent_config "elasticsearch" do
    action :systemd_reload
  end
    
  Chef::Log.info  "Elastic Ip is: #{new_resource.elastic_url}, User: #{new_resource.user}"
  
  elastic_http 'poll elasticsearch' do
    action :get
    url "#{new_resource.elastic_url}/"
    user new_resource.user
    password new_resource.password
  end

  elastic_http 'delete projects index' do
    action :delete 
    url "#{new_resource.elastic_url}/projects"
    user new_resource.user
    password new_resource.password
    only_if_cond node['elastic']['projects']['reindex'] == "true"
    only_if_exists true
  end
  
  elastic_http 'elastic-install-projects-index' do
    action :put
    url "#{new_resource.elastic_url}/#{node['elastic']['epipe']['search_index']}"
    user new_resource.user
    password new_resource.password
    only_if_exists false
    message '
    {
       "mappings":{
          "dynamic":"strict",
          "properties":{
             "doc_type":{
                "type":"keyword"
             },
             "project_id":{
                "type":"integer"
             },
             "dataset_id":{
                "type":"long"
             },
             "public_ds":{
                "type":"boolean"
             },
             "description":{
                "type":"text"
             },
             "name":{
                "type":"text"
             },
             "parent_id":{
                "type":"long"
             },
             "partition_id":{
                "type":"long"
             },
             "user":{
                "type":"keyword"
             },
             "group":{
                "type":"keyword"
             },
             "operation":{
                "type":"short"
             },
             "size":{
                "type":"long"
             },
             "timestamp":{
                "type":"long"
             },
             "xattr":{
                "type":"nested",
                "dynamic":true
             }
          }
       }
    }'
  end

  elastic_http 'elastic-create-logs-template' do
    action :put 
    url "#{new_resource.elastic_url}/_template/logs"
    user new_resource.user
    password new_resource.password
    message '
    {
       "index_patterns":[
          "*_logs-*"
       ],
       "mappings":{
          "properties":{
             "application":{
                "type":"keyword"
             },
             "host":{
                "type":"keyword"
             },
             "jobname":{
                "type":"keyword"
             },
             "class":{
                "type":"keyword"
             },
             "file":{
                "type":"keyword"
             },
             "jobid":{
                "type":"keyword"
             },
             "logger_name":{
                "type":"keyword"
             },
             "project":{
                "type":"keyword"
             },
             "log_message":{
                "type":"text"
             },
             "priority":{
                "type":"text"
             },
             "logdate":{
                "type":"date"
             }
          }
       }
    }'
  end

  elastic_http 'elastic-create-kagent-template' do
    action :put 
    url "#{new_resource.elastic_url}/_template/kagent"
    user new_resource.user
    password new_resource.password
    message '
    {
    "index_patterns":[
       "*_kagent-*"
    ],
    "mappings":{
       "properties":{
          "project_name":{
             "type":"keyword"
          },
          "operation":{
             "type":"keyword"
          },
          "artifact":{
             "type":"keyword"
          },
          "artifact_version":{
             "type":"keyword"
          },
          "return_code":{
             "type":"integer"
          },
          "return_message":{
             "type":"text"
          }
       }
     }
    }'
  end

  #Beam job server and sdkworker templates
  elastic_http 'elastic-create-beamjobserver-template' do
    action :put 
    url "#{new_resource.elastic_url}/_template/beamjobserver"
    user new_resource.user
    password new_resource.password
    message '
    {
       "index_patterns":[
          "*_beamjobserver-*"
       ],
       "mappings":{
          "properties":{
             "host":{
                "type":"keyword"
             },
             "jobname":{
                "type":"keyword"
             },
             "thread":{
                "type":"keyword"
             },
             "file":{
                "type":"keyword"
             },
             "logger_name":{
                "type":"keyword"
             },
             "project":{
                "type":"keyword"
             },
             "log_message":{
                "type":"text"
             },
             "priority":{
                "type":"text"
             },
             "jobport":{
                "type":"text"
             }
          }
       }
    }'
  end

  elastic_http 'elastic-create-beamsdkworker-template' do
    action :put 
    url "#{new_resource.elastic_url}/_template/beamsdkworker"
    user new_resource.user
    password new_resource.password
    message '
    {
       "index_patterns":[
          "*_beamsdkworker-*"
       ],
       "mappings":{
          "properties":{
             "host":{
                "type":"keyword"
             },
             "file":{
                "type":"keyword"
             },
             "project":{
                "type":"keyword"
             },
             "timestamp":{
                "type":"date"
             },
             "appid":{
                "type":"keyword"
             },
             "log_message":{
                "type":"text"
             }
          }
       }
    }'
  end

  elastic_http 'add_elastic_index_for_kibana' do
    action :put
    url "#{new_resource.elastic_url}/#{node['elastic']['default_kibana_index']}"
    user new_resource.user
    password new_resource.password
    message '{}'
    only_if_exists false
  end

  elastic_http 'elastic-install-file-prov-template' do
    action :put
    url "#{new_resource.elastic_url}/_template/file_prov"
    user new_resource.user
    password new_resource.password
    message '
    {
      "index_patterns": ["*__file_prov"],
      "mappings":{
        "properties":{
          "inode_id":{
            "type":"long"
          },
          "inode_operation":{
            "type":"keyword"
          },
          "inode_name":{
            "type":"text"
          },
          "user_id":{
            "type":"integer"
          },
          "app_id":{
            "type":"keyword"
          },
          "logical_time":{
            "type":"integer"
          },
          "create_timestamp":{
            "type":"long"
          },
          "timestamp":{
            "type":"long"
          },
          "project_i_id":{
            "type":"long"
          },
          "dataset_i_id":{
            "type":"long"
          },
          "parent_i_id":{
            "type":"long"
          },
          "partition_id":{
            "type":"long"
          },
          "entry_type":{
            "type":"keyword"
          },
          "ml_type":{
            "type":"keyword"
          },
          "ml_id":{
            "type":"keyword"
          },
          "r_create_timestamp":{
            "type":"text"
          },
          "r_timestamp":{
            "type":"text"
          },
          "project_name":{
            "type":"text"
          }
        }
      }
    }'
  end

  elastic_http 'elastic-install-app-provenance-index' do
    action :put
    url "#{new_resource.elastic_url}/#{node['elastic']['epipe']['app_provenance_index']}"
    user new_resource.user
    password new_resource.password
    message '
    {
      "mappings":{
        "properties":{
          "app_id":{
            "type":"keyword"
          },
          "app_state":{
            "type":"keyword"
          },
          "timestamp":{
            "type":"text"
          },
          "app_name":{
            "type":"text"
          },
          "app_user":{
            "type":"text"
          }
          }
      }
    }'
    only_if_exists false
  end
end
