#!/usr/bin/env ruby 

puts "FFF"

#require 'open-uri'
#url = "http://mb.onliner.by/#currency=USD&sort[]=creation_date&page=1&moto[0][70]=&moto[1][66]"
#html = open(url)


require 'net/http'
require 'cgi'

#def http_get(domain,path,params)
#    return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?#
#    return Net::HTTP.get(domain, path)
#end

#params = {:q => "ruby", :max => 50}
res =  Net::HTTP.get("mb.onliner.by", "/#currency=USD&sort[]=creation_date&page=1&moto[0][70]=&moto[1][66]")
#Net::HTTP.get(domain, path)

print res.scan(/moto/)
