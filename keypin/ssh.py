#!/usr/bin/env python
#
#   ssh.py : start an ssh shell
#
import subprocess
import shlex
import os
import textwrap

def _subprocessWindows(command) :
    import wexpect
    child = wexpect.spawn(command)
    child.interact()

def _subprocessUnix(command) :
    import pexpect
    child = pexpect.spawn(command)
    child.interact()

def _subprocess(command) :
    if os.name == "posix" :
        return _subprocessUnix(command)
    elif os.name == "nt" :
        return _subprocessWindows(command)
    else :
        raise SystemError(f"unsupported System {os.name}")

def try_connect_to(key, hostname, username) :
    try:
        command = f"ssh {username}@{hostname} -CX -i {key}"
        print (f"starting : [bold]{shlex.split(command)[0]}[/bold]")
        _subprocess(command)
    except Exception as E:
         print (f"[red]failed to start ssh :[/red] {E}")
         raise
