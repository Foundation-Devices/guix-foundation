# guix-foundation

To extend your `channels.scm` file, adapt accordingly:

```scheme
(append (list (channel
                (name 'foundation)
                (url "https://github.com/Foundation-Devices/guix-foundation")
                (introduction
                  (make-channel-introduction
                    "3a3047c62efa68335f9c371d6de71375e042e5f2"
                    (openpgp-fingerprint
                      "9D54 3ADF 6E90 348C C606  90A9 6279 AEC2 0A95 24EC")))))
        %default-channels)
```
