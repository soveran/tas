Gem::Specification.new do |s|
  s.name        = "tas"
  s.version     = "0.0.1"
  s.summary     = "Trees as strings"
  s.description = "Represent trees as strings"
  s.authors     = ["Michel Martens"]
  s.email       = ["michel@soveran.com"]
  s.homepage    = "https://github.com/soveran/tas"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_development_dependency "cutest"
end
