#!/usr/bin/env python
#
#   setup : command to build as a package
#
from setuptools import setup
from os import name as osname

# name of the app
name = 'keypin'

# external module requirement
requirements = ['cryptography', 'bcrypt', 'rich']
if osname == "posix" :
    requirements.append('pexpect')
elif osname == "nt" :
    requirements.append('wexpect')
else :
    raise SystemError(f"Unsupported system {osname}")

# call setup function
setup(
   name=name,
   version='0.1',
   description='Simple SSH key manager',
   author='mad_mc_crow',
   packages=['keypin' '/lib'], # folders
   install_requires= requirements
)
