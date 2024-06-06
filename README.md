<h1 align="center"> WinClearCache Tool </h1>

WinClearCache is a comprehensive Windows cleaning tool designed to remove temporary files, cache files, and various other types of unnecessary data to free up disk space and enhance system performance. This tool runs as a batch script and performs various cleaning tasks, ensuring a clutter-free and optimized Windows environment.

## Features

- Deletes Windows temporary files
- Clears Windows Update cache
- Cleans Windows Prefetch files
- Removes Internet Explorer temporary files
- Clears browser caches for Chrome, Firefox, Edge, Opera, and Safari
- Deletes Windows Event Logs
- Clears Windows Thumbnail cache
- Deletes all System Restore points

## Usage

1. **Run as Administrator**: Ensure WinClearCache is executed with administrative privileges for full functionality.
2. **Execution**: Execute the script by running it from the command line or double-clicking on it.
3. **Review Output**: After execution, review the output messages to verify the actions performed by WinClearCache.


### Deleting Windows Temporary Files

The script deletes temporary files from the following directories:

- `%TEMP%` - User-specific temporary files
- `%SystemRoot%\Temp` - System-wide temporary files
- `%USERPROFILE%\AppData\Local\Temp` - Additional user-specific temporary files

### Cleaning Windows Update Cache

The script removes cached files related to Windows updates from:

- `%SystemRoot%\SoftwareDistribution\Download`

### Cleaning Windows Prefetch Files

The script deletes prefetch files to free up space and potentially improve boot times:

- `%SystemRoot%\Prefetch`

### Clearing Internet Explorer Temporary Files

The script uses the `RunDll32` command to clear all Internet Explorer temporary files:

- Command: `RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255`

### Cleaning Browser Caches

The script targets cache directories for several popular browsers:

- **Chrome**:
  - `%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache`
  - `%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache`
  - `%LOCALAPPDATA%\Google\Chrome\User Data\Default\GPUCache`

- **Firefox**:
  - `%APPDATA%\Mozilla\Firefox\Profiles\*\cache2`
  - `%APPDATA%\Mozilla\Firefox\Profiles\*\startupCache`

- **Edge**:
  - `%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache`
  - `%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache`
  - `%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\GPUCache`

- **Opera**:
  - `%APPDATA%\Opera Software\Opera Stable\Cache`
  - `%APPDATA%\Opera Software\Opera Stable\GPUCache`

- **Safari**:
  - `%APPDATA%\Apple Computer\Safari\Cache`
  - `%APPDATA%\Apple Computer\Safari\Webpage Previews`

### Clearing Windows Event Logs

The script uses `wevtutil` to clear all Windows Event Logs, freeing up space used by log files:

- Command: `wevtutil el` (list all event logs)
- Command: `wevtutil cl "logname"` (clear each event log)

### Deleting Windows Thumbnail Cache

The script deletes thumbnail cache files to free up disk space:

- `%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db`

### Deleting System Restore Points

The script removes all system restore points to free up disk space and prevent unnecessary backups:

- Command: `vssadmin delete shadows /for=%SystemDrive% /all /quiet`


## Notes

- Running this script will permanently delete files and cannot be undone. Ensure you do not need the files before running the script.
- The script may not delete files that are in use by other applications. Close any running applications to allow the script to clean effectively.
- This tool is intended for advanced users who understand the implications of deleting system and temporary files.



## Author

- **Name**: Naresh
- **GitHub**: [theNareshofficial](https://github.com/theNareshofficial)
- **Website**: [thenareshofficial.free.nf](http://thenareshofficial.free.nf/)

## Contributing

Please feel free to submit issues or pull requests to improve the functionality and efficiency of this script.

## Acknowledgements

This tool was developed to provide a convenient way to clean up Windows systems, improving performance and freeing up valuable disk space.

