#!/usr/bin/env python3
"""
WinClearCache Tool v2.0 - Advanced Cross-Platform Edition
Author: Naresh R (@theNareshofficial)
GitHub: https://github.com/theNareshofficial
Website: http://thenareshofficial.free.nf/

Features:
- Full cross-platform support (Windows, Linux, macOS)
- Menu-driven and CLI interface
- Dry-run mode (safe testing)
- Comprehensive logging and terminal colors
- Safe directory content purging (keeps root directory intact)
- System health analysis using psutil
"""

import os
import sys
import shutil
import logging
import argparse
import platform
import getpass
import socket
import subprocess
from pathlib import Path
from datetime import datetime
from enum import Enum
from typing import List, Dict

try:
    import psutil
    PSUTIL_AVAILABLE = True
except ImportError:
    PSUTIL_AVAILABLE = False


class Colors:
    """ANSI color codes with Windows terminal support handling"""
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'


class CleanupCategory(Enum):
    """Cleanup categories"""
    TEMP_FILES = 1
    WINDOWS_UPDATE = 2
    PREFETCH = 3
    RECYCLE_BIN = 4
    CHROME = 5
    FIREFOX = 6
    EDGE = 7
    OPERA = 8
    SAFARI = 9
    IE = 10
    EVENT_LOGS = 11
    THUMBNAILS = 12
    RESTORE_POINTS = 13


