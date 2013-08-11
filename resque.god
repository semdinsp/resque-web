#combined file

RAILS_ENV_GLOBAL = ENV['RAILS_ENV'] || "production"
RAKE_PATH = "rake"
#rvn fix RAKE_PATH = "/var/lib/gems/1.8/bin/rake"
#num_workers = rails_env == 'production' ? 2 : 1
#num_workers = rails_env == 'production' ? 1 : 1
RESQUE_GROUPS ={:crmtools=> {},:estorm => {},  :estorm2 => {}}
RESQUE_GROUPS[:crmtools]={:group => "crmtools",:queues =>"crmtools_mimi_status,crmtools_acquisition,crmtools_promotion,crmtools_automata",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/crmtools", :num_workers => 9}
# RESQUE_GROUPS[:collin]={:group => "collin",:queues =>"collin_mimi_status,collin_acquisition,collin_promotion",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/collin", :num_workers => 1}
RESQUE_GROUPS[:estorm2]={:group => "estorm2",:queues =>"estorm2_mimi_status,estorm2_acquisition,estorm2_promotion,estorm2_crmtools,estorm2_automata",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/estorm", :num_workers => 1}
# RESQUE_GROUPS[:anmum]={:group => "anmum",:queues =>"anmum_mimi_status,anmum_acquisition,anmum_promotion",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/anmum",:num_workers => 1}
RESQUE_GROUPS[:estorm]={:group => "estorm",:queues =>"estormcrm_crm,estormcrm_dms",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/admin/estormcrm", :num_workers => 1}
#RESQUE_GROUPS[:trimedia]={:group => "trimedia",:queues =>"trimedia_crm,trimedia_dms",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/admin/trimedia", :num_workers => 1}
# RESQUE_GROUPS[:etpi]={:group => "epti",:queues =>"etpi_crm,etpi_dms",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/admin/etpi",:num_workers => 1}

God.load "contacts.god"
God.load "redis.god"

