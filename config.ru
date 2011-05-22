require "rubygems"
require "bundler/setup"
require "blossom"

run Blossom __FILE__, :cis,
  # :strip_www? => false,
  :cache => [1, :day]
