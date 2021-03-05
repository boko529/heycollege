# -*- encoding: utf-8 -*-
# stub: chart-js-rails 0.1.7 ruby lib

Gem::Specification.new do |s|
  s.name = "chart-js-rails".freeze
  s.version = "0.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Keith Walsh".freeze]
  s.date = "2019-10-23"
  s.description = "Chart.js for use in Rails asset pipeline".freeze
  s.email = ["walsh1kt@gmail.com".freeze]
  s.homepage = "".freeze
  s.rubygems_version = "3.1.4".freeze
  s.summary = "Create HTML5 charts".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<railties>.freeze, ["> 3.1"])
  else
    s.add_dependency(%q<railties>.freeze, ["> 3.1"])
  end
end
