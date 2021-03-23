# 1.3.0
* Fixed outdated payload names in usage examples displayed to user in help text.
* Merged c_binary, c_binary_b64, c_binary_hex, c_binary_gzip, c_binary_gzip_b64 and c_binary_gzip_hex into a single payload called c_binary.
* Merged rust_binary, rust_binary_b64, rust_binary_hex, rust_binary_gzip, rust_binary_gzip_b64 and rust_binary_gzip_hex into a single payload called rust_binary.
* Merged java_class_binary, java_class_b64 and java_class_gzip_b64 into a single payload called java_class.
* Added --b64, --hex, --gzip, --gzip_b64 and --gzip_hex command-line arguments. These command-line arguments can be used with the c_binary, rust_binary and java_class payloads to compress and/or encode the output. The names are self-explanatory; --b64 will encode the original binary payload using base-64, --hex will use hexadecimal encoding, --gzip will compress the binary using zlib, --gzip_b64 will compress the binary using zlib and encode the result in base-64, and --gzip_hex will compress the binary using zlib and output the result in hexadecimal form.
* Added entries for c_binary_b64, c_binary_hex, c_binary_gzip, c_binary_gzip_b64, c_binary_gzip_hex, rust_binary_b64, rust_binary_hex, rust_binary_gzip, rust_binary_gzip_b64, rust_binary_gzip_hex, java_class_binary, java_class_b64 and java_class_gzip_b64 to PAYLOAD_BC_DICT to preserve backwards compatibility with versions < 1.3.0.
* Fixed the --no-new-line command-line argument. It was not working in versions < 1.3.0.

# 1.2.1
* Fixed incorrect version number that was displayed to user in 1.2.0.

# 1.2.0
* Added the following payloads:
	* rust_binary
	* rust_binary_gzip
	* rust_binary_b64
	* rust_binary_gzip_b64
	* rust_binary_hex
	* rust_binary_gzip_hex

# 1.1.1
* Fixed an error in the copyright notice displayed to the user by versions 1.0.0 and 1.1.0.

# 1.1.0
* Implemented aliases for commands that were removed in version 1.0.0. As a result, LAZYPARIAH 1.1.0 should now be backwards compatible with versions < 1.0.0.

# 1.0.0
* Added the following payloads:
	* php_system_python_b64
	* php_system_python_hex
* Combined php_fd_3, php_fd_4, php_fd_5, php_fd_6 payloads into a single payload (php_fd).
* Combined php_fd_3_c, php_fd_4_c, php_fd_5_c, php_fd_6_c payloads into a single payload (php_fd_c).
* Combined php_fd_3_tags, php_fd_4_tags, php_fd_5_tags, php_fd_6_tags payloads into a single payload (php_fd_tags).
* Added command-line argument "-D INTEGER"/"--fd INTEGER". This command line argument is required for the php_fd, php_fd_c and php_fd_tags payloads.
* Combined python_c, python3_c and python2_c into a single payload (python_c).
* Combined python_b64, python3_b64 and python2_b64 into a single payload (python_b64).
* Combined python_hex, python3_hex and python2_hex into a single payload (python_hex).
* Added command-line argument "-P INTEGER"/"--pv INTEGER". This command line argument is used to specify the Python version for the payload and is only taken into account for the python_c, python_b64, python_hex, php_system_python_b64 and php_system_python_hex payloads
* New-line characters are now appended to the end of all payloads, excluding binary payloads (e.g. java_class_binary, c_binary and c_binary_gzip).
* Added command-line argument "-N"/"--no-new-line". If this command-line argument is present, no new-line character is appended to the end of the payload.

# 0.4.0
* Added the following payloads:
	* ruby_hex
	* python3_hex
	* python2_hex
	* python_hex
	* c_binary_hex
	* c_binary_gzip_hex
	* perl_b64
	* perl_hex
* Fixed URL encoding for socat payload.
* Fixed URL encoding for c_binary_b64 payload.

# 0.3.0
* Added the following payloads:
	* awk
	* socat
	* java_class_binary
	* java_class_b64
	* java_class_gzip_b64
	* c_binary
	* c_binary_b64
	* c_binary_gzip
	* c_binary_gzip_b64

# 0.2.0
* Removed php_dev_tcp_tags from valid payloads. (This was a remnant from an earlier test that I forgot to remove.)
* Added the following payloads:
	* perl
	* perl_c
	* ruby
	* ruby_c
	* ruby_b64
	* bash_tcp
