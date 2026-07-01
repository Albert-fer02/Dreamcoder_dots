function extract --description 'Extract any archive type'
    if test (count $argv) -eq 0
        echo "Usage: extract <archive> [output_dir]"
        return 1
    end
    set -l file $argv[1]
    set -l dir (basename $file .(echo $file | sed 's/.*\.//'))
    if test (count $argv) -ge 2
        set dir $argv[2]
    end
    switch $file
        case '*.tar.gz' '*.tgz'
            tar -xzf $file -C (dirname $file) 2>/dev/null; or tar -xzf $file
        case '*.tar.bz2' '*.tbz2'
            tar -xjf $file
        case '*.tar.xz' '*.txz'
            tar -xJf $file
        case '*.tar.zst'
            tar --zstd -xf $file
        case '*.tar'
            tar -xf $file
        case '*.gz'
            gunzip -k $file
        case '*.bz2'
            bunzip2 -k $file
        case '*.xz'
            unxz -k $file
        case '*.zip'
            unzip $file -d $dir
        case '*.rar'
            unrar x $file $dir
        case '*.7z'
            7z x $file -o$dir
        case '*.zst'
            zstd -d $file -o $dir
        case '*'
            echo "extract: unknown archive type: $file"
            return 1
    end
end
