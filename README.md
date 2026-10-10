# 9329_lab2

## 1. Overview

This project implements a simple antivirus system using Bash scripts. The antivirusd.sh script takes the source directory, quarantine directory, and scanning interval as arguments. It checks that the source directory exists, creates the quarantine directory if needed, and uses a scanning function to detect malicious files based on their extensions or suspicious keywords in their contents. Before scanning, it checks the whitelist to skip files previously marked as safe. The script compares directory snapshots at regular intervals and scans again when changes are detected.

The restore.sh script allows users to review quarantined files and choose to restore them, permanently delete them, or leave them unchanged. Restored files are added to the whitelist to prevent them from being flagged again. The Makefile simplifies running both scripts and ensures that the quarantine directory exists before execution.

## 2. Folder Hierarchy

9329_lab/
├── antivirusd.sh
├── restore.sh
├── antivirus-cron.sh
├── Makefile
├── whitelist.txt
├── directory-info.last
├── directory-info.new
├── test_dir/
└── quarantine/

## 3. Prerequisites and Installation

- The project requires Bash, and standard commands such as `grep`, `cmp`, `cp`, `rm`, and `ls`.

- Make is required to use the Makefile and to install it we used:

  sudo apt update
  sudo apt install make


- Cron is required and to install it we used:

  sudo apt update
  sudo apt install cron
  sudo systemctl enable --now cron


## 4. Instructions for Running Scripts

- It is required to make the scripts executable:

  chmod +x antivirusd.sh antivirus-cron.sh restore.sh


- Running the Antivirus Script:

  In the command line we should run:

  ./antivirusd.sh test_dir quarantine 5


- Running the Restore Tool:

  In the command line we should run:

  ./restore.sh test_dir quarantine


  - `test_dir`: Directory to monitor.
  - `quarantine`: Directory where detected files are copied.
  - `5`: Number of seconds between checks.

  (These arguments can be changed according to the users need)

## 5. Using the Makefile

The Makefile defines variables for the source directory, quarantine directory, and scanning interval. Its setup target creates the quarantine directory before running either tool.

-Run the antivirus:

make antivirus

-Run the restore tool:

make restore


## 6. Malicious-File Detection Rules

The project uses two detection rules. A file is considered malicious if it matches either rule, unless it is skipped by the whitelist feature.

### Flagged Extensions

The required extensions are defined in the extension regular expression in the scanning logic of antivirusd.sh and antivirus-cron.sh:

- `.exe`
- `.bat`
- `.vbs`
- `.scr`
- `.ps1`

### Flagged Content Keywords  (case-insensitive)

The required keywords are defined in the grep expression in both scanning scripts:

- `virus`
- `trojan`
- `malware`
- `worm`
- `ransomware`


## 7. Bonus 1: Cron Job

The cron-based script performs one scan per execution instead of running an infinite loop.

To configure the scheduled scan:

1. Install cron         (sudo apt update / sudo apt install cron / sudo systemctl enable --now cron) .
2. Make antivirus-cron.sh executable.
3. Open the user's crontab with `crontab -e`.
4. Add a cron entry using the absolute paths 
(* * * * * sleep 23; /home/asmaa/Desktop/os_lab/9329_lab2/antivirus-cron.sh /home/asmaa/Desktop/os_lab/9329_lab2/test_dir /home/asmaa/Desktop/os_lab/9329_lab2/quarantine >> /home/asmaa/Desktop/os_lab/9329_lab2/antivirus.log 2>&1)
5. verify the entry with `crontab -l`.
6. Inspect the log file to check scan results and errors.

Standard cron supports minute-level scheduling, not seconds. To approximate execution at second 23 of every minute, the cron command runs `sleep 23` before launching the script.

The wrapper checks the date and launches the antivirus scan only on the third Friday at 12:31 AM.

31 0 * * 5 /home/asmaa/Desktop/os_lab/9329_lab2/third-friday.sh >> /home/asmaa/Desktop/os_lab/9329_lab2/antivirus.log 2>&1


## 8. Bonus 2: Whitelist

The whitelist feature records files that the user restores through option 1 in restore.sh. The filename is saved in whitelist.txt so the decision persists across daemon restarts.

During scanning, the antivirus checks whether the file is in whitelist file by grep command. A matching filename is skipped, while files not on the whitelist are checked normally.