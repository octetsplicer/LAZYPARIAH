Gem::Specification.new() do |s|
	s.name = "lazypariah"
	s.version = "1.6.0"
	s.summary = "A tool for generating reverse shell payloads on the fly."
	s.description = "LAZYPARIAH is a simple tool for generating a range of reverse shell payloads on the fly. It is intended to be used only in authorised circumstances by qualified penetration testers, security researchers and red team professionals. Before downloading, installing or using this tool, ensure that you understand the relevant laws in your jurisdiction. The author of this tool does not endorse the usage of this tool for illegal or unauthorised purposes."
	s.files = ["bin/lazypariah"]
	s.authors = ["Peter Funnell"]
	s.email = "hello@octetsplicer.com"
	s.executables << "lazypariah"
	s.homepage = "https://github.com/octetsplicer/LAZYPARIAH"
	s.license = "GPL-3.0+"
	s.required_ruby_version = ">= 2.7.1"
	s.requirements << "A GNU/Linux or BSD operating system. Optional requirements are GCC (for C payloads), OpenJDK (for Java payloads) and Rust (for Rust payloads)."
end
