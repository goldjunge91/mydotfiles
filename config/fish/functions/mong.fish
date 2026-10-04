function mong --description "Manage MongoDB service"
    set -l subcommands start stop restart status manual connect help

    if test (count $argv) -eq 0
        echo "Usage: mongod [start|stop|restart|status|manual|connect|help]"
        return 1
    end

    set -l service_name "mongodb-community"

    switch $argv[1]
        case start stop restart
            echo "Attempting to $argv[1] MongoDB service..."
            brew services $argv[1] $service_name
            if test $status -ne 0
                echo "Error: Failed to $argv[1] MongoDB service."
                echo "You might need to run: sudo brew services $argv[1] $service_name"
                echo "If the issue persists, please check your MongoDB installation."
            end
        case status
            echo "MongoDB service status:"
            brew services list | grep $service_name
            or echo "MongoDB service not found in brew services list."
        case manual
            set -l config_file "/opt/homebrew/etc/mongod.conf"
            if not test -f $config_file
                set config_file "/usr/local/etc/mongod.conf"
            end
            if not test -f $config_file
                echo "Error: MongoDB configuration file not found."
                return 1
            end
            echo "Running MongoDB manually..."
            command mongod --config $config_file --fork
        case connect
            echo "Connecting to MongoDB shell..."
            mongosh
        case help
            echo "MongoDB Management Commands:
start   - Start MongoDB service
stop    - Stop MongoDB service
restart - Restart MongoDB service
status  - Check MongoDB service status
manual  - Run MongoDB manually
connect - Connect to MongoDB shell
help    - Show this help message"
        case '*'
            echo "Unknown subcommand: $argv[1]"
            echo "Run 'mongod help' for usage information."
            return 1
    end
end
function mong_info --description "Display MongoDB system information"
    set -l mong_version (command mongod --version 2>/dev/null | string match -r 'db version v(\d+\.\d+\.\d+)' | string sub -s 2)
    set -l config_file "/opt/homebrew/etc/mongod.conf"
    if not test -f $config_file
        set config_file "/usr/local/etc/mongod.conf"
    end

    echo "MongoDB System Information:"
    if test -n "$mongodb_version"
        echo "Version: $mongodb_version"
    else
        echo "Version: Not detected (mongod command not found or failed)"
    end
    echo "Architecture: "(uname -m)
    if test -f $config_file
        echo "Config file: $config_file"
    else
        echo "Config file: Not found"
    end
    echo "Service status:"
    brew services list | grep mongodb-community

    # Additional MongoDB runtime information
    echo ""
    echo "MongoDB Runtime Information:"
    if pgrep -f mongod > /dev/null
        echo "MongoDB process is running"
        echo "Process details:"
        ps aux | grep "[m]ongod" | awk '{print "PID: " $2 ", CPU: " $3 "%, MEM: " $4 "%"}'
    else
        echo "MongoDB process is not running"
    end
end
function mong-info --description "Display MongoDB system information"
    set -l mong_version (command mongod --version 2>/dev/null | string match -r 'db version v(\d+\.\d+\.\d+)' | string sub -s 2)
    set -l config_file "/opt/homebrew/etc/mongod.conf"
    if not test -f $config_file
        set config_file "/usr/local/etc/mongod.conf"
    end

    echo "MongoDB System Information:"
    if test -n "$mongodb_version"
        echo "Version: $mongodb_version"
    else
        echo "Version: Not detected (mongod command not found or failed)"
    end
    echo "Architecture: "(uname -m)
    if test -f $config_file
        echo "Config file: $config_file"
    else
        echo "Config file: Not found"
    end

    # Homebrew installation details
    set -l brew_info (brew info mongodb-community)
    echo "Homebrew package:"
    echo $brew_info | string match -r 'mongodb-community: stable .*' | string replace -r '^mongodb-community: ' ''
    echo $brew_info | string match -r 'From: https://.*'
    echo $brew_info | string match -r 'Installed.*'

    echo "Service status:"
    brew services list | grep mongodb-community

    echo ""
    echo "MongoDB Runtime Information:"
    set -l mongod_processes (pgrep mongod)
    if test -n "$mongod_processes"
        echo "MongoDB process(es) running:"
        for pid in $mongod_processes
            set -l process_info (ps -o pid=,pcpu=,pmem=,command= -p $pid)
            echo $process_info | awk '{printf "PID: %s, CPU: %s%%, MEM: %s%%, Command: %s\n", $1, $2, $3, $4}'
        end
    else
        echo "No MongoDB processes currently running"
    end

    # Database storage information
    if test -d "/opt/homebrew/var/mongodb"
        echo ""
        echo "Database Storage:"
        du -sh /opt/homebrew/var/mongodb | awk '{print "Size: " $1}'
    end
