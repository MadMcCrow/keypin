#!/usr/bin/env python
#
#   encrypt.py : encrypt and decrypt content based on keys
#
from cryptography.fernet import Fernet
from hashlib import sha256
import codecs
import os

def encrypt(content, key) :
    """
        encrypt readable content
    """
    fernet = Fernet(key)
    return fernet.encrypt(content)

def decrypt(encrypted, key) :
    """
        decrypt previously encrypted content
    """
    fernet = Fernet(key)
    return fernet.decrypt(encrypted)

def encryptFile(path, key) :
    """
        rewrite a file as encrypted
    """
    try :
        newpath = f"{path}.clear"
        os.rename(path, newpath)
        with open(newpath, mode='r') as f :
            content = f.read()
        with open (path, mode='w') as g:
            g.write(encrypt(content, key))
    except:
        if os.path.exists(newpath):
            os.rename(newpath, path)
        print(f"Error: failed to encrypt {path}")
        raise
    else :
        os.remove(f"{path.clear}")

def decryptFile(path, key) :
    """
        rewrite a file as decrypted
    """
    try :
        newpath = f"{path}.encrypted"
        os.rename(path, newpath)
        with open(newpath, mode='r') as f :
            content = f.read()
        with open (path, mode='w') as g:
            g.write(decrypt(content, key))
    except:
        if os.path.exists(newpath):
            os.rename(newpath, path)
        print(f"Error: failed to encrypt {path}")
        raise
    else :
        os.remove(newpath)

def hash(text : str) :
    """
        create a unique base64 hash from string
    """
    hexkey = sha256(text.encode('ascii')).hexdigest()
    b64key = codecs.encode(codecs.decode(hexkey, 'hex'), 'base64').decode()
    return b64key.replace('\n', '')
