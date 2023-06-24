using JSON

# Retrieve Job-defined env vars
TASK_INDEX = get(ENV, "CLOUD_RUN_TASK_INDEX", 0)
TASK_ATTEMPT = get(ENV, "CLOUD_RUN_TASK_ATTEMPT", 0)
# Retrieve User-defined env vars
SLEEP_MS = parse(Float64, get(ENV, "SLEEP_MS", "0"))
FAIL_RATE = parse(Float64, get(ENV, "FAIL_RATE", "0"))


"""Program that simulates work using the sleep method and random failures.

Args:
    sleep_ms: number of milliseconds to sleep
    fail_rate: rate of simulated errors
"""
function main(sleep_ms=0, fail_rate=0)
    println("Starting Task #$TASK_INDEX, Attempt #$TASK_ATTEMPT...")
    # Simulate work by waiting for a specific amount of time
    sleep(sleep_ms / 1000)  # Convert to seconds

    # Simulate errors
    random_failure(fail_rate)

    println("Completed Task #$TASK_INDEX.")
end

"""Throws an error based on fail rate

Args:
    rate: an integer between 0 and 1
"""
function random_failure(rate)
    if rate < 0 || rate > 1
        # Return without retrying the Job Task
        println(
            "Invalid FAIL_RATE env var value: $rate. "
            * "Must be a float between 0 and 1 inclusive."
        )
        return
    end

    random_failure = rand()
    if random_failure < rate
        throw(ErrorException("Task failed."))
    end
end

# Start script
function themain()
    try
        main(SLEEP_MS, FAIL_RATE)
    catch err
        iob = IOBuffer()
        Base.showerror(iob, err)
        # Base.show_backtrace(iob, Base.catch_backtrace())

        message = "Task #$TASK_INDEX, " *
            "Attempt #$TASK_ATTEMPT failed: " *
            String(take!(iob))

        println(JSON.json(Dict("message"=> message, "severity"=> "ERROR")))
        exit(1)  # Retry Job Task by exiting the process
    end
end

themain()
