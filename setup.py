import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="keypin",
    version="0.0.1",
    author="MadMcCrow",
    #author_email="please@dont",
    description="a SSH key manager",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/MadMcCrow/keypin",
    packages=setuptools.find_packages(),
    install_requires=['cryptography', 'bcrypt', 'pexpect', 'rich'],
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)
