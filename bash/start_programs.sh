kill_process() {
    process_name="$1"
    pid=$(pgrep "$process_name")
    
    if [ -z "$pid" ]; then
        echo "Process '$process_name' is not running."
    else
        echo "Killing process '$process_name' with PID $pid..."
        kill "$pid"
        echo "Process '$process_name' killed."
    fi
}

programs=("iox-roudi" "ctp_trader" "ctp_md" "md_strategy")
for program in "${programs[@]}"
do
    kill_process ${program}
    ./${program} &
    sleep 1
done
    
