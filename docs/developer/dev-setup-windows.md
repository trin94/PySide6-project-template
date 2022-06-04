# Development Setup - Windows

## Tools

1. Install  [python v3.8+](https://www.python.org/downloads/)
1. Install  [git-bash](https://git-scm.com/downloads)
1. Install [chocolatey](https://chocolatey.org/install)
1. Open powershell as admin and run: `choco install make`

**The make build system is supposed to be used from git-bash**

## Checkout

1. Clone this repository
1. Open git-bash in the directory
1. Setup virtual environment:
    1. `python -m venv venv`
    1. `source venv/Scripts/activate`
1. Install requirements `python -m pip install -r requirements.txt`
