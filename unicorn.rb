default_workers = 4
env_worker_param = ENV['SB_WORKERS'].to_i
number_of_workers = env_worker_param < default_workers ? default_workers : env_worker_param

worker_processes number_of_workers
        timeout 90