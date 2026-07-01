function ports --description 'Show listening ports and their processes'
    if command -q ss
        ss -tlnp 2>/dev/null; or ss -tlnp
    else if command -q netstat
        netstat -tlnp 2>/dev/null
    else if command -q lsof
        lsof -i -P -n | grep LISTEN
    else
        echo "ports: install ss (iproute2), netstat, or lsof" >&2
        return 1
    end
end
