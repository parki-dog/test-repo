@echo off
REM Start of Windows setup
goto :windows

:unix
#!/bin/bash
echo "Running Unix setup..."

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Install a package if not already installed
install_package() {
    local package_name=$1
    echo "Checking for $package_name installation..."
    if ! command_exists "$package_name"; then
        echo "$package_name is not installed. Installing $package_name..."
        if command_exists apt; then
            sudo apt update && sudo apt install -y "$package_name"
        elif command_exists yum; then
            sudo yum install -y "$package_name"
        elif command_exists dnf; then
            sudo dnf install -y "$package_name"
        elif command_exists pacman; then
            sudo pacman -Sy --noconfirm "$package_name"
        elif command_exists brew; then
            brew install curl
        else
            echo "Unsupported package manager. Please install $package_name manually."
            exit 1
        fi
    else
        echo "$package_name is already installed."
    fi
}

# Install Python if not already installed
install_python() {
    echo "Checking for Python installation..."
    if ! command_exists python3; then
        echo "Python is not installed. Installing Python..."
        
        # MacOS Installation
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # Check Homebrew
            if ! command_exists brew; then
                echo "Homebrew is not installed. Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
            fi
            brew install python
        elif command_exists apt; then
            sudo apt update && sudo apt install -y python3 python3-pip
        elif command_exists yum; then
            sudo yum install -y python3
        elif command_exists dnf; then
            sudo dnf install -y python3
        elif command_exists pacman; then
            sudo pacman -Sy --noconfirm python python-pip
        else
            echo "Unsupported package manager. Please install Python manually."
            exit 1
        fi
    else
        echo "Python is already installed."
    fi
}

# Install Poetry
install_poetry() {
    echo "Checking for Poetry installation..."
    if ! command_exists poetry; then
        echo "Poetry is not installed. Installing Poetry..."
        
        if ! command_exists curl; then
            install_package curl
        fi

        curl -sSL https://install.python-poetry.org | python3 -
        export PATH="$HOME/.local/bin:$PATH"
        echo "Poetry installed successfully."
    else
        echo "Poetry is already installed."
    fi
}

# Install Git LFS
install_git_lfs() {
    echo "Checking for Git LFS installation..."
    if ! command_exists git-lfs; then
        echo "Git LFS is not installed. Installing Git LFS..."
        
        if command_exists brew; then
            brew install git-lfs
        elif command_exists apt; then
            curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
            sudo apt install git-lfs
        elif command_exists yum; then
            curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash
            sudo yum install git-lfs
        elif command_exists dnf; then
            curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash
            sudo dnf install git-lfs
        elif command_exists pacman; then
            sudo pacman -Sy --noconfirm git-lfs
        else
            echo "Unsupported package manager. Please install Git LFS manually."
            exit 1
        fi
        # Initialize Git LFS
        git lfs install
        echo "Git LFS installed and initialized successfully."
    else
        echo "Git LFS is already installed."
        # Ensure Git LFS is initialized
        git lfs install
    fi
}

# Set up the project
setup_project() {
    echo "Setting up project dependencies with Poetry..."
    poetry install || { echo "Failed to install dependencies."; exit 1; }
    echo "Dependencies installed."
    echo "Setup complete."
    echo "Activating the virtual environment..."
    poetry shell || { echo "Failed to activate the virtual environment."; exit 1; }
    pre-commit install
}

# Main Unix execution
install_python
install_poetry
# install_git_lfs
setup_project
exit 0

:windows
@echo off
echo "Running Windows setup..."

REM Check if Python is installed, if not, install it and add to PATH
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo "Python is not installed. Attempting to download the Python installer..."

    REM Download the Python installer
    powershell -Command "Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe -OutFile python_installer.exe"
    if exist python_installer.exe (
        echo "Python installer downloaded successfully."
        echo "Please run the installer manually and select 'Add Python to PATH' during installation."

        REM Open the installer for manual installation
        start python_installer.exe

        REM Wait for the user to complete installation and prompt to continue
        pause
        del python_installer.exe

        REM Verify Python installation
        where python >nul 2>&1
        if %errorlevel% neq 0 (
            echo "Python installation failed or could not be found. Exiting."
            exit /b 1
        ) else (
            echo "Python installed successfully and is available in PATH."
        )
    ) else (
        echo "Failed to download the Python installer. Exiting."
        exit /b 1
    )
) else (
    echo "Python is already installed."
)

REM Confirm Python installation by printing the version
python --version
if %errorlevel% neq 0 (
    echo "Python installation verification failed. Exiting."
    exit /b 1
) else (
    echo "Python is installed and recognized in PATH."
)

REM Check for Poetry installation
where poetry >nul 2>&1
if %errorlevel% neq 0 (
    echo "Poetry is not installed. Installing Poetry..."

    REM Check if curl is available
    where curl >nul 2>&1
    if %errorlevel% neq 0 (
        echo "curl is not available. Downloading Poetry installer via PowerShell..."
        powershell -Command "Invoke-WebRequest -Uri https://install.python-poetry.org -OutFile install_poetry.py"
        python install_poetry.py
        del install_poetry.py
    ) else (
        curl -sSL https://install.python-poetry.org | python -
    )
) else (
    echo "Poetry is already installed."
)

IF EXIST %APPDATA%\Python\Scripts SET "PATH=%PATH%;%APPDATA%\Python\Scripts"

REM Confirm Poetry installation
poetry --version
if %errorlevel% neq 0 (
    echo "Poetry installation failed. Exiting."
    exit /b 1
)

REM Check for Git LFS installation
@REM echo "Checking for Git LFS installation..."
@REM where git-lfs >nul 2>&1
@REM if %errorlevel% neq 0 (
@REM     echo "Git LFS is not installed. Installing Git LFS..."

@REM     REM Check if curl is available for Git LFS download
@REM     where curl >nul 2>&1
@REM     if %errorlevel% neq 0 (
@REM         echo "curl is not available. Please install Git LFS manually."
@REM         exit /b 1
@REM     ) else (
@REM         curl -sSL https://github.com/git-lfs/git-lfs/releases/latest/download/git-lfs-windows-amd64.exe -o git-lfs.exe
@REM         git-lfs.exe install
@REM         del git-lfs.exe
@REM         echo "Git LFS installed and initialized successfully."
@REM     )
@REM ) else (
@REM     echo "Git LFS is already installed."
@REM     git lfs install
@REM )

REM Set up the project with Poetry
echo "Setting up project dependencies with Poetry..."
poetry install
if %errorlevel% neq 0 (
    echo "Failed to install dependencies. Exiting."
    exit /b 1
)

echo "Dependencies installed."
echo "Setup complete."

REM Activate the virtual environment
poetry shell

REM Install pre-commit hooks
pre-commit install

exit /b 0
