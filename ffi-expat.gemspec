require "date"

spec = Gem::Specification.new do |s|
    s.name = "ffi-expat"
    s.version = "0.0.1"
    s.author = "Luc Heinrich"
    s.email = "luc@honk-honk.com"
    s.summary = "Ruby FFI wrapper for the expat XML parsing library."
    s.homepage = "http://github.com/lucsky/ffi-expat"
    s.date = DateTime.now

    s.files = Dir['lib/**/*.rb'] + Dir['test/**/*'] + ["LICENSE", "README.md"]
    s.test_files = Dir['test/**/test*.rb']
    s.requirements << "The expat library :)"
    s.add_dependency "ffi"
    s.has_rdoc = false
end
