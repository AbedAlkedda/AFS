# frozen_string_literal: true

Gem::Specification.new do |s|
  s.version = '0.0.0.4'
  s.authors = ['Abed A']
  s.files   = Dir['lib/**/*.rb']
  s.files.reject! { |fn| fn.include? 'example' }
  s.name    = 'falafel'
  s.summary = 'Falafel is a gem to help you understand Automata better, hopefully'
  s.required_ruby_version = '>= 2.7.0'
end
