#!/bin/bash

# Lab 4: Cryptography with Python

set -e

echo "Updating package lists..."
sudo apt update

echo "Installing pip..."
sudo apt install python3-pip -y

echo "Installing cryptography library..."
pip3 install cryptography

echo "Verifying installation..."
python3 -c "from cryptography.fernet import Fernet; print('Ready')"

echo "Creating working directory..."
mkdir -p ~/crypto_lab
cd ~/crypto_lab

echo "Creating aes_crypto.py..."
cat > aes_crypto.py << 'EOF'
#!/usr/bin/env python3

from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
import base64
import os

class AESCrypto:
    """AES encryption/decryption handler using Fernet"""
    
    def __init__(self):
        self.key = None
        self.cipher = None
    
    def generate_key(self):
        self.key = Fernet.generate_key()
        self.cipher = Fernet(self.key)
        return self.key
    
    def generate_key_from_password(self, password: str, salt: bytes = None):
        if salt is None:
            salt = os.urandom(16)
        
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=100000,
        )
        key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
        self.key = key
        self.cipher = Fernet(self.key)
        return key, salt
    
    def encrypt(self, plaintext: str) -> bytes:
        if self.cipher is None:
            raise ValueError("Cipher not initialized")
        return self.cipher.encrypt(plaintext.encode())
    
    def decrypt(self, ciphertext: bytes) -> str:
        if self.cipher is None:
            raise ValueError("Cipher not initialized")
        return self.cipher.decrypt(ciphertext).decode()
    
    def save_key(self, filename: str):
        if self.key is None:
            raise ValueError("No key to save")
        with open(filename, "wb") as f:
            f.write(self.key)
    
    def load_key(self, filename: str):
        with open(filename, "rb") as f:
            self.key = f.read()
        self.cipher = Fernet(self.key)

def main():
    print("=== AES Encryption Demo ===\n")
    
    aes = AESCrypto()
    key = aes.generate_key()
    print(f"Generated key: {key.decode()}")
    
    message = "This is a secret AES message"
    encrypted = aes.encrypt(message)
    decrypted = aes.decrypt(encrypted)
    
    print(f"Original: {message}")
    print(f"Encrypted: {encrypted}")
    print(f"Decrypted: {decrypted}")
    print(f"Match: {message == decrypted}")
    
    print("\n--- Password-based key derivation ---")
    aes2 = AESCrypto()
    key2, salt = aes2.generate_key_from_password("StrongPassword123!")
    encrypted2 = aes2.encrypt("Password protected message")
    decrypted2 = aes2.decrypt(encrypted2)
    print(f"Salt: {salt.hex()}")
    print(f"Decrypted: {decrypted2}")
    
    print("\n--- Save and load key ---")
    aes.save_key("aes.key")
    aes3 = AESCrypto()
    aes3.load_key("aes.key")
    decrypted3 = aes3.decrypt(encrypted)
    print(f"Loaded key decrypt result: {decrypted3}")
    
    print("\n=== Demo Complete ===")

if __name__ == "__main__":
    main()
EOF

chmod +x aes_crypto.py

echo "Running AES demo..."
python3 aes_crypto.py

echo "Creating rsa_crypto.py..."
cat > rsa_crypto.py << 'EOF'
#!/usr/bin/env python3

from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.backends import default_backend

class RSACrypto:
    """RSA encryption/decryption and digital signatures"""
    
    def __init__(self):
        self.private_key = None
        self.public_key = None
    
    def generate_keypair(self, key_size: int = 2048):
        self.private_key = rsa.generate_private_key(
            public_exponent=65537,
            key_size=key_size,
            backend=default_backend()
        )
        self.public_key = self.private_key.public_key()
    
    def save_keys(self, private_file: str = "private.pem", public_file: str = "public.pem"):
        private_bytes = self.private_key.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.PKCS8,
            encryption_algorithm=serialization.NoEncryption()
        )
        with open(private_file, "wb") as f:
            f.write(private_bytes)
        
        public_bytes = self.public_key.public_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PublicFormat.SubjectPublicKeyInfo
        )
        with open(public_file, "wb") as f:
            f.write(public_bytes)
    
    def load_keys(self, private_file: str = "private.pem", public_file: str = "public.pem"):
        with open(private_file, "rb") as f:
            self.private_key = serialization.load_pem_private_key(
                f.read(), password=None, backend=default_backend()
            )
        with open(public_file, "rb") as f:
            self.public_key = serialization.load_pem_public_key(
                f.read(), backend=default_backend()
            )
    
    def encrypt(self, plaintext: str) -> bytes:
        data = plaintext.encode()
        if len(data) > 190:
            raise ValueError("Message too large for RSA encryption with 2048-bit key")
        return self.public_key.encrypt(
            data,
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA256()),
                algorithm=hashes.SHA256(),
                label=None
            )
        )
    
    def decrypt(self, ciphertext: bytes) -> str:
        decrypted = self.private_key.decrypt(
            ciphertext,
            padding.OAEP(
                mgf=padding.MGF1(algorithm=hashes.SHA256()),
                algorithm=hashes.SHA256(),
                label=None
            )
        )
        return decrypted.decode()
    
    def sign(self, message: str) -> bytes:
        return self.private_key.sign(
            message.encode(),
            padding.PSS(
                mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.MAX_LENGTH
            ),
            hashes.SHA256()
        )
    
    def verify(self, message: str, signature: bytes) -> bool:
        try:
            self.public_key.verify(
                signature,
                message.encode(),
                padding.PSS(
                    mgf=padding.MGF1(hashes.SHA256()),
                    salt_length=padding.PSS.MAX_LENGTH
                ),
                hashes.SHA256()
            )
            return True
        except Exception:
            return False

