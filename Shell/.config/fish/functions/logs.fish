function logs --description 'Tail system logs with filters'
    if test (count $argv) -eq 0
        echo "Usage: logs [service] [options]"
        echo "Examples:"
        echo "  logs              Watch all system logs"
        echo "  logs sshd         Watch sshd service"
        echo "  logs --since 1h   Last hour of logs"
        return 1
    end
    if command -q journalctl
        if test (count $argv) -ge 1
            journalctl -fu $argv
        else
            journalctl -f
        end
    else if test -f /var/log/syslog
        tail -f /var/log/syslog
    else
        echo "logs: journalctl not available" >&2
        return 1
    end
end
