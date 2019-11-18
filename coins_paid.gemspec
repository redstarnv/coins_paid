Gem::Specification.new do |s|
  s.name = 'coins_paid'
  s.authors = ['Artem Biserov(artembiserov)', 'Oleg Ivanov(morhekil)']
  s.version = '1.0.0'
  s.files = `git ls-files`.split("\n")
  s.summary = 'Coins Paid Rails Integration'
  s.license = 'MIT'

  s.add_runtime_dependency 'coins_paid_api'
  s.add_runtime_dependency 'activerecord', '>= 4.2.0'
  s.add_runtime_dependency 'dry-initializer', '~> 3.0'
  s.add_runtime_dependency 'dry-struct', '~> 1.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'rspec-its'
end

