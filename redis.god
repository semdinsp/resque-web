RESQUE_GROUPS.each { |key,grp| 
  puts "starting  #{grp[:group]} queue: #{grp[:queues]} root:  #{grp[:rails_root]}"
grp[:num_workers].times do |num|
  God.watch do |w|
    w.name = "resque_#{grp[:group]}-#{num}"
    w.group = "resque_#{grp[:group]}"
    w.interval = 30.seconds
    w.dir = grp[:rails_root]
    w.env = {"QUEUE"=>grp[:queues], "RAILS_ENV"=>RAILS_ENV_GLOBAL}
    w.log = "/var/sites/godlog/#{grp[:group]}-#{num}.log"
    w.start = "#{RAKE_PATH}  environment resque:work"

    w.uid = 'www-data' if RAILS_ENV_GLOBAL=='production'
    w.gid = 'www-data' if RAILS_ENV_GLOBAL=='production'

    # retart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 300.megabytes
        c.times = 3
      end
       on.condition(:cpu_usage) do |c|
	        c.interval = 10
	        c.above = 40.percent
	        c.times = 5
	        lasttest = "cpu usage"
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
}