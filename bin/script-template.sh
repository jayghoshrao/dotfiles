#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --flag      Some flag description
-p, --param     Some param description
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

die2() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -f | --flag) flag=1 ;; # example flag
    -p | --param) # example named parameter
      param="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ -z "${param-}" ]] && die "Missing required parameter: param"
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

parse_params "$@"
setup_colors

# script logic here

msg "${RED}Read parameters:${NOFORMAT}"
msg "- flag: ${flag}"
msg "- param: ${param}"
msg "- arguments: ${args[*]-}"

msg() { echo >&2 -e "==> ${1-}"; }
die() { echo -e "ERROR: $*" >&2; exit 1; }

# check_cmd()  { [[ -x $(command -v "$1") ]]; } ## Avoids shell builtins
check_cmd()  { command -v "$1" >/dev/null 2>&1; }  
check_exe()  { [[ -x "$1" ]]; }
check_dir()  { [[ -d "$1" ]]; }
check_file() { [[ -f "$1" ]]; }

ensure_cmd()  { check_cmd  "$1" || die "no such command: $1"; }
ensure_exe()  { check_exe  "$1" || die "Executable not found: $1"; }
ensure_dir()  { check_dir  "$1" || die "Dir not found: $1"; }
ensure_file() { check_file "$1" || die "File not found: $1"; }

check_cmds() { for a in "$@"; do check_cmd "$a" || return 1; done; }
check_files() { for a in "$@"; do check_file "$a" || return 1; done; }

ensure_cmds() { for a in "$@"; do ensure_cmd "$a"; done; }
ensure_files() { for a in "$@"; do ensure_file "$a"; done; }
ensure_dirs() { for a in "$@"; do ensure_dir "$a"; done; }

ensure_run() { ensure_cmd "$1"; "$@" || die "Command exited with error: $*"; }

ensure_match_all() { local re=$1; shift; for a in "$@"; do [[ "$a" =~ $re ]] || die "$a doesn't match $re"; done; }

ensure_match_any() { local re=$1; shift; for a in "$@"; do [[ "$a" =~ $re ]] && return 0; done; return 1; }

# Membership: needle is $1, array elements are the rest -> check_in_array "$needle" "${arr[@]}"
check_in_array()  { local needle=$1; shift; for a in "$@"; do [[ "$a" == "$needle" ]] && return 0; done; return 1; }
ensure_in_array() { local needle=$1; check_in_array "$@" || die "not in array: $needle"; }



# POSITIONAL=()
# while [[ $# -gt 0 ]]
# do
#     key="$1"
#     case $key in
#         -d|--dump) 
#             MODE="DUMP"; shift ;;
#         *) POSITIONAL+=("$1"); shift ;;
#     esac
# done
# set -- "${POSITIONAL[@]}" # restore positional parameters


# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

confirm() {
    local prompt="${1:-Are you sure?}"
    read -rp "$prompt [y/N] " response
    [[ "$response" =~ ^[Yy]$ ]]
}


parse_params_2() {
  POSITIONAL=()
  while [[ $# -gt 0 ]] ; do
    key="$1"
    case $key in
      -o|--opt-long) OPT="$2"; shift 2 ;;
      -f|--flag-long) FLAG=true; shift ;;
      *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
  done
  set -- "${POSITIONAL[@]}" # restore positional parameters
}
