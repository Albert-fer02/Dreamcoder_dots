function killport --description 'Kill process running on a specific port'
    if test (count $argv) -ne 1
        echo "Usage: killport <port_number>"
        return 1
    end
    set -l port $argv[1]
    set -l pid (lsof -ti :$port 2>/dev/null)
    if test -z "$pid"
        echo "killport: no process found on port $port"
        return 1
    end
    echo "Killing PID $pid on port $port..."
    kill -15 $pid 2>/dev/null
    sleep 0.5
    if kill -0 $pid 2>/dev/null
        echo "Process didn't stop, sending SIGKILL..."
        kill -9 $pid 2>/dev/null
    end
    echo "✓ Port $port freed"
end
