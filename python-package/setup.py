from setuptools import find_packages, setup

setup(
    name="basedosdados",
    version="0.1",
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        "Click",
    ],
    entry_points="""
        [console_scripts]
        basedosdados=basedosdados.cli.cli:cli
    """,
)
