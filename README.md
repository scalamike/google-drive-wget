## google-drive-wget

google-drive-wget is a lightweight Bash script that allows you to download files from Google Drive using wget, including files that trigger Google’s confirmation page (large files, virus scan warnings, or permission checks).

The script:
- Accepts a shared Google Drive URL
- Automatically extracts the file ID
- Handles Google Drive confirmation tokens
- Downloads the file using wget
- Detects permission or login issues and exits safely

---

## Installation

```
wget -O gdwget.sh https://raw.githubusercontent.com/scalamike/google-drive-wget/refs/heads/main/gdwget.sh
chmod +x gdwget.sh
```

## Usage
```
./gdwget.sh "https://drive.google.com/file/d/FILE_ID/view?usp=sharing"
```
