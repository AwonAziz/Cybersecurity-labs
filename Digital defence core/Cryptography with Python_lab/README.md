This lab introduces practical cryptography in Python using the `cryptography` library. You will implement symmetric encryption with AES via Fernet, asymmetric encryption with RSA, compare their performance, and build a hybrid encryption system that combines both methods.

## Objectives
- Implement symmetric encryption using AES
- Create asymmetric encryption using RSA
- Compare symmetric and asymmetric encryption performance
- Apply cryptographic principles to secure data transmission
- Understand and implement hybrid encryption using RSA and AES

## Prerequisites
- Basic Python programming knowledge
- Familiarity with Linux command line
- Understanding of encryption and decryption concepts
- Access to a terminal environment

## Lab Environment
This lab runs on an Al Nafi Linux cloud machine with Python 3 available.

## Tools and Libraries
- Python 3
- pip3
- cryptography library

## Files Created
- `aes_crypto.py`
- `rsa_crypto.py`
- `crypto_compare.py`
- `hybrid_crypto.py`

## Topics Covered
1. AES symmetric encryption
2. RSA asymmetric encryption
3. Digital signatures
4. Performance benchmarking
5. Hybrid encryption

## Expected Outcomes
By the end of this lab, you should be able to:
- Encrypt and decrypt messages using AES
- Generate, save, and load RSA key pairs
- Create and verify digital signatures
- Compare AES and RSA performance
- Implement hybrid encryption for large messages

## Notes
- AES is fast and suitable for large data
- RSA is slower and suitable for small data and key exchange
- Hybrid encryption is the practical real-world approach
- Do not build your own crypto algorithms in production

## Troubleshooting
- Reinstall dependency with `pip3 install --upgrade cryptography`
- Keep RSA plaintext under the practical size limit for 2048-bit keys
- Use correct keys for encryption and decryption
- Check key file permissions if needed using `chmod 600 *.pem *.key`
