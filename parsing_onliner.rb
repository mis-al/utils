#!/usr/bin/env ruby
require 'rubygems'
require'mechanize'

puts "Start!!!"
agent = Mechanize.new

page = agent.get('http://onliner.by/')

page.links.each do |link|
  puts link.text
end

p agent.page.links_with(:text => 'Мотобарахолка')
