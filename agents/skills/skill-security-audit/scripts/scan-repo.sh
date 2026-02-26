#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:?Usage: scan-repo.sh <directory>}"
TARGET="$(cd "$TARGET" && pwd)"

RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

header() { echo -e "\n${CYAN}=== $1 ===${NC}"; }
scan() {
  local label="$1" pattern="$2" severity="${3:-HIGH}"
  local color="$YELLOW"
  [[ "$severity" == "CRITICAL" ]] && color="$RED"
  local result
  result=$(rg --no-heading -n -i --glob '!.git/**' "$pattern" "$TARGET" 2>/dev/null || true)
  if [[ -n "$result" ]]; then
    echo -e "${color}[$severity] $label${NC}"
    echo "$result" | head -30
    [[ $(echo "$result" | wc -l) -gt 30 ]] && echo "  ... (truncated)"
    echo
  fi
}

echo -e "${CYAN}Security Audit: ${TARGET}${NC}"
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "---"

# --- Prompt Injection ---
header "Prompt Injection"
scan "AI instruction override" \
  '(ignore previous|disregard.*instruction|forget.*instruction|you are now|act as|new system prompt|override.*instruction|IMPORTANT.*you must)' \
  CRITICAL
scan "Concealment instructions" \
  '(do not reveal|do not mention|hide this|keep this secret|never tell|don.t show|suppress.*output|invisible)' \
  CRITICAL
scan "AI roleplay / jailbreak" \
  '(pretend you|roleplay as|you are a|DAN mode|jailbreak|bypass.*filter|ignore.*safety|ignore.*guidelines)' \
  CRITICAL

# --- Reverse Shells & Backdoors ---
header "Reverse Shells & Backdoors"
scan "Reverse shell patterns" \
  '(bash\s+-i\s+>&|/dev/tcp/|mkfifo.*/tmp|nc\s+-[el]|ncat\s+-|socat\s+|python.*socket.*connect|ruby.*TCPSocket|perl.*socket.*INET)' \
  CRITICAL
scan "Encoded execution" \
  '(base64\s+-d\s*\|.*sh|echo\s+[A-Za-z0-9+/=]{20,}\s*\|\s*(base64|decode)|eval\s*\(\s*atob|eval\s*\(\s*Buffer\.from)' \
  CRITICAL

# --- Data Exfiltration ---
header "Data Exfiltration"
scan "Outbound data transfer" \
  '(curl\s+(-X\s+)?POST|wget\s+--post|curl.*--data|curl.*-d\s|fetch\(.*method.*POST|requests\.post|http\.request)' \
  HIGH
scan "DNS exfiltration" \
  '(nslookup|dig\s+|host\s+).*\$' \
  HIGH

# --- Security Controls ---
header "Security Controls Disabled"
scan "Firewall disabled" \
  '(ufw\s+disable|iptables\s+-F|firewalld.*disable|nft\s+flush)' \
  HIGH
scan "SELinux/AppArmor disabled" \
  '(setenforce\s+0|SELINUX=disabled|SELINUX=permissive|apparmor.*disable|aa-teardown)' \
  HIGH
scan "Overly permissive sudo" \
  'NOPASSWD.*ALL' \
  HIGH
scan "SSH security weakened" \
  '(PermitRootLogin\s+yes|PasswordAuthentication\s+yes|StrictHostKeyChecking.*no)' \
  MEDIUM

# --- Credential Exposure ---
header "Credential Exposure"
scan "Hardcoded passwords" \
  '(password\s*[:=]\s*["\x27][^"\x27]{3,}|passwd\s*[:=]\s*["\x27]|secret_?key\s*[:=]\s*["\x27])' \
  HIGH
scan "Private keys" \
  '(BEGIN\s+(RSA|DSA|EC|OPENSSH)\s+PRIVATE\s+KEY|BEGIN\s+PGP\s+PRIVATE)' \
  CRITICAL
scan "API tokens/keys" \
  '(AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36}|sk-[a-zA-Z0-9]{32,}|xox[bpsa]-[a-zA-Z0-9-]+)' \
  CRITICAL

# --- Log Erasure ---
header "Log Erasure & Anti-Forensics"
scan "History clearing" \
  '(history\s+-c|history\s+-w|HISTSIZE=0|HISTFILESIZE=0|unset\s+HISTFILE|export\s+HISTFILE=/dev/null)' \
  CRITICAL
scan "Log deletion" \
  '(rm\s+(-rf?\s+)?/var/log|truncate.*(/var)?/log|shred\s|wipe\s|>\s*/var/log)' \
  CRITICAL

# --- Persistence ---
header "Persistence Mechanisms"
scan "Cron/at persistence" \
  '(crontab|/etc/cron|at\s+now|at\s+-f)' \
  HIGH
scan "Shell profile modification" \
  '(>>.*\.(bashrc|bash_profile|profile|zshrc)|echo.*>>.*rc$)' \
  MEDIUM
scan "SSH key injection" \
  '(>>.*authorized_keys|ssh-keygen.*-f|ssh-copy-id)' \
  HIGH
scan "Systemd service creation" \
  '(systemctl\s+enable|/etc/systemd/system/.*\.service|/etc/init\.d/)' \
  MEDIUM

# --- Obfuscation ---
header "Obfuscation"
scan "Eval with variables" \
  '(eval\s+\$|eval\s+".*\$|eval\s+\(|exec\s*\(.*\$)' \
  HIGH
scan "Hex/octal encoded strings" \
  '(\\x[0-9a-fA-F]{2}){4,}' \
  MEDIUM
scan "Suspicious environment variable use" \
  '(\$\{!|indirect\s+expansion|nameref)' \
  MEDIUM

# --- Supply Chain ---
header "Supply Chain"
scan "Suspicious install scripts" \
  '(preinstall|postinstall|prepare).*:.*curl' \
  CRITICAL
scan "Unpinned dependencies from unusual sources" \
  '(git\+https?://|git\+ssh://|--extra-index-url)' \
  HIGH

# --- File permission abuse ---
header "File Permissions"
scan "World-writable permissions" \
  '(chmod\s+777|chmod\s+666|chmod\s+a\+w)' \
  HIGH
scan "SUID/SGID set" \
  '(chmod\s+[246][0-7]{2}[0-7]|chmod\s+[ug]\+s)' \
  HIGH

header "Scan Complete"
echo "Review flagged items manually. Context matters — lab/Vagrant scripts may legitimately disable security controls."
