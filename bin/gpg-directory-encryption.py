#! /usr/bin/python3

import argparse
import os
import subprocess
import tempfile
from enum import Enum

class Mode(Enum):
    encrypt = 'encrypt'
    decrypt = 'decrypt'

def cli():
    parser = argparse.ArgumentParser(description="Encrypts or decrypts a directory with gpg. Uses tar to make a single file out of a directory.")
    parser.add_argument('mode', type=Mode, choices=list(Mode),
                        help="Choose whether to encrypt or decrypt")
    parser.add_argument('-e', '--encrypted-path',required=True,
                        help="Path to the encrypted file")
    parser.add_argument('-d', '--decrypted-path', required=True,
                        help="Path to the decrypted directory")
    parser.add_argument('-u', '--gpg-user',
                        help="Username that should be able to decrypt the encrypted files")
    args = parser.parse_args()

    if (args.mode == Mode.encrypt):
        if args.gpg_user is None:
            print("Error: Need gpg-user")
            return
        print("Will encrypt files from {} to target file {} for user '{}'.".format(args.decrypted_path, args.encrypted_path, args.gpg_user))
        with tempfile.TemporaryDirectory() as temp_dir:
            compressed_file_name = os.path.join(temp_dir, os.path.basename(args.decrypted_path) + ".tar.gz")
            compress_dir_to_file(args.decrypted_path, compressed_file_name)
            encrypt_file(compressed_file_name, args.gpg_user, args.encrypted_path)
    elif (args.mode == Mode.decrypt):
        print("Will decrypt file at {} to target directory {}".format(args.encrypted_path, args.decrypted_path))
        with tempfile.TemporaryDirectory() as temp_dir:
            file_name = os.path.basename(args.encrypted_path)
            if (os.path.splitext(file_name)[-1] == ".gpg"):
                file_name = os.path.splitext(file_name)[0]
            compressed_file_name = os.path.join(temp_dir, file_name)
            decrypt_file(args.encrypted_path, compressed_file_name)
            decompress_file(compressed_file_name, args.decrypted_path)
    else:
        print("Unknown mode")

"""
Encrypts the given file such that it can be decrypted by the recipient, using gpg.
The encrypted contents are written to output_file
"""
def encrypt_file(file_to_encrypt, recipient_name, output_file):
    print("Encrypting file {} to {} for user {}.".format(file_to_encrypt, output_file, recipient_name))
    subprocess.call(["gpg", "--output", output_file, "-e", "-r", recipient_name, file_to_encrypt])

"""
Decrypts the given file and writes the decrypted contents to output_file
"""
def decrypt_file(file_to_decrypt, output_file):
    print("Decrypting file {} to {}.".format(file_to_decrypt, output_file))
    subprocess.call(["gpg", "--output", output_file, "-d", file_to_decrypt])

"""
Compresses the filesystem tree at directory_to_compress_path to a single file at compressed_file_path
"""
def compress_dir_to_file(directory_to_compress_path, compressed_file_path):
    print("Compressing direcotry {} to {}".format(directory_to_compress_path, compressed_file_path))
    subprocess.call(["tar", "czf", compressed_file_path, directory_to_compress_path])

"""
Decompress the (.tar.gz) file at compressed_file_path to uncompressed_directory_path.
"""
def decompress_file(compressed_file_path, uncompressed_directory_path):
    print("Decompressing contents of file {} to {}".format(compressed_file_path, uncompressed_directory_path))
    subprocess.call(["tar", "xzf", compressed_file_path, uncompressed_directory_path])

if __name__ == "__main__":
    cli()
