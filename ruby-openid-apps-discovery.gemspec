Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "Google Apps support for ruby-openid"
  s.name = 'ruby-openid-apps-discovery'
  s.version = '1.01'
  s.add_dependency('ruby-openid', '>=2.1.7')
  s.require_path = 'lib'
  s.files = Dir['lib/**/*.rb'] + Dir['lib/**/*.crt']
  s.description = <<EOF
Extension to ruby-openid that enables discovery for Google Apps domains
EOF
end
