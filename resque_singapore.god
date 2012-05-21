#combined file

RAILS_ENV_GLOBAL = ENV['RAILS_ENV'] || "production"
RAKE_PATH = "/usr/bin/rake"
#num_workers = rails_env == 'production' ? 2 : 1
#num_workers = rails_env == 'production' ? 1 : 1
RESQUE_GROUPS ={:crmtools=> {}, :estorm => {}, :paulaner => {}}
RESQUE_GROUPS[:crmtools]={:group => "crmtools",:queues =>"crmtools_mimi_status,crmtools_acquisition,crmtools_promotion,crmtools_automata",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/crmtools", :num_workers => 3}
RESQUE_GROUPS[:paulaner]={:group => "paulaner",:queues =>"paulaner_mimi_status,paulaner_acquisition,paulaner_promotion,paulaner_automata",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/paulaner", :num_workers => 4}
RESQUE_GROUPS[:estorm]={:group => "estorm",:queues =>"estormcrm_crm,estormcrm_dms",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/admin/estormcrm", :num_workers => 1}


God.load "contacts.god"
God.load "redis.god"
#:seaside2 => {}, :seaside3 => {}
SEASIDE_GROUPS ={:seaside1=> {} }
SEASIDE_GROUPS[:seaside1]={:group => "seaside1",:seaside_root =>  "/var/sites/ses.sg.estormtech.com/", :ports => [8083,8084], :image => "sesbase.image"}


