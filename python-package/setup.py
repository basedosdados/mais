"""
Setup script for the package.
"""

from setuptools import setup, find_packages

setup(
    name="basedosdados",
    version="2.0.0-beta.8",
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        "click==8.0.3",
    ],
    entry_points="""
        [console_scripts]
        basedosdados=basedosdados.cli.cli:cli
    """,
)
