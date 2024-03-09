#!/usr/bin/env python
#   commands : functions called by the program
#
from getpass import getpass
from socket import gethostname

# our helpers :
from lib import keys
from lib import files
from lib import config
from lib import ssh
from lib import print

def create(hostname : str, user : str) :
    """
        Create the key pair and store it
    """
    priv, pub = keys.CreateKeyPair(getpass().encode('ascii'))
    keybase = f"{user}@{hostname}"
    files.archive(config.archive,f"{keybase}.pem", priv)
    files.archive(config.archive,f"{keybase}.pub", pub)

def plant(hostname : str, user: str):
    """
        plant the key in authorized keys on the server
    """
    keypath = f"{user}@{hostname}.pub"
    pub = files.extract(config.archive,keypath)
    dest = f"{config.authorized_keys}/{keypath}"
    files.write_file(files.fix_path(dest), pub)
    print(f"[green]Key installed: [/green][b]{dest}[\b]")

def connect(hostname : str, user : str):
    keypath = f"{user}@{hostname}.pem"
    priv = files.extract(config.archive,keypath)
    files.write_file(keypath, priv)
    ssh.try_connect_to(keypath, hostname, user)
    files.delete(keypath)

# TODO :
def install(hostname : str, user : str):
    keypath = f"{user}@{hostname}.priv"
    priv = files.extract(config.archive,keypath)
    dest = f"{config.stored_keys}/{keypath}"
    files.write_file(files.fix_path(dest), priv)
    print(f"[yellow]Private key installed and readable: [/yellow][b]{dest}[\b]")
