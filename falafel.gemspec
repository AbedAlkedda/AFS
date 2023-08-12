# frozen_string_literal: true

Gem::Specification.new do |s|
  s.version = '0.0.2.2'
  s.authors = ['Abed Alkedda']
  s.files   = Dir['lib/**/*.rb']
  s.files.reject! { |fn| fn.include? 'example' }
  s.name     = 'falafel'
  s.summary  = 'Falafel is a gem that will hopefully help you better understand automata and formal languages'
  s.homepage = 'https://github.com/AbedAlkedda/AFS'
  s.licenses = ''
  s.required_ruby_version = '>= 2.7.0'
end