class WinClearCache:
    """Main cleanup utility class with cross-platform engines"""
    
    VERSION = "2.0 Cross-Platform Edition"
    AUTHOR = "Naresh R (@theNareshofficial)"
    
    def __init__(self, dry_run: bool = True, verbose: bool = False, save_logs: bool = True):
        self.dry_run = dry_run
        self.verbose = verbose
        self.save_logs = save_logs
        self.items_deleted = 0
        self.size_freed = 0.0  # in MB
        self.errors = []
        self.start_time = datetime.now()
        self.os_type = platform.system()
        
        # Enable ANSI colors on Windows terminals
        if self.os_type == "Windows":
            os.system("")

        # Cross-platform log directory setup
        if self.os_type == "Windows":
            self.log_dir = Path.home() / "AppData" / "Local" / "WinClearCache" / "Logs"
        elif self.os_type == "Darwin":
            self.log_dir = Path.home() / "Library" / "Logs" / "WinClearCache"
        else:
            self.log_dir = Path.home() / ".cache" / "winclearcache" / "logs"
            
        self.log_dir.mkdir(parents=True, exist_ok=True)
        self.log_file = self.log_dir / f"WinClearCache_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"
        self.setup_logging()

    def setup_logging(self):
        """Configure cross-platform logger"""
        log_format = '%(asctime)s - %(levelname)s - %(message)s'
        
        handlers = [logging.StreamHandler(sys.stdout)]
        if self.save_logs:
            handlers.append(logging.FileHandler(self.log_file, encoding='utf-8'))
            
        logging.basicConfig(level=logging.INFO, format=log_format, handlers=handlers, force=True)
        self.logger = logging.getLogger(__name__)
        
        username = getpass.getuser()
        hostname = socket.gethostname()
        
        self.log(f"{'='*60}")
        self.log(f"WinClearCache Tool v{self.VERSION}")
        self.log(f"OS: {self.os_type} ({platform.release()}) | User: {username} | Host: {hostname}")
        self.log(f"Dry-Run: {self.dry_run} | Verbose: {self.verbose}")
        self.log(f"{'='*60}")

    def log(self, message: str, level: str = "INFO"):
        """Log message with formatting"""
        if level == "INFO":
            self.logger.info(message)
        elif level == "WARNING":
            self.logger.warning(f"{Colors.WARNING}[WARNING] {message}{Colors.ENDC}")
        elif level == "ERROR":
            self.logger.error(f"{Colors.FAIL}[ERROR] {message}{Colors.ENDC}")
        elif level == "SUCCESS":
            self.logger.info(f"{Colors.OKGREEN}[SUCCESS] {message}{Colors.ENDC}")

    def is_admin(self) -> bool:
        """Cross-platform check for admin/root privileges"""
        try:
            if self.os_type == "Windows":
                import ctypes
                return ctypes.windll.shell.IsUserAnAdmin() != 0
            else:
                return os.geteuid() == 0
        except Exception:
            return False

    def display_header(self, title: str):
        print(f"\n{Colors.OKBLUE}{Colors.BOLD}" + "="*70)
        print(f"  {title}")
        print("="*70 + f"{Colors.ENDC}\n")

    def get_path_size(self, path: Path) -> int:
        """Calculate file or directory size securely avoiding broken symlinks"""
        try:
            if not path.exists():
                return 0
            if path.is_file() or path.is_symlink():
                return path.stat().st_size
            
            total = 0
            for entry in path.rglob('*'):
                try:
                    if entry.is_file() and not entry.is_symlink():
                        total += entry.stat().st_size
                except (PermissionError, FileNotFoundError):
                    continue
            return total
        except Exception:
            return 0

    def purge_directory_contents(self, path_str: str) -> bool:
        """Deletes directory contents while preserving the root folder itself"""
        target_path = Path(os.path.expandvars(os.path.expanduser(path_str)))
        if not target_path.exists() or not target_path.is_dir():
            return False

        self.log(f"[+] Purging contents of: {target_path}")
        success = True

        for item in target_path.iterdir():
            size_mb = self.get_path_size(item) / (1024 * 1024)
            if self.dry_run:
                self.log(f"  [DRY-RUN] Would delete: {item} ({size_mb:.2f} MB)")
                continue

            try:
                if item.is_file() or item.is_symlink():
                    item.unlink()
                elif item.is_dir():
                    shutil.rmtree(item, ignore_errors=True)
                
                self.items_deleted += 1
                self.size_freed += size_mb
                self.log(f"  [OK] Deleted: {item}")
            except Exception as e:
                err = f"Failed deleting {item}: {e}"
                self.log(err, "ERROR")
                self.errors.append(err)
                success = False

        return success

    # ====================================================================
    # Cross-Platform Cleanup Handlers
    # ====================================================================

    def clean_temp_files(self):
        """Clean temporary folders across OS architectures"""
        self.log("[+] Cleaning temporary files...")
        temp_paths = []
        
        if self.os_type == "Windows":
            temp_paths = ["%TEMP%", "%SystemRoot%\\Temp", "%USERPROFILE%\\AppData\\Local\\Temp"]
        elif self.os_type == "Darwin":
            temp_paths = ["~/Library/Caches", "/tmp", "/var/tmp"]
        else:  # Linux
            temp_paths = ["/tmp", "/var/tmp", "~/.cache"]

        for path in temp_paths:
            self.purge_directory_contents(path)

    def clean_windows_update(self):
        """Clean Windows Update (Windows Only)"""
        if self.os_type != "Windows":
            self.log("[SKIPPED] Windows Update cache is only applicable to Windows.", "WARNING")
            return
        self.purge_directory_contents("%SystemRoot%\\SoftwareDistribution\\Download")

    def clean_prefetch(self):
        """Clean Prefetch (Windows Only)"""
        if self.os_type != "Windows":
            self.log("[SKIPPED] Prefetch is only applicable to Windows.", "WARNING")
            return
        self.purge_directory_contents("%SystemRoot%\\Prefetch")

    def clean_recycle_bin(self):
        """Clean Trash / Recycle Bin cross-platform"""
        self.log("[+] Cleaning Trash / Recycle Bin...")
        if self.dry_run:
            self.log("  [DRY-RUN] Would empty Trash / Recycle Bin")
            return

        try:
            if self.os_type == "Windows":
                subprocess.run(["powershell", "-Command", "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"], capture_output=True)
            elif self.os_type == "Darwin":
                self.purge_directory_contents("~/.Trash")
            else:
                self.purge_directory_contents("~/.local/share/Trash")
            self.log("  [OK] Recycle Bin/Trash emptied")
            self.items_deleted += 1
        except Exception as e:
            self.log(f"Error emptying Recycle Bin: {e}", "ERROR")

    def clean_chrome(self):
        """Clean Chrome cache across platforms"""
        paths = []
        if self.os_type == "Windows":
            paths = ["%LOCALAPPDATA%\\Google\\Chrome\\User Data\\Default\\Cache", "%LOCALAPPDATA%\\Google\\Chrome\\User Data\\Default\\Code Cache"]
        elif self.os_type == "Darwin":
            paths = ["~/Library/Caches/Google/Chrome/Default/Cache"]
        else:
            paths = ["~/.cache/google-chrome/Default/Cache"]

        for path in paths:
            self.purge_directory_contents(path)

    def clean_firefox(self):
        """Clean Firefox cache across platforms"""
        if self.os_type == "Windows":
            base_dir = Path.home() / "AppData" / "Local" / "Mozilla" / "Firefox" / "Profiles"
        elif self.os_type == "Darwin":
            base_dir = Path.home() / "Library" / "Caches" / "Firefox" / "Profiles"
        else:
            base_dir = Path.home() / ".cache" / "mozilla" / "firefox"

        if base_dir.exists():
            for profile in base_dir.iterdir():
                if profile.is_dir():
                    self.purge_directory_contents(str(profile / "cache2"))

    def clean_edge(self):
        """Clean Edge cache across platforms"""
        paths = []
        if self.os_type == "Windows":
            paths = ["%LOCALAPPDATA%\\Microsoft\\Edge\\User Data\\Default\\Cache"]
        elif self.os_type == "Darwin":
            paths = ["~/Library/Caches/Microsoft Edge/Default/Cache"]
        else:
            paths = ["~/.cache/microsoft-edge/Default/Cache"]

        for path in paths:
            self.purge_directory_contents(path)

    def clean_event_logs(self):
        """Clean event/system logs cross-platform"""
        self.log("[+] Cleaning system logs...")
        if self.os_type == "Windows":
            if self.dry_run:
                self.log("  [DRY-RUN] Would clear Windows Event Logs")
            else:
                for log_name in ["Application", "System", "Security", "Setup"]:
                    subprocess.run(["wevtutil", "cl", log_name], capture_output=True)
                self.log("  [OK] Windows Event Logs cleared")
        elif self.os_type == "Linux":
            self.purge_directory_contents("/var/log")
        elif self.os_type == "Darwin":
            self.purge_directory_contents("~/Library/Logs")

    def cleanup_full(self):
        self.clean_temp_files()
        self.clean_windows_update()
        self.clean_prefetch()
        self.clean_recycle_bin()
        self.clean_chrome()
        self.clean_firefox()
        self.clean_edge()
        self.clean_event_logs()

    def print_summary(self):
        exec_time = (datetime.now() - self.start_time).total_seconds()
        self.display_header("CLEANUP SUMMARY")
        if self.dry_run:
            print(f"{Colors.WARNING}[DRY-RUN MODE] No files were actually deleted{Colors.ENDC}\n")
        print(f"Items deleted     : {self.items_deleted}")
        print(f"Space freed       : {self.size_freed:.2f} MB")
        print(f"Errors encountered: {len(self.errors)}")
        print(f"Execution time    : {exec_time:.2f} seconds")
        if self.save_logs:
            print(f"Log location      : {self.log_file}")

    def system_analysis(self):
        self.display_header("SYSTEM ANALYSIS")
        print(f"Operating System: {self.os_type} ({platform.version()})")
        
        if PSUTIL_AVAILABLE:
            disk = psutil.disk_usage('/')
            print("\nDisk Usage ('/'):")
            print(f"  Total: {disk.total / (1024**3):.2f} GB")
            print(f"  Used : {disk.used / (1024**3):.2f} GB")
            print(f"  Free : {disk.free / (1024**3):.2f} GB ({100 - disk.percent}%)")
        else:
            print("\n[NOTE] Install 'psutil' to view drive disk breakdown.")


