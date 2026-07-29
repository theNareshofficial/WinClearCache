<p align="center">
    <img src="assets/WinCleat-Cache-logo.png" width="300px">
</p>
<h1 align="center">WinClearCache Tool v2.0</h1>

![Version](https://img.shields.io/badge/version-2.0-blue.svg?style=flat-square)
![Windows](https://img.shields.io/badge/Windows-0078D4?style=flat-square&logo=windows&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.6+-3776AB?style=flat-square&logo=python&logoColor=white)
![Status](https://img.shields.io/badge/status-Production%20Ready-brightgreen.svg?style=flat-square)
![Maintenance](https://img.shields.io/badge/maintenance-Active-blue.svg?style=flat-square)

**WinClearCache** is a fast, lightweight, and comprehensive system optimization tool designed to safely purge temporary files, browser caches, system logs, update files, and recycle bin data. 

The primary utility is built natively for Windows as an **Executable (`.exe`)** and **Batch Script (`.bat`)** for instant, dependency-free execution. Additionally, **WinClearCache v2.0** includes a **Python Edition (`WinClearCache.py`)** to extend cross-platform support across **Windows, Linux, and macOS**.

---

## What's New in v2.0 🚀

![Features](https://img.shields.io/badge/Features-Enhanced-brightgreen?style=flat-square)
![Performance](https://img.shields.io/badge/Performance-Optimized-blue?style=flat-square)
![Stability](https://img.shields.io/badge/Stability-Improved-success?style=flat-square)

- **Core Executable & Batch Updates:**
  - Real-time live verbose execution output during scans.
  - Interactive menu with Dry-Run mode to preview file deletions safely.
  - Fixed space-in-username path bugs (e.g., `C:\Users\spidey\...`).
  - Absolute path log directory display upon completion.
  - Enhanced multi-profile browser cache purging.
- **Cross-Platform Python Module Support:**
  - Multi-platform support for **Windows**, **Linux**, and **macOS**.
  - Purges temporary folder contents safely without deleting root system directories.
  - Integrated disk space analysis using `psutil`.

---

## Executables & Downloads ⤵️

![Release](https://img.shields.io/badge/Release-v2.0-blue?style=flat-square)
![Download](https://img.shields.io/badge/Downloads-Multiple%20Formats-brightgreen?style=flat-square)

- **Executable Application:** [Download WinClearCache.exe](https://github.com/theNareshofficial/WinClearCache/blob/main/WinClearCache.exe)
- **Batch Script:** [WinClearCache.bat](https://github.com/theNareshofficial/WinClearCache/blob/main/WinClearCache.bat)
- **Python Script:** [WinClearCache.py](https://github.com/theNareshofficial/WinClearCache/blob/main/WinClearCache.py)

---

## Complete Execution Commands Reference ⚙️

![Reference](https://img.shields.io/badge/Command-Reference-blue?style=flat-square)

> **Important:** Running with Administrator or Root privileges is strongly recommended to clear system-level folders (such as Windows Update cache, Event Logs, or `/var/log`).

### 1. Windows Executable (`WinClearCache.exe`)

* **Standard Interactive Launch (CMD / PowerShell):**
  ```cmd
  WinClearCache.exe
  ```

---

## ✍️ Author

![Author](https://img.shields.io/badge/Author-Naresh%20R-blue?style=flat-square)
![GitHub](https://img.shields.io/badge/GitHub-@theNareshofficial-181717?style=flat-square&logo=github&logoColor=white)
![YouTube](https://img.shields.io/badge/YouTube-@nareshtechweb930-FF0000?style=flat-square&logo=youtube&logoColor=white)
![Location](https://img.shields.io/badge/Location-Bengaluru%2C%20India-green?style=flat-square)

**Naresh R** - Desktop Support Engineer | IT Infrastructure Enthusiast | Content Creator

- **GitHub:** [@theNareshofficial](https://github.com/theNareshofficial)
- **YouTube:** [@nareshtechweb930](https://www.youtube.com/@nareshtechweb930)
- **Location:** Bengaluru, Karnataka, India
- **Philosophy:** Learn → Build → Hack

---

## 🐍 Python Setup with Requirements

![Python](https://img.shields.io/badge/Setup-Simple-brightgreen?style=flat-square)

### Method 1: Using requirements.txt (Recommended)

```bash
# Navigate to project directory
cd WinClearCache

# Install all dependencies from requirements.txt
pip install -r requirements.txt

# Or with Python 3 explicitly
pip3 install -r requirements.txt

# On Linux/macOS with sudo (if needed)
sudo pip3 install -r requirements.txt
```

### Method 2: Manual Installation

```bash
# Install psutil directly
pip install psutil

# Or specific version
pip install psutil==5.9.0
```

### Verify Installation

```bash
# Check if psutil is installed correctly
python -c "import psutil; print('psutil version:', psutil.__version__)"

# Or with Python 3
python3 -c "import psutil; print('psutil version:', psutil.__version__)"
```

### Run WinClearCache After Setup

```bash
# Windows
python WinClearCache.py --full

# Linux/macOS
python3 WinClearCache.py --full

# With verbose output
python WinClearCache.py --full --verbose
```

---

## 🤝 Contributing

![Contribute](https://img.shields.io/badge/Contributions-Welcome-brightgreen?style=flat-square)
![Open Source](https://img.shields.io/badge/Open%20Source-Yes-success?style=flat-square)

We warmly welcome contributions from the community! Whether you're fixing bugs, adding features, improving documentation, or sharing ideas, your contribution matters.

### How to Contribute

1. **Fork the Repository**
   ```bash
   # Click "Fork" on GitHub to create your copy
   ```

2. **Clone Your Fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/WinClearCache.git
   cd WinClearCache
   ```

3. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # Example: feature/add-custom-folder-cleanup
   ```

4. **Make Your Changes**
   - Fix bugs
   - Add new features
   - Improve documentation
   - Optimize code

5. **Test Your Changes**
   ```bash
   # Test with dry-run first
   python WinClearCache.py --dry-run
   
   # Test full functionality
   python WinClearCache.py --full --verbose
   ```

6. **Commit Your Changes**
   ```bash
   git commit -m "Add: meaningful description of your changes"
   # Examples:
   # git commit -m "Add: support for Chrome profile cleanup"
   # git commit -m "Fix: permission denied on system temp files"
   # git commit -m "Improve: documentation clarity"
   ```

7. **Push to Your Branch**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**
   - Go to GitHub and open a Pull Request
   - Describe your changes clearly
   - Link any related issues

### Contribution Guidelines

- **Bug Reports:** Include error messages, OS version, and reproduction steps
- **Feature Requests:** Explain the use case and expected behavior
- **Code Quality:** Keep code clean, readable, and well-commented
- **Testing:** Test your changes on Windows, Linux, and macOS if possible
- **Documentation:** Update README and comments for new features

### Areas for Contribution

- ![Bug Fix](https://img.shields.io/badge/Bug-Fixes-red?style=flat-square) Bug fixes and error handling
- ![Feature](https://img.shields.io/badge/Feature-Requests-blue?style=flat-square) New cleanup targets and features
- ![Docs](https://img.shields.io/badge/Documentation-Improvement-green?style=flat-square) Better documentation and tutorials
- ![Testing](https://img.shields.io/badge/Testing-Help-yellow?style=flat-square) Cross-platform testing and feedback
- ![Localization](https://img.shields.io/badge/Localization-Languages-purple?style=flat-square) International language support

### Questions or Ideas?

- **Open an Issue:** For bugs or feature discussions
- **Start a Discussion:** For questions or ideas
- **Contact:** Reach out on GitHub or YouTube

---

## 🙏 Thank You

![Thank You](https://img.shields.io/badge/Thank%20You-Heart-red?style=flat-square)


**Special thanks to the open source community** for inspiration, guidance, and the amazing tools that make projects like this possible.

Every contribution, no matter how small, makes a difference. Thank you for being part of the WinClearCache journey! 

---

**Happy Cleaning! 🧹**

![Made With Love](https://img.shields.io/badge/Made%20with-❤️-red?style=flat-square)
![Last Updated](https://img.shields.io/badge/Last%20Updated-2026-blue?style=flat-square)

