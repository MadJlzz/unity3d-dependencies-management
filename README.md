# Unity3D dependencies management

`./manageDependencies.sh` is a simple Nuget wrapper script wrote in shell that allow to retrieve dependencies without using Visual Studio.

It was designed by the Seabirds Games team in order to facilitate dependencies management.

## Requirements

* Nuget v3.4.3+
* Personnal Sonatype Nexus

**Notes:**
> * For Windows, you will need the Git bash emulated terminal.
>   - I recommand [Git for Windows 2.5.0.windows.1](https://git-scm.com/downloads) or above.

## Installation

* Add `nuget.exe` to the PATH to allow the wrapper to call `nuget.exe` easily.
* Add `NEXUS_SOURCE_NAME` and `NEXUS_SOURCE_URL` to your `~./bash_profile` to skip `-n` && `-s` options. (See below)

## Usage

```bash
./manageDependencies -a <ARTIFACT_ID> -v <ARTIFACT_VERSION> -n <NEXUS_SOURCE_NAME> -s <NEXUS_SOURCE_URL>
```

## Contribute

Because this is a very simple project, just open an issue and I will give the right access. (short term solution)
