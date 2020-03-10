#!/bin/sh

pip install -r .utilities/templates/requirements.txt

python .utilities/templates/templater.py $CI_COMMIT_SHA
