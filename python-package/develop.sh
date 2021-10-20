# source this file with
# source python-package/develop.sh

REPO=${PWD##*/}

. .${REPO}/bin/activate
cd python-package
python setup.py develop
cd ..
