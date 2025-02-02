locals {
  vm_schedule_tags = {
    Environment = "DEV"
    Project     = "Terraform"
    # Polish time is UTC+1 so 9 00 - 17 00 Polish time is the period machines are ON.
    StopStartSchedule = "Weekdays=8:00-16:00 / Weekends=0"
  }

  current_time_utc1      = timestamp()                              # Gets the current UTC time
  current_time_local     = timeadd(local.current_time_utc1, "1h")   # Adjust to UTC+1
  update_ps_modules_time = timeadd(local.current_time_local, "30m") # +0.5 hours
  start_stop_vm_time     = timeadd(local.current_time_local, "1h")  # +1 hour

  schedule_update_ps_modules_start_time = formatdate("YYYY-MM-DD'T'HH:mm:ssZ", local.update_ps_modules_time)
  schedule_start_stop_vm_start_time     = formatdate("YYYY-MM-DD'T'HH:mm:ssZ", local.start_stop_vm_time)

  schedule_start_stop_vm_name = "StartStopVmSchedule"
}
