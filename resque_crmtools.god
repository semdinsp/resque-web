rails_env = ENV['RAILS_ENV'] || "production"
rails_root = ENV['RAILS_ROOT'] || "/var/sites/crmtools.estormtech.com/crmtools"
num_workers = rails_env == 'production' ? 2 : 1
group = "crmtools"
puts "env: #{rails_env} root: #{rails_root}"

num_workers.times do |num|
  God.watch do |w|
    w.name = "resque_#{group}-#{num}"
    w.group = "resque_${group}"
    w.interval = 30.seconds
    w.dir = rails_root
    w.env = {"QUEUE"=>"mimi_status,promotion,acquisition", "RAILS_ENV"=>rails_env}
    w.start = "/usr/bin/rake  environment resque:work"

    w.uid = 'www-data'
    w.gid = 'www-data'

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
      on.condition(:process_exits) do |c|
	    c.notify = 'scott'
	  end
    end
  end
end