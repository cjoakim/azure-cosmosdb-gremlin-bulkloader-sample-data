
# Recreate the python virtual environment and reinstall libs on Windows.
# Chris Joakim, Microsoft, May 2021

# Use, in a PowerShell window:
# > .\venv.ps1
echo 'upgrading pip ...'
python -m pip install --upgrade pip

echo 'creating new venv ...'
python -m venv .

echo 'activating new venv ...'
.\Scripts\Activate.ps1
python --version
pip --version

# rm .\requirements.txt

# echo 'pip-compile requirements.in ...'
# pip-compile --output-file .\requirements.txt .\requirements.in

echo 'pip install requirements.txt ...'
pip install -r .\requirements.txt

echo 'pip list ...'
pip list

echo 'done'
