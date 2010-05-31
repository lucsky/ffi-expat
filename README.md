ffi-expat
=========

ffi-expat is a Ruby FFI wrapper for the expat XML parsing library.

Installation
============

    [sudo] gem install ffi-zlib

SAMPLE USAGE
============

ffi-expat is a thin wrapper around the expat calls so using ffi-expat in Ruby is similar to the way you would use expat in C (modulo the obious language specifics).

Here's a simple example which counts the number of each start tags:

	require "rubygems"
	require "ffi/expat"

	class Handler
		attr_reader :starts
	    def initialize
	        @starts = Hash.new
	    end
	    def start_elem(parser, tag, attrs)
	        if @starts.has_key?(tag)
	            @starts[tag] += 1
	        else
	            @starts[tag] = 1
	        end
	    end
	end

	xml = File.read("test.xml")
	handler = Handler.new
	parser = FFI::Expat.XML_ParserCreate(nil)
	FFI::Expat.XML_SetStartElementHandler(parser, handler.method(:start_elem))
	FFI::Expat.XML_Parse(parser, xml, xml.length, true)
	FFI::Expat.XML_ParserFree(parser)
	
	handler.starts.each do |tag, count|
		puts "#{tag}: #{count}"
	end

AUTHORS 
==============

Luc Heinrich <luc@honk-honk.com>

LICENSE
==============

MIT.