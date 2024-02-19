#!/usr/bin/env python
#
#   files.py : functions to handle files
#
import os
import zipfile

from lib import print

def fix_path(path) :
    return os.path.relpath(os.path.abspath(path))

def make_path(directory, filename) :
    return fix_path(os.path.join(directory, filename))

def delete(path) :
    fpath = fix_path(path)
    try :
        os.remove(fpath)
    except Exception as E:
        if os.path.exists(fpath) :
            print(f"[bold red]Failed to delete[/bold red] {path}")
            raise E

def read_file(path, binary = True) :
    try :
        with open(path, 'rb' if binary else 'rt') as f:
            f.read()
    except Exception as E:
        print(f"[red]failed to read {path}:[/red] {E}")
        raise E

def write_file(path, content, binary = True) :
    try :
        os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
        with open(path, 'wb' if binary else 'wt') as f:
            f.write(content)
    except Exception as E:
        print(f"[red]failed to write {path}:[/red] {E}")
        raise E

def archive(archive_path : str, filename : str, content) :
    """
        create a file in a archive (creating the archive if necessary)
    """
    try:
        abspath = os.path.abspath(archive_path)
        os.makedirs(os.path.dirname(abspath), exist_ok=True)
        with zipfile.ZipFile(abspath, mode='a', compression=zipfile.ZIP_LZMA) as myzip :
            myzip.writestr(filename, content)
    except Exception as E:
        print(f"[red]failed to compress {abspath}[/red]: {E}")
        raise E


def extract(archive_path : str, filename : str, binary = True) :
    """
        create a file in a archive (creating the archive if necessary)
    """
    try:
        content =  b'' if binary else ''
        abspath = os.path.abspath(archive_path)
        with zipfile.ZipFile(abspath, mode='r') as myzip :
             with myzip.open(filename, mode = 'rb' if binary else 'rt') as myfile:
                content = myfile.read()
        return content
    except Exception as E:
        print(f"[red]failed to compress {abspath}[/red]: {E}")
        raise