end

# Autocompletion for mongodb_info function
complete -c mongodb-info -f -d "Display MongoDB system information"

# Autocompletion for mongod function
complete -c mong -f -a "start stop restart status manual connect help" -d "Manage MongoDB"
complete -c mong -f -n "__fish_seen_subcommand_from start" -d "Start MongoDB service"
complete -c mong -f -n "__fish_seen_subcommand_from stop" -d "Stop MongoDB service"
complete -c mong -f -n "__fish_seen_subcommand_from restart" -d "Restart MongoDB service"
complete -c mong -f -n "__fish_seen_subcommand_from status" -d "Check MongoDB service status"
complete -c mong -f -n "__fish_seen_subcommand_from manual" -d "Run MongoDB manually"
complete -c mong -f -n "__fish_seen_subcommand_from connect" -d "Connect to MongoDB shell"
complete -c mong -f -n "__fish_seen_subcommand_from help" -d "Show help for MongoDB commands"
# Autocompletion for mongodb_info function
complete -c mong_info -f -d "Display MongoDB system information"



function gos --description "Manage MongoDB Sharded Cluster Query Router"
    set -l subcommands start stop status help

    if test (count $argv) -eq 0
        echo "Usage: mongos [start|stop|status|help]"
        return 1
    end

    switch $argv[1]
        case start
            echo "Starting MongoDB Sharded Cluster Query Router..."
            mongos --config /opt/homebrew/etc/mongos.conf --fork
        case stop
            echo "Stopping MongoDB Sharded Cluster Query Router..."
            if set -l pid (pgrep -f "mongos --config")
                kill $pid
                echo "Mongos process (PID: $pid) stopped."
            else
                echo "No running mongos process found."
            end
        case status
            if pgrep -f "mongos --config" > /dev/null
                echo "MongoDB Sharded Cluster Query Router is running."
                ps aux | grep "[m]ongos --config" | awk '{print "PID: " $2 ", CPU: " $3 "%, MEM: " $4 "%"}'
            else
                echo "MongoDB Sharded Cluster Query Router is not running."
            end
        case help
            echo "MongoDB Sharded Cluster Query Router Commands:
start  - Start the mongos process
stop   - Stop the mongos process
status - Check the status of mongos
help   - Show this help message"
        case '*'
            echo "Unknown subcommand: $argv[1]"
            echo "Run 'mongos help' for usage information."
            return 1
    end
end

# Autocompletion for mongos function
complete -c gos -f -a "start stop status help" -d "Manage MongoDB Sharded Cluster Query Router"
complete -c gos -f -n "__fish_seen_subcommand_from start" -d "Start the mongos process"
complete -c gos -f -n "__fish_seen_subcommand_from stop" -d "Stop the mongos process"
complete -c gos -f -n "__fish_seen_subcommand_from status" -d "Check the status of mongos"
complete -c gos -f -n "__fish_seen_subcommand_from help" -d "Show help for mongos commands"

function gosh --description "Run MongoDB Shell"
    if test (count $argv) -eq 0
        command mongosh
    else
        switch $argv[1]
            case help
                echo "MongoDB Shell Usage:
mongosh           - Start MongoDB Shell
mongosh [options] - Start MongoDB Shell with options
mongosh help      - Show this help message"
            case '*'
                command mongosh $argv
        end
    end
end

# Autocompletion for mongosh function
complete -c gosh -f -a "help" -d "Show help for MongoDB Shell"
complete -c gosh -f -d "Run MongoDB Shell"


