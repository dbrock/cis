require "rubygems"
require "bundler/setup"
require "blossom"

app = Blossom __FILE__, :cis,
  # :strip_www? => false,
  :cache => [1, :day]

run app
