#combined file

RAILS_ENV_GLOBAL = ENV['RAILS_ENV'] || "production"
RAKE_PATH = "/usr/bin/rake"
#num_workers = rails_env == 'production' ? 2 : 1
#num_workers = rails_env == 'production' ? 1 : 1
RESQUE_GROUPS ={:crmtools=> {}, :estorm => {}, :paulaner => {},  :tmstest => {}, :tmscc => {}, :bisa => {}}
RESQUE_GROUPS[:crmtools]={:group => "crmtools",:queues =>"crmtools_mimi_status,crmtools_acquisition,crmtools_promotion,crmtools_automata",:rails_root =>  "/var/sites/crmtools.estormtech.com/crmtools", :num_workers => 1}
RESQUE_GROUPS[:paulaner]={:group => "paulaner",:queues =>"paulaner_mimi_status,paulaner_acquisition,paulaner_promotion,paulaner_automata",:rails_root =>  "/var/sites/crmtools.estormtech.com/paulaner", :num_workers => 4}
RESQUE_GROUPS[:bisa]={:group => "bisa",:queues =>"bisa_mimi_status,bisa_acquisition,bisa_promotion,bisa_automata",:rails_root =>  "/var/sites/crmtools.estormtech.com/bisa", :num_workers => 2}
RESQUE_GROUPS[:estorm]={:group => "estorm",:queues =>"estormcrm_crm,estormcrm_dms",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/admin/estormcrm", :num_workers => 1}
RESQUE_GROUPS[:tmstest]={:group => "tmstest",:queues =>"tmstest_import",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/tms/tmstest", :num_workers => 1}
RESQUE_GROUPS[:tmslaos]={:group => "tmslaos",:queues =>"tms_import",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/tms/tms", :num_workers => 1}
RESQUE_GROUPS[:tmscc]={:group => "tmscc",:queues =>"tmscc_import",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/tms/tmscc", :num_workers => 1}


God.load "contacts.god"
God.load "redis.god"
#:seaside2 => {}, :seaside3 => {}
SEASIDE_GROUPS ={:seaside1=> {},:seaside2=>{}, :seaside3=>{} }
SEASIDE_GROUPS[:seaside1]={:group => "seaside1",:seaside_root =>  "/var/sites/ses.sg.estormtech.com/", :ports => [8083,8084], :image => "sesbase.image"}
SEASIDE_GROUPS[:seaside2]={:group => "seaside2",:seaside_root =>  "/var/sites/ses2.sg.estormtech.com/", :ports => [8088,8089,8090], :image => "ses2base.image"}
SEASIDE_GROUPS[:seaside3]={:group => "seaside3",:seaside_root =>  "/var/sites/ses3.sg.estormtech.com/", :ports => [8092,8093,8094], :image => "ses3base.image"}
God.load "seaside.god"


