#!/usr/bin/env python
#   keys : function to generate ssh keys
#

from cryptography.hazmat.primitives import serialization as crypto_serialization
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey as private_key
from cryptography.hazmat.backends import default_backend as crypto_default_backend

def CreateKeyPair(password : bytes):
    """
        Function that returns a new pair of keys in the form of bytes
    """
    # Create OpenSSH ED25519 key (private)
    key = private_key.generate()
    # password handling :
    encryption = crypto_serialization.NoEncryption
    try:
        if len(password) != 0 :
            encryption = crypto_serialization.BestAvailableEncryption(password)
    except:
        print(f"failed to encrypt SSH")
        raise
    # gen Private byte array :
    private_bytes = key.private_bytes(
    crypto_serialization.Encoding.PEM,
    crypto_serialization.PrivateFormat.OpenSSH,
    encryption
    )
    # gen public byte array
    public_bytes = key.public_key().public_bytes(
    crypto_serialization.Encoding.OpenSSH,
    crypto_serialization.PublicFormat.OpenSSH )
    # return pair :
    return  private_bytes, public_bytes
