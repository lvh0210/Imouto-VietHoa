from setuptools import setup, find_namespace_packages

setup(
    name="cli-anything-imouto",
    version="1.0.0",
    description="CLI-Anything harness for Imouto Mobile Unity Android Port & Localization",
    packages=find_namespace_packages(include=["cli_anything.*"]),
    package_data={
        "cli_anything.imouto": ["skills/SKILL.md"],
    },
    install_requires=[
        "click>=8.0",
        "prompt_toolkit>=3.0",
    ],
    entry_points={
        "console_scripts": [
            "cli-anything-imouto = cli_anything.imouto.imouto_cli:main",
            "imouto = cli_anything.imouto.imouto_cli:main",
        ],
    },
)
