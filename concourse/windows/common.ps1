trap {
    write-error $_
    exit 1
}

$installation_dir = "C:"

$ruby23_path = join-path $installation_dir "ruby23"
$ruby23_bin_path = join-path $ruby23_path "bin"
$ruby23_exe = join-path $ruby23_bin_path "ruby.exe"

function start-cmd {
    param ($command, $arguments)
    $p = start-process $command $arguments -wait -passthru -redirectstandardoutput stdout.log -redirectstandarderror stderr.log
    return $p
}

function run-cmd {
    param ($command, $arguments)
    $p = start-cmd $command $arguments
    if ($p.exitcode -ne 0) {
        write-host "stdout:"
        write-host (get-content stdout.log)
        write-host "stderr:"
        write-host (get-content stderr.log)
        throw "$($command) $($arguments) returned error code: $($p.exitcode)"
    }
}

function stream-cmd {
    param ($command, $arguments)
    $cmdline = "$($command) $($arguments)"
    cmd /c $cmdline
    if (-not ($?)) {
        throw "$($cmdline) failed"
    }
}

function prepend-path {
    param ($dir)
    $env:PATH = $dir + ";" + $env:PATH
}
