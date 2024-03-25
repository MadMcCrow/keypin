from cx_Freeze import setup, Executable

# Les dépendances sont automatiquement détectées, mais il peut être nécessaire de les ajuster.
build_exe_options = {
    "excludes": ["tkinter", "unittest"],
    "zip_include_packages": ["keypin", "encodings", "rich", "bcrypt", "pexpect", "pyopenssl", "types-pyopenssl", "cryptography"],
}

with open("README.md", "r") as fh:
    long_description = fh.read()

setup(
    name="keypin",
    version="0.0.1",
    author="MadMcCrow",
    #author_email="please@dont",
    options={"build_exe": build_exe_options},
    executables=[Executable("__main__.py")],
    # description
    description="a SSH key manager",
    long_description = long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/MadMcCrow/keypin",
)
