## Server Operations Toolkit

This repository provides a set of Bash shell scripts designed to streamline server operations and security monitoring.

**What it Contains:**

- **parallel-ssh-executor.sh:** Allows you to execute a single command in parallel across all servers listed in a file.
- **ip-attack-monitor.sh:** Analyses a log file containing failed login attempts and displays them in a summarised format, helping you identify potential IP-based attacks.

**What You Can Do:**

- Efficiently execute tasks on multiple servers simultaneously with `parallel-ssh-executor.sh`.
- Monitor for suspicious activity by analysing login attempts with `report-login-failures.sh`.

**How to Use:**

1. **Clone the repository:**

```bash
git clone https://github.com/sebwylleman/server-operations-toolkit.git
```

2. **Make the scripts executable:**

```bash
cd server-operations-toolkit
chmod +x parallel-ssh-executor.sh
chmod +x report-login-failures.sh
```

3. **(For parallel-ssh-executor.sh)** Execute a command on multiple servers:

Refer to the script's documentation within the code for specific usage instructions.

4. **(For ip-attack-monitor.sh)** Analyse a log file:

```bash
./ip-attack-monitor.sh your_log_file.log
```

**Further Exploration:**

- Explore alternative methods for task execution and security monitoring.
- Enhance the scripts to handle different use cases or server environments.

**Key Learnings:**

- **Power of Scripting:** Shell scripting can automate repetitive tasks and manage multiple servers efficiently.
- **SSH for Remote Execution:** Leverage SSH for secure command execution on remote servers.
- **Parsing Arguments:** `getopts` is a valuable tool for handling command-line arguments in Bash scripts.
- **Data Processing:** Scripts can effectively process and analyse log files to gain insights.
- **Importance of Security:** Scripts should be designed with security best practices in mind (e.g., avoiding running with root privileges).
