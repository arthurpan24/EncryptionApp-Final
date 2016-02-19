# EncryptionApp-Final
Coding Challenge for Pro Core

This app is a game where users can encrypt their messages using RSA Encryption.
More information about RSA Encrypion can be found here: https://en.wikipedia.org/wiki/RSA_(cryptosystem)#Operation

The user can plug in a message that will be encrypted into a string of numbers.
The user can also plug in an encoded message, along with the necessary keys, to decode the message.

In the future, I hope to implement networking so that users can share their encrypted messages across different devices.

Notes:
I used JKBigInteger to handle some of the operations of RSA Encryption, where certain numbers exceeded the size of unsigned long long.
I generated the prime numbers with the Sieve of Eratosthenes. Users can choose to change the range of the prime numbers through the initializer in AppDelegate.m.

Please email arthurpan24@gmail.com if there are any questions about the code.
