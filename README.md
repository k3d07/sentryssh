# SentrySSH

A bash-based SSH brute-force detection and reporting tool, built from the ground up with no external log-analysis libraries.

---

## Background

SentrySSH was built as a personal project to develop real, applied bash scripting skills — going beyond basic automation into functions, associative arrays, regex-based text processing, and modular script design — while working through a genuinely useful problem in security engineering: detecting SSH brute-force activity directly from raw authentication logs.

Rather than configuring an existing tool like `fail2ban` or relying on log-analysis libraries, every part of the parsing, detection, and reporting logic here is hand-built and verified against known test data, to ensure a real, working understanding of how brute-force detection actually functions under the hood.

## What It Does

SentrySSH reads an OpenSSH authentication log (the kind normally found at `/var/log/auth.log` on Debian/Ubuntu systems) and:

- Identifies failed SSH login attempts, filtering them out from successful logins and unrelated log activity
- Extracts the source IP, attempted username, and timestamp from each failed attempt
- Aggregates activity per IP — total attempts, distinct usernames tried, first and last seen timestamps
- Filters activity to a configurable recent time window
- Flags any IP whose failed-attempt count exceeds a configurable threshold
- Generates a clean, timestamped report of flagged activity
- Logs its own runs for use in automated/scheduled execution (e.g. via cron)
- Supports command-line flags and a config file for setting defaults

## Why Build This From Scratch

Building brute-force detection manually — rather than reaching for an existing tool — forces real engagement with:

- How an actual SSH auth log is structured, including inconsistent line formats (e.g. valid vs. "invalid user" login attempts)
- Text extraction with bash's native regex matching, and why naive approaches (fixed word position, simple `grep`) break down on real-world log variance
- Associative arrays and functions as tools for organizing state and logic cleanly
- Splitting a tool into single-responsibility components instead of one long script

## Folder Structure

```
sentryssh/
├── sentryssh.sh              # main entry point
├── lib/
│   ├── parse.sh               # extracts IP/user/timestamp from log lines
│   ├── aggregate.sh           # per-IP counting and tracking
│   ├── filter.sh              # time-window filtering
│   └── report.sh              # report formatting/output
├── config/
│   └── sentryssh.conf         # default threshold, time window, log path
├── logs/
│   └── sentryssh-run.log      # the tool's own run history
├── reports/                   # generated reports land here, timestamped
├── tests/
│   └── sample-auth.log        # hand-written test log used for verification
├── README.md
└── .gitignore
```

## Requirements

- Bash 4.0 or later (associative arrays require it)
- Developed and tested on WSL (Ubuntu) — should run on any standard Linux/macOS bash environment

## Usage

```bash
git clone <repo-url>
cd sentryssh
chmod +x sentryssh.sh
./sentryssh.sh --help
```

Basic run against a real auth log, with a custom threshold and time window:
```bash
./sentryssh.sh --log /var/log/auth.log --threshold 5 --window 60
```

**Flags:**
| Flag | Description |
|---|---|
| `--log <path>` | Path to the SSH auth log to analyze |
| `--threshold <n>` | Number of failed attempts before an IP is flagged |
| `--window <minutes>` | Only consider log activity within this many minutes of now |
| `--output <path>` | Where to write the generated report |
| `--help` | Show usage information |

Any flag not provided falls back to the defaults set in `config/sentryssh.conf`. CLI flags always override config file values.

Each run appends an entry to `logs/sentryssh-run.log` (timestamp, lines processed, IPs flagged), making it safe to schedule via cron without needing to babysit individual runs.

## Design Notes

- **Field extraction uses bash's built-in regex (`=~`)**, not `awk` or `cut`, because the attempted username shifts position depending on whether it's a real system username or an "invalid user" — a fixed-column approach can't handle both line shapes with one rule.
- **Each library file has one job.** `parse.sh` only extracts fields from raw lines; `aggregate.sh` handles counting; `filter.sh` and `report.sh` are similarly scoped — no logic is duplicated across files.
- **User-controlled input (usernames, IPs from the log) is never treated as trusted formatting input** — output uses `printf` with `%s` placeholders rather than interpolating log data directly into a format string, avoiding format-string-style bugs from attacker-influenced log content.
- **Test data is hand-written and fully documented**, so core logic can be validated against a known-correct answer rather than just "did it run without crashing."

## Roadmap / Stretch Goals

- Firewall block-command generation (print-only, never auto-executed)
- IP geolocation enrichment for flagged addresses
- Username enumeration pattern detection
- A `--watch` live-tail mode for real-time monitoring
- JSON output option for integration with other tooling

## License

*(Not yet decided — add a license here, e.g. MIT, once the project reaches a stable release.)*

## Author's Note

This project is part of a broader, self-directed path into applied security engineering. It's public as both a portfolio piece and a working example of hand-built, tested security tooling — feedback and suggestions are welcome.