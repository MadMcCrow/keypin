from cx_Freeze import setup, Executable, Freezer

inc = ['keypin', 'encodings', 'rich', 'bcrypt', 'pexpect', 'cryptography']
exc = ['tkinter', 'unittest']

with open('README.md', 'r') as fh:
    long_description = fh.read()

executables=[Executable('__main__.py')]

# build = setup(
#     name='keypin',
#     version='0.0.1',
#     author='MadMcCrow',
#     #author_email='please@dont',
#     options={'build_exe': {
#         'optimize': 2,
#         'excludes': exc,
#         'zip_include_packages': inc,
#     }},
#     executables=executables,
#     # description
#     description='a SSH key manager',
#     long_description = long_description,
#     long_description_content_type='text/markdown',
#     url='https://github.com/MadMcCrow/keypin',
# )

freezer = Freezer(
        executables = executables,
        #path = ["keypin"],
        target_dir = 'dist',
        compress = False,
        optimize = 0,
        includes = inc,
        excludes = exc,
        zip_include_packages=['keypin']
    )
freezer.freeze()

import PyInstaller.__main__

# this produces a single runnable binary :
PyInstaller.__main__.run([
    '__main__.py',
    '--onefile'
])
