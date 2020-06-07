# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "minimal-course"
  spec.version       = "0.1.0"
  spec.authors       = ["dajmcdon"]
  spec.email         = ["dajmcdon@gmail.com"]

  spec.summary       = %q{Minimalistic responsive theme using Bootstrap 4 and navbar.}
  spec.description   = "This theme intentionally includes only Bootstrap and Fontawesome. Some flexibility is made easy inside the config file. Blogging is not natively supported."
  spec.homepage      = "https://github.com/dajmcdon/minimal-course"
  spec.metadata      = { "source_code_uri" => "https://github.com/dajmcdon/minimal-course" }
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(assets|_data|_layouts|_includes|_sass|LICENSE|README)}i) }

  spec.add_runtime_dependency "jekyll", "~> 3.6"
  
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
