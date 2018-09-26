#!/usr/bin/env python3.6

from setuptools import setup, find_packages

with open('readme.rst', encoding='UTF-8') as f:
    readme = f.read()

setup(
    name='import_blueprints',
    version='1.0',
    description='Use the Prism Central API to import Calm blueprints from JSON files.',
    long_description=readme,
    author='Chris Rasmussen',
    author_email='crasmussen@nutanix.com',
    install_requires=[ 'argparse', 'urllib3', 'requests', 'pipenv' ],
    packages=find_packages('src'),
    package_dir={'': 'src'}
)
