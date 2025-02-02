locals {
  vm_schedule_tags = {
    Environment = "DEV"
    Project     = "Terraform"
    # Polish time is UTC+1 so 9 00 - 17 00 Polish time is the period machines are ON.
    StopStartSchedule = "Weekdays=8:00-16:00 / Weekends=0"
  }

  schedule_update_ps_modules_start_time = "2025-02-02T02:30:00+01:00"
  schedule_start_stop_vm_name           = "StartStopVmSchedule"
  schedule_start_stop_vm_start_time     = "2025-02-02T02:50:00+01:00"
}