def main():
    print("=== RSA Encryption Demo ===\n")
    
    rsa_crypto = RSACrypto()
    rsa_crypto.generate_keypair()
    rsa_crypto.save_keys()
    
    message = "Short RSA message"
    encrypted = rsa_crypto.encrypt(message)
    decrypted = rsa_crypto.decrypt(encrypted)
    
    print(f"Original: {message}")
    print(f"Encrypted: {encrypted[:60]}...")
    print(f"Decrypted: {decrypted}")
    print(f"Match: {message == decrypted}")
    
    signature = rsa_crypto.sign(message)
    print(f"Signature valid: {rsa_crypto.verify(message, signature)}")
    print(f"Tampered valid: {rsa_crypto.verify('Tampered message', signature)}")
    
    rsa2 = RSACrypto()
    rsa2.load_keys()
    decrypted2 = rsa2.decrypt(encrypted)
    print(f"Loaded key decrypt result: {decrypted2}")
    
    print("\n=== Demo Complete ===")

if __name__ == "__main__":
    main()
EOF

chmod +x rsa_crypto.py

echo "Running RSA demo..."
python3 rsa_crypto.py

echo "Creating crypto_compare.py..."
cat > crypto_compare.py << 'EOF'
#!/usr/bin/env python3

import time
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

def benchmark_aes():
    key = Fernet.generate_key()
    cipher = Fernet(key)
    message = ("A" * 5000).encode()
    
    start = time.time()
    encrypted = cipher.encrypt(message)
    encrypt_time = time.time() - start
    
    start = time.time()
    cipher.decrypt(encrypted)
    decrypt_time = time.time() - start
    
    return encrypt_time, decrypt_time, len(encrypted)

def benchmark_rsa():
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )
    public_key = private_key.public_key()
    message = b"Short RSA test message"
    
    start = time.time()
    encrypted = public_key.encrypt(
        message,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    encrypt_time = time.time() - start
    
    start = time.time()
    private_key.decrypt(
        encrypted,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    decrypt_time = time.time() - start
    
    return encrypt_time, decrypt_time, len(encrypted)

def compare_methods():
    print("=== Encryption Method Comparison ===\n")
    
    aes_enc, aes_dec, aes_size = benchmark_aes()
    rsa_enc, rsa_dec, rsa_size = benchmark_rsa()
    
    print("AES Results:")
    print(f"  Encrypt time: {aes_enc:.6f} sec")
    print(f"  Decrypt time: {aes_dec:.6f} sec")
    print(f"  Ciphertext size: {aes_size} bytes")
    
    print("\nRSA Results:")
    print(f"  Encrypt time: {rsa_enc:.6f} sec")
    print(f"  Decrypt time: {rsa_dec:.6f} sec")
    print(f"  Ciphertext size: {rsa_size} bytes")
    
    print("\nUse Case Recommendations:")
    print("- Use AES for large data encryption")
    print("- Use RSA for secure key exchange and signatures")
    print("- Use hybrid encryption in real-world secure systems")

if __name__ == "__main__":
    compare_methods()
EOF

chmod +x crypto_compare.py

echo "Running comparison..."
python3 crypto_compare.py

echo "Creating hybrid_crypto.py..."
cat > hybrid_crypto.py << 'EOF'
#!/usr/bin/env python3

from cryptography.fernet import Fernet
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

def hybrid_encrypt(message: str, rsa_public_key):
    aes_key = Fernet.generate_key()
    cipher = Fernet(aes_key)
    encrypted_message = cipher.encrypt(message.encode())
    
    encrypted_aes_key = rsa_public_key.encrypt(
        aes_key,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return encrypted_aes_key, encrypted_message

def hybrid_decrypt(encrypted_aes_key: bytes, encrypted_message: bytes, rsa_private_key) -> str:
    aes_key = rsa_private_key.decrypt(
        encrypted_aes_key,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    cipher = Fernet(aes_key)
    return cipher.decrypt(encrypted_message).decode()

def main():
    print("=== Hybrid Encryption Demo ===\n")
    
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )
    public_key = private_key.public_key()
    
    message = "Hybrid encryption allows secure handling of large messages. " * 30
    
    encrypted_aes_key, encrypted_message = hybrid_encrypt(message, public_key)
    decrypted = hybrid_decrypt(encrypted_aes_key, encrypted_message, private_key)
    
    print(f"Original length: {len(message)}")
    print(f"Encrypted AES key size: {len(encrypted_aes_key)} bytes")
    print(f"Encrypted message size: {len(encrypted_message)} bytes")
    print(f"Decryption successful: {message == decrypted}")
    
    print("\nAdvantages of hybrid encryption:")
    print("- RSA protects the AES key")
    print("- AES efficiently encrypts large data")
    print("- This is the standard model used in secure communications")
    
    print("\n=== Demo Complete ===")

if __name__ == "__main__":
    main()
EOF

chmod +x hybrid_crypto.py

echo "Running hybrid encryption demo..."
python3 hybrid_crypto.py

echo "Setting restrictive permissions on key files..."
chmod 600 *.pem *.key 2>/dev/null || true

echo "Lab 4 completed successfully."
