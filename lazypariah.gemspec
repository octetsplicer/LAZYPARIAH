Gem::Specification.new() do |s|
	s.name = "lazypariah"
	s.version = "1.6.2"
	s.summary = "[This project is no longer in active development.] A penetration testing tool for generating reverse shell payloads on the fly."
	s.description = "[This project is no longer in active development.] LAZYPARIAH is a simple penetration testing tool for generating a range of reverse shell payloads on the fly. It is intended to be used only in authorised circumstances by qualified penetration testers, security researchers and red team professionals. Before downloading, installing or using this tool, ensure that you understand the relevant laws in your jurisdiction. The author of this tool does not endorse the usage of this tool for illegal or unauthorised purposes."
	s.files = ["bin/lazypariah"]
	s.authors = ["Peter Funnell"]
	s.executables << "lazypariah"
	s.license = "GPL-3.0+"
	s.required_ruby_version = ">= 2.7.1"
	s.requirements << "A GNU/Linux or BSD operating system. Optional requirements are GCC (for C payloads), OpenJDK (for Java payloads) and Rust (for Rust payloads)."
end