def main():
    parser = argparse.ArgumentParser(description="WinClearCache Tool v2.0 - Advanced Cross-Platform Edition")
    parser.add_argument("--mode", choices=["full", "quick", "browsers", "analysis"], default="interactive")
    parser.add_argument("--dry-run", action="store_true", help="Simulate execution without deleting files")
    parser.add_argument("--no-logs", action="store_true", help="Disable log writing")
    parser.add_argument("--verbose", "-v", action="store_true", help="Verbose mode")
    args = parser.parse_args()

    cleaner = WinClearCache(dry_run=args.dry_run, verbose=args.verbose, save_logs=not args.no_logs)

    if not cleaner.is_admin():
        print(f"{Colors.FAIL}[WARNING] Running without Administrator/Root privileges. System targets may fail.{Colors.ENDC}\n")

    if args.mode == "full":
        cleaner.cleanup_full()
        cleaner.print_summary()
    elif args.mode == "analysis":
        cleaner.system_analysis()
    else:
        cleaner.display_header("WinClearCache Tool v2.0")
        print("1. Full Cleanup")
        print("2. System Analysis")
        print("3. Exit")
        choice = input("\nEnter choice (1-3): ").strip()
        if choice == "1":
            cleaner.cleanup_full()
            cleaner.print_summary()
        elif choice == "2":
            cleaner.system_analysis()


if __name__ == "__main__":
    main()