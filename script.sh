# logs of format [1;31m[ERRR] [0m2023/04/23 10:28:44 [SCAN_PLUGIN Handler Error]: err: Failed to load fqdns from cache, err: read tcp 192.168.0.187:49903->139.59.85.61:6379: i/o timeout
# This script is fecthing logs for the provided time diff
# awk command gets the log line one by one
# to extract time stamp from logs we are #2, $3 second and third column separated by space
#converting in expoch time in sec
# doing comparsion , followed by grep for further filtering


if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <time_difference> <log_file_path> [optional: <pattern>]"
  exit 1
fi

time_difference=$1 # pass time difference as argument to the script
search_pattern=$3 # pass search pattern as argument to the script
log_file=$2 # pass path to log file as argument to the script
end_time=$(date -u +%s)
start_time=$(date -u -d "$time_difference" +%s)
# sed 's/\x1b\[[0-9;]*m//g' for removing ansi escape sequences in logs 
sed 's/\x1b\[[0-9;]*m//g' "$log_file" | awk -v start="$start_time" -v end="$end_time" '{
    # Extract date and time values from log line
    date_value=$2
    time_value=$3

    # Combine date and time values into a single datetime string
    datetime=date_value " " time_value

    # Convert date and time to Unix timestamps using convert_to_unix_timestamp function
    # "datetime" is variable (-u is for utc time format) -d is for time diff
    "date -u -d \""datetime"\" +%s" | getline unix_timestamp

    # Compare Unix timestamp to start and end times
    if (unix_timestamp >= start && unix_timestamp <= end) {
        #print current log line
        print
    }
}' | if [ -z "$search_pattern" ]; then
                    cat
                else
                    grep -F "$search_pattern"
                fi



created this script to parse log file and fetch logs based on time diff (1hour/day/week ago).                                                            # bash ./script.sh "1 hour ago" ./file.log  (get all the logs for tim diff)
# bash ./script.sh "1 hour ago" ./file.log "Error" (get all the logs for time diff having error)


@channel created this script to parse log file and fetch logs based on time diff (1hour/day/week ago).
# bash ./script.sh "1 hour ago" ./file.log  (get all the logs for tim diff)
# bash ./script.sh "1 hour ago" ./file.log "Error" (get all the logs for time diff having error) 