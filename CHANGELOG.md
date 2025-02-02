# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning v2.0.0](https://semver.org/spec/v2.0.0.html).

## v1.0.0 - In Progress

### Changed

- Deploys `Azure Virtual machines`: Linux and Windows
- Provisions `Azure Automation Account`
- Provisions runbook to update `Powershell modules` in `Automation Account`
- Dynamically provisions `Schedules` for runbook to update Powershell modules (current UTC+1) +0.5hr
- Provisions runbook to automatically `Start` and `Stop` VMs in a resource groups based on `VM tags`
- Dynamically provisions schedules for `Start` and `Stop` VMs runbook (current UTC+1) +1hr
