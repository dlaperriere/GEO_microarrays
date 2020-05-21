@echo on

rem  Run tests using nose and publish tests results, code coverage and
rem  pylint reports
rem 
rem  adapted from http://www.alexconrad.org/2011/10/jenkins-and-python.html

setlocal 



set WORKSPACE=%cd%
set PYENV_HOME=%WORKSPACE%\.pyenv

rem Delete previously built virtualenv
rmdir /S /Q %PYENV_HOME%\



rem Create virtualenv and install necessary packages

echo "setup virtualenv"
rem virtualenv --no-site-packages %PYENV_HOME%
python -m venv %PYENV_HOME% --upgrade
call %PYENV_HOME%\Scripts\activate.bat
rem pip install --quiet nosexcover
rem pip install --quiet pylint
easy_install nosexcover
easy_install pylint
rem pip install --quiet %WORKSPACE%\  # where your setup.py lives

rem pip install --quiet -r requirements.txt
easy_install Pillow
easy_install openpyxl


rem Run tests 
echo "nosetests"
nosetests --with-xcoverage --with-xunit --cover-erase --cover-tests

echo "pylint"

%PYENV_HOME%\Scripts\pylint.exe -f parseable utils\ test\   1> pylint.out
type pylint.out

rmdir /S /Q DiffExpression
rmdir /S /Q Figures

exit 0
