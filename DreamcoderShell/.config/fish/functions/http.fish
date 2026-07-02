function http --description 'HTTP request with pretty output (httpie wrapper)'
    if command -q http
        http $argv
    else if command -q curl
        curl -sI $argv[1] 2>/dev/null; or curl $argv
    else
        echo "http: install httpie for best results (brew install httpie)"
        return 1
    end
end
