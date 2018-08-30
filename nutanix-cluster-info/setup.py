#!/usr/bin/env python3.6

from setuptools import setup, find_packages

with open('README.rst', encoding='UTF-8') as f:
    readme = f.read()

setup(
    name='nutanix-cluster-info',
    version='3.0',
    description='Use the Prism Central API to get Nutanix environment info.',
    long_description=readme,
    author='Chris Rasmussen',
    author_email='crasmussen@nutanix.com',
    install_requires=[ 'requests', 'urllib3', 'weasyprint' ],
    packages=find_packages('src'),
    package_dir={'': 'src'}
)