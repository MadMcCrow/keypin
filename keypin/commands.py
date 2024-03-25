#!/usr/bin/env python
#   commands : functions called by the program
#
from getpass import getpass
from socket import gethostname

# our helpers :
from keypin import keys
from keypin import files
from keypin import config
from keypin import ssh
from keypin import encrypt

def create(hostname : str, user : str) :
    """
        Create the key pair and store it
    """
    priv, pub = keys.CreateKeyPair(getpass().encode('ascii'))
    keybase = f"{user}@{hostname}"
    encrypt_key = encrypt.hash(user)
    archive_path = files.fix_path(f"{config.store}/{encrypt_key}")
    files.archive(archive_path,f"{keybase}.pem", priv)
    files.archive(archive_path,f"{keybase}.pub", pub)
    encrypt.encryptFile(archive_path, encrypt_key)
    print(f"[green]Key created for: [/green][b]{keybase}[\b]")

def plant(hostname : str, user: str):
    """
        plant the key in authorized keys on the server
    """
    encrypt_key = encrypt.hash(user)
    keypath = f"{user}@{hostname}.pub"
    archive_path = files.fix_path(f"{config.store}/{encrypt.hash(user)}")
    # decrypt and read archive
    encrypt.decryptFile(archive_path, encrypt_key)
    pub = files.extract(archive_path,keypath)
    encrypt.encryptFile(archive_path, encrypt_key)
    # write to the machine
    dest = f"{config.authorized_keys}/{keypath}"
    files.write_file(files.fix_path(dest), pub)
    print(f"[green]Key installed: [/green][b]{dest}[\b]")

def connect(hostname : str, user : str):
    encrypt_key = encrypt.hash(user)
    keypath = f"{user}@{hostname}.pem"
    archive_path = files.fix_path(f"{config.store}/{encrypt.hash(user)}")
    dest = files.fix_path(f"{config.store}/{keypath}")
    # read private key
    encrypt.decryptFile(archive_path, encrypt_key)
    priv = files.extract(archive_path,keypath)
    encrypt.encryptFile(archive_path, encrypt_key)
    # write temporary file
    files.write_file(dest, priv, binary=True, permission=0o600)
    # launch ssh shell
    ssh.try_connect_to(dest, hostname, user)
    files.delete(dest)

# TODO :
def install(hostname : str, user : str):
    keypath = f"{user}@{hostname}.priv"
    priv = files.extract(config.store,keypath)
    dest = f"{config.stored_keys}/{keypath}"
    files.write_file(files.fix_path(dest), priv)
    print(f"[yellow]Private key installed and readable: [/yellow][b]{dest}[\b]")
