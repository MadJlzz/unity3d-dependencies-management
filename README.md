# Repository Archived

This repository has been archived. It means that I won't continue to update nor fix bugs.
It has been really usefull back in time when Unity didn't had a way to handle packages for creating easily libraries for our games.

For more informations around Unity's package manager, the documentation is available [here](https://docs.unity3d.com/Manual/upm-ui.html).

# Unity3D dependencies management

`./manageDependencies.sh` is a simple Nuget wrapper script wrote in shell that allow to retrieve dependencies without using Visual Studio.

It was designed by the Seabirds Games team in order to facilitate dependencies management.

## Requirements

* Nuget v3.4.3+ ;
* Sonatype Nexus server (or any other repository manager that support Nugets packages).

**Notes:**
> * For Windows, you will need the Git bash emulated terminal to launch the script ;
>   - The script was tested with [Git for Windows 2.5.0.windows.1](https://git-scm.com/downloads).
> * For Mac OS X, you will need to install Mono to be able to execute `.exe` files.
>   - The script was tested with [Mono 4.2 SR2 (4.2.3.4)](http://www.mono-project.com/download/#download-mac) ;
>   - :warning: Mono is packaged with a version of Nuget deprecated for this script. You'll need to update the Nuget binary to use this script.

## Installation

### Windows

* Add `nuget.exe` to the PATH to allow the wrapper call `nuget.exe` easily.
* Add `NEXUS_SOURCE_NAME` and `NEXUS_SOURCE_URL` to your `~./bash_profile` to skip `-n` && `-s` options. (See below)

### Mac OS X

* Download one of the last version of Nuget (v3.4.3+)
* Go to `/Library/Frameworks/Mono.framework/[...]/NuGet.exe` and replace it with the last version of Nuget you've downloaded (I suggest to rename the old file).


**Notes**
> * Be sure to name nuget.exe as the old file : `NuGet.exe`. Otherwise you will have to go to `/usr/local/bin/`and edit `mono` to tell him where is the new `nuget.exe` to launch with mono.

## Usage

```bash
./manageDependencies -a <ARTIFACT_ID> -v <ARTIFACT_VERSION> -n <NEXUS_SOURCE_NAME> -s <NEXUS_SOURCE_URL>
```

## References

If you have no repository manager, there is a **simple way** to get one **for free** and in a small amount of time. Please refer to this blog post to get one : 
  * [Chris Jenx Sonatype Nexus on Amazon EC2](http://chrisjenx.com/sonatype-nexus-aws-ec2/).

Other usefull references :
  * [Nuget command line reference](https://docs.nuget.org/consume/command-line-reference) ;
  * [Nuget package explorer to create nuget package with a GUI](https://docs.nuget.org/create/using-a-gui-to-build-packages).

## License

This project license is under GNU GPL 3. Please be aware that Unity's generated files are only here for tests purpose after using `manageDependencies.sh`

## Contribute

If you find a bug in the source code or a mistake in the documentation, you can help us improve by submitting an **issue** to our [GitHub Repository](https://github.com/MadJlzz/unity3d-dependencies-management/issues). 
Even better you can submit a **Pull Request** with a fix. Your custom changes can be crafted in a repository fork and submitted to the [GitHub Repository](https://github.com/MadJlzz/unity3d-dependencies-management/pulls) as a Pull Request.
