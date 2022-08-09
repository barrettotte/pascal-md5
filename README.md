# pascal-md5

MD5 hash function in Pascal for no good reason.

I didn't really feel like working on my current hobby projects and a Pascal book on my shelf caught my eye. 
So why not learn a bit of Pascal and how the MD5 hashing function works.

## Test Output

```txt
""
  actual:   0xd41d8cd98f00b204e9800998ecf8427e
  expected: 0xd41d8cd98f00b204e9800998ecf8427e

"a"
  actual:   0x0cc175b9c0f1b6a831c399e269772661
  expected: 0x0cc175b9c0f1b6a831c399e269772661

"abc"
  actual:   0x900150983cd24fb0d6963f7d28e17f72
  expected: 0x900150983cd24fb0d6963f7d28e17f72

"message digest"
  actual:   0xf96b697d7cb7938d525a2f31aaf161d0
  expected: 0xf96b697d7cb7938d525a2f31aaf161d0

"abcdefghijklmnopqrstuvwxyz"
  actual:   0xc3fcd3d76192e4007dfb496cca67e13b
  expected: 0xc3fcd3d76192e4007dfb496cca67e13b

"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  actual:   0xd174ab98d277d9f5a5611c2c9f419d9f
  expected: 0xd174ab98d277d9f5a5611c2c9f419d9f

"12345678901234567890123456789012345678901234567890123456789012345678901234567890"
  actual:   0x57edf4a22be3c955ac49da2e2107b67a
  expected: 0x57edf4a22be3c955ac49da2e2107b67a
```

## Commands

- `make build` - builds binary
- `make run` - builds and runs binary

## Dependencies

Free Pascal 3.2.2+ - `sudo apt-get -y install fpc`

## References

- [Data Structures Using Pascal, 2nd ed. Tenenbaum,Augenstein (9780131966680)](https://isbnsearch.org/isbn/9780131966680)
- [Free Pascal - Download](https://www.freepascal.org/down/i386/linux.html)
- [Free Pascal - Basic Pascal Tutorial](https://wiki.freepascal.org/Basic_Pascal_Tutorial)
- [MD5 Wiki](https://en.wikipedia.org/wiki/MD5#Algorithm)
- [RFC-1321 - The MD5 Message-Digest Algorithm](https://www.rfc-editor.org/rfc/rfc1321.html)
- [VS Code Pascal](https://github.com/alefragnani/vscode-language-pascal)
