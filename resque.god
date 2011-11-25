#combined file

rails_env = ENV['RAILS_ENV'] || "production"
#num_workers = rails_env == 'production' ? 2 : 1
num_workers = rails_env == 'production' ? 1 : 1
resque_groups ={:crmtools=> {},:estorm => {}, :collin => {}, :estorm2 => {}}
resque_groups[:crmtools]={:group => "crmtools",:queues =>"crmtools_mimi_status,crmtools_acquisition,crmtools_promotion,crmtools_automata",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/crmtools", :num_workers => 9}
resque_groups[:collin]={:group => "collin",:queues =>"collin_mimi_status,collin_acquisition,collin_promotion",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/collin", :num_workers => 1}
resque_groups[:estorm2]={:group => "estorm2",:queues =>"estorm2_mimi_status,estorm2_acquisition,estorm2_promotion,estorm2_crmtools,estorm2_automata",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/estorm", :num_workers => 1}
# resque_groups[:anmum]={:group => "anmum",:queues =>"anmum_mimi_status,anmum_acquisition,anmum_promotion",:rails_root => ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/anmum",:num_workers => 1}
resque_groups[:estorm]={:group => "estorm",:queues =>"estormcrm_crm,estormcrm_dms",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/admin/estormcrm", :num_workers => 1}
#resque_groups[:trimedia]={:group => "trimedia",:queues =>"trimedia_crm,trimedia_dms",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/admin/trimedia", :num_workers => 1}
# resque_groups[:etpi]={:group => "epti",:queues =>"etpi_crm,etpi_dms",:rails_root =>  ENV['RAILS_ROOT'] || "/var/sites/admin/etpi",:num_workers => 1}




resque_groups.each { |key,grp| 
  puts "starting  #{grp[:group]} queue: #{grp[:queues]} root:  #{grp[:rails_root]}"
grp[:num_workers].times do |num|
  God.watch do |w|
    w.name = "resque_#{grp[:group]}-#{num}"
    w.group = "resque_#{grp[:group]}"
    w.interval = 30.seconds
    # w.log = "/var/sites/godlog/#{w.name}.log"
    w.dir = grp[:rails_root]
    w.env = {"QUEUE"=>grp[:queues], "RAILS_ENV"=>rails_env}
    w.start = "/usr/bin/rake  environment resque:work"

    w.uid = 'www-data' if rails_env=='production'
    w.gid = 'www-data' if rails_env=='production'

    # retart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end
}