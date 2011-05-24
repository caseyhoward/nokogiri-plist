require 'test/unit'
require 'shoulda'
require 'mocha'

ROOT = File.join(File.expand_path(File.dirname(__FILE__)), '..')

$LOAD_PATH.unshift(ROOT)
require File.join('nokogiri-plist.rb')