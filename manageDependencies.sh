#!/bin/bash
#
# Perform installations and updates of Unity3D projects dependencies.

NUGET_EXEC=""

NEXUS_SOURCE_NAME="${NEXUS_SOURCE_NAME}"
NEXUS_SOURCE_URL="${NEXUS_SOURCE_URL}"

ARTIFACT_ID=""
ARTIFACT_VERSION=""

#############################################################################
# Check if the system setup is OK to launch the script.
# Globals:
#   NUGET_EXEC
# Arguments:
#   None
# Returns:
#   None
#############################################################################
function checkSystemConfiguration()
{
  case "$(uname -s)" in
    Darwin)
      log "Operating System: Mac OS X"
      NUGET_EXEC="nuget"
      ;;

    Linux)
      log "Operating System: Linux"
      ;;

    CYGWIN*|MINGW*|MSYS*)
      log "Operating System: MS Windows"
      NUGET_EXEC="nuget"
      ;;

    *)
      log "Operating System: other OS"
      ;;
  esac

  readonly NUGET_EXEC
}

#############################################################################
# Check if the arguments are set up correctly.
# Globals:
#   None
# Arguments:
#   NEXUS_SOURCE_NAME
#   NEXUS_SOURCE_URL
#   ARTIFACT_ID
#   ARTIFACT_VERSION
# Returns:
#   None
#############################################################################
function checkArguments()
{
  local options
  while getopts "a:v:n:s:" options; do
    case "${options}" in
      a)
        ARTIFACT_ID="${OPTARG}"
        readonly ARTIFACT_ID
        ;;

      v)
        ARTIFACT_VERSION="${OPTARG}"
        readonly ARTIFACT_VERSION
        ;;

      n)
        NEXUS_SOURCE_NAME="${OPTARG}"
        readonly NEXUS_SOURCE_NAME
        ;;

      s)
        NEXUS_SOURCE_URL="${OPTARG}"
        readonly NEXUS_SOURCE_URL
	    ;;

      \?)
        log "Invalid option: -${OPTARG}"
        exit 1
        ;;

      :)
        log "Option -${OPTARG} requires an argument."
        exit 1
        ;;
    esac
  done

  if [[ -z "${ARTIFACT_ID}" ]]; then
    log "You must specify the name of the framework to install/update.
    Usage: ./manageDepencencies -a <ARTIFACT_ID>"
    exit 1;
  fi

  if [[ -z "${NEXUS_SOURCE_NAME}" || -z "${NEXUS_SOURCE_URL}" ]]; then
    log "You didn't have NEXUS_SOURCE_NAME nor NEXUS_SOURCE_URL set, they are mandatory.
    Usage: ./manageDepencencies -a <ARTIFACT_ID> -n <NEXUS_SOURCE_NAME> -s <NEXUS_SOURCE_URL>"
    exit 1;
  fi
}

#############################################################################
# Check if Nuget is configured with the Seabirds source.
# Globals:
#   NUGET_EXEC
#   NEXUS_SOURCE_NAME
#   NEXUS_SOURCE_URL
# Arguments:
#   None
# Returns:
# None
#############################################################################
function checkAndAddSeabirdsSource()
{
  if [[ $("${NUGET_EXEC}" sources List | grep -c "${NEXUS_SOURCE_NAME}") -ne 1 ]]; then

    log "Unable to find the Seabirds Framework source. Adding one for you... If the problem persists, check your NuGet.Config file."
    $("${NUGET_EXEC}" source Add -Name "${NEXUS_SOURCE_NAME}" -Source "${NEXUS_SOURCE_URL}" -Verbosity quiet)

    if [[ "$?" -ne 0 ]]; then
      log "Unable to add the Seabirds Framework source. Aborting..."
      exit 1
    fi

  fi
}

#############################################################################
# Install the dependencies of a newly created project in the last version.
# Globals:
#   NUGET_EXEC
#   NEXUS_SOURCE_NAME
# Arguments:
#   ARTIFACT_ID
#   ARTIFACT_VERSION
# Returns:
#   None
#############################################################################
function installOrUpdateDependencies()
{
  if [[ -d "Assets/Frameworks/${ARTIFACT_ID}" ]]; then
    log "Deleting the old framework to avoid files conflicts."
    rm -rfI Assets/Frameworks/"${ARTIFACT_ID}"
  fi

  if [[ -z "${ARTIFACT_VERSION}" ]]; then
    $("${NUGET_EXEC}" install "${ARTIFACT_ID}" -Source "${NEXUS_SOURCE_NAME}" -Verbosity quiet -NoCache -ExcludeVersion -OutputDirectory Assets/Frameworks > /dev/null 2>&1)
  else
    $("${NUGET_EXEC}" install "${ARTIFACT_ID}" -Source "${NEXUS_SOURCE_NAME}" -Version "${ARTIFACT_VERSION}" -Verbosity quiet -NoCache -ExcludeVersion -OutputDirectory Assets/Frameworks > /dev/null 2>&1)
  fi

  if [[ "$?" -ne 0 ]]; then
    log "Something went wrong while installing the dependencies. Check you didn't misspelled the packageID and that you have access to internet."
    exit 1
  fi

  log "Deleting all .nupkg files to avoid Unity3D addings unnecessary files to projects builds."
  rm -f Assets/Frameworks/**/*.nupkg
}

#############################################################################
# Log all messages to STDERR
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#############################################################################
function log()
{
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

#############################################################################
# Entry point of the script.
# Globals:
#   None
# Arguments:
#   $@
# Returns:
#   None
#############################################################################
function main()
{
  checkArguments "$@"

  log "Checking if the system setup is OK to launch the script."
  checkSystemConfiguration

  log "Checking if Nuget is configured with the Seabirds source."
  checkAndAddSeabirdsSource

  log "Installing/Updating ${ARTIFACT_ID} dependencies."
  installOrUpdateDependencies "${ARTIFACT_ID}" "${ARTIFACT_VERSION}"
}

main "$@"
