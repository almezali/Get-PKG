# 📦 Extract Packages Script

## 🌟 Overview
Comprehensive bash script for extracting installed packages from multiple system sources with advanced logging and reporting capabilities.

## ✨ Features
- Multi-source package discovery
- Detailed system-wide package extraction
- Color-coded console output
- Automatic logging
- Unified package listing

## 🔍 How It Works
The script searches and extracts package information from:
- PKGINFO files
- `/usr/share` directory
- `/etc` configuration directories

### Extraction Process
1. Create temporary storage directory
2. Search multiple system paths
3. Collect unique package names
4. Generate comprehensive package list
5. Log all operations

## 🚀 Usage
```bash
chmod +x extract_packages_0.sh
./extract_packages_0.sh
```

## 📂 Outputs
- `~/installed_packages_full.txt`: Complete package list
- `~/pkg_extract.log`: Detailed operation log

## 🛡️ Requirements
- Linux-based system
- Bash
- Root/sudo privileges

## ⚠️ Important Notes
- Requires administrative permissions
- Scanning may take considerable time on large systems
- Recommended for system administrators and package management

## 📄 License
[FREE]

## 👥 Contributing
Contributions are welcome! Please open an issue or submit a pull request.
