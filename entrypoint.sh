# Gets the OS that the script is running on
get_os() {
  os=""
  if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform
    os="Darwin"
    echo "DEBUG: This OS is running Darwin."
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
    os="Linux"
    echo "DEBUG: This OS is running Linux."
  else
    os="Unknown"
    echo "::warning::This script does not support the current OS."
  fi
  return os
}

# Sets the output of an output name
# E.g. set_output "output-name" "output-value"
set_output() {
  if [[ "$#" -ne 2 ]]; then
    echo "::error::Invalid number of arguments specified."
    exit 1
  fi
  output_name="$1"
  output_value="$2"

  echo "::set-output name=$output_name::$output_value"
}

# Initialise variables
DATE_FORMAT=${INPUT_DATE_FORMAT:-$DATE_FORMAT}
GET_LAST_MODIFIED_FILE_PATH=${INPUT_GET_LAST_MODIFIED_FILE_PATH:-$GET_LAST_MODIFIED_FILE_PATH}
# See the man page for date for more info
TZ=${INPUT_TIMEZONE:-${TIMEZONE:-$TZ}}
USE_UTC_TIMEZONE=${INPUT_USE_UTC_TIMEZONE:-$USE_UTC_TIMEZONE}
USE_ISO_8601_FORMAT=${INPUT_USE_ISO_8601_FORMAT:-$USE_ISO_8601_FORMAT}
USE_RFC_2822_FORMAT=${INPUT_USE_RFC_2822_FORMAT:-$USE_RFC_2822_FORMAT}
USE_RFC_3339_FORMAT=${INPUT_USE_RFC_3339_FORMAT:-$USE_RFC_3339_FORMAT}
USE_RFC_5322_FORMAT=${INPUT_USE_RFC_5322_FORMAT:-$USE_RFC_5322_FORMAT}
# Sets the --debug option for date (Linux)
DEBUG_MODE=${DEBUG_MODE:-false}
# Date options to be passed to the date command
date_options=()

if [[ "$DEBUG_MODE" = true || ($DEBUG_MODE == 1) ]]; then
  if [[ "$(get_os)" == "Linux" ]]; then
    echo "DEBUG: Enabling debug mode for the date command."
    date_options+=("--debug")
  else
    echo "::warning::Debug mode for the date command is not supported on platforms other than those running on Linux."
  fi
fi

if [[ -n "$GET_LAST_MODIFIED_FILE_PATH" ]]; then
  echo "DEBUG: Retrieving the last modified status of the specified file."
  date_options+=("-r $GET_LAST_MODIFIED_FILE_PATH")
fi

if [[ -n "$USE_ISO_8601_FORMAT" ]]; then
  if [[ "$(get_os)" == "Linux" ]]; then
    echo "DEBUG: Enabling ISO 8601 format."
    date_options+=("-I")
  else
    echo "::warning::The ISO 8601 format option for the date command is not supported on platforms other than those running on Linux."
  fi
fi
if [[ -n "$USE_RFC_2822_FORMAT" ]]; then
  if [[ "$(get_os)" == "Darwin" ]]; then
    echo "DEBUG: Enabling RFC 2822 format."
    date_options+=("-R")
  else
    echo "::warning::The RFC 2822 format option for the date command is not supported on platforms other than those running on Unix."
  fi
fi
if [[ -n "$USE_RFC_3339_FORMAT" ]]; then
  if [[ "$(get_os)" == "Linux" ]]; then
    echo "DEBUG: Enabling RFC 3339 format."
    date_options+=("--rfc-3339")
  else
    echo "::warning::The RFC 3339 format option for the date command is not supported on platforms other than those running on Linux."
  fi
fi
if [[ -n "$USE_RFC_5322_FORMAT" ]]; then
  if [[ "$(get_os)" == "Linux" ]]; then
    echo "DEBUG: Enabling RFC 5322 format."
    date_options+=("-R")
  else
    echo "::warning::The RFC 5322 format option for the date command is not supported on platforms other than those running on Linux."
  fi
fi

# This should go last
if [[ -n "$DATE_FORMAT" ]]; then
  # Escape the double-quotation marks
  date_options+=('"$DATE_FORMAT"')
fi

date_cmd_result=$(date "${date_options[*]}")

# Set output of the date command
set_output date "$date_cmd_result"
