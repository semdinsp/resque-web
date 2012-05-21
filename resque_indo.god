#combined file

RAILS_ENV_GLOBAL = ENV['RAILS_ENV'] || "production"
#num_workers = rails_env == 'production' ? 2 : 1
num_workers = rails_env == 'production' ? 1 : 1
RESQUE_GROUPS ={ :estorm => {}}
RESQUE_GROUPS[:estorm]={:group => "estorm",:queues =>"indosat_crm,indosat_dms",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/admin/indosat", :num_workers => 2}

God.load "contacts.god"
God.load "redis.god"

