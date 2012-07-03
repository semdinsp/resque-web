#SMALLTALK Seaside MONITORING via God


SEASIDE_GROUPS.each { |key,grp| 
  puts "starting  #{grp[:group]}  root:  #{grp[:seaside_root]} ports: #{grp[:ports].join(',')} image: #{grp[:image]} }"

  God.watch do |w|
    w.name = "#{grp[:group]}"
    w.group = "seaside"
    w.interval = 30.seconds
    w.dir = grp[:seaside_root]
    w.log = "/var/sites/godlog/#{grp[:group]}.log"
    w.start = "/usr/bin/CogVM -mmap 256m -vm-sound-null -vm-display-null #{grp[:image]}"
#	VM="/usr/bin/CogVM"
#	VM_PARAMS="-mmap 256m -vm-sound-null -vm-display-null"
#	IMAGE="sesbase.image"
#    w.uid = 'www-data' 
#    w.gid = 'www-data'
 w.uid = 'root' 
#    w.gid = 'www-data'
    lasttest="start"
    # retart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        lasttest = "memory usage"
        c.times = 2
      end
       on.condition(:cpu_usage) do |c|
	        c.interval = 10
	        c.above = 40.percent
	        c.times = 6
	        lasttest = "cpu usage"
	      end
        [400,500,'Refused'].each {|  retcode | 
          grp[:ports].each { |port| 
          puts "http checking: #{port} on #{grp[:group]} for return code #{retcode}"
	      on.condition(:http_response_code) do |c|
	        c.host = 'localhost'
	        c.port =  port
	        c.path = '/ficonabemail'
	        c.code_is = retcode
	        lasttest = "http #{port}: returncode check[#{retcode}]"
	#		c.interval = 30
	        c.timeout = 7.seconds
	        c.times = [3, 6]
	      end
	      }
	     }
		 
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
	    c.notify = {:contacts => ['scott'], :priority => 1, :category => "last test string: #{lasttest}"}
	  end
    end
  end

}