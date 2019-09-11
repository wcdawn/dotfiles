#!/usr/bin/python
import pip
from subprocess import call

packages = [dist.project_name for dist in pip.get_installed_distributions()]
call("pip install --upgrade " + ' '.join(packages), shell=True)

# for pip >= 10.0.1
#### import pkg_resources
#### from subprocess import call
#### 
#### packages = [dist.project_name for dist in pkg_resources.working_set]
#### call("pip install --upgrade " + ' '.join(packages), shell=True)
