require 'rubygems'
require 'test/unit'

ROOT = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift(File.join(ROOT, '..', 'lib'))
require 'ffi/expat'

class Handler
    attr_reader :tag_starts
    attr_reader :tag_ends
    def initialize
        @tag_starts = Hash.new
        @tag_ends = Hash.new
    end
    def start_elem(parser, tag, attrs)
        if @tag_starts.has_key?(tag)
            @tag_starts[tag] += 1
        else
            @tag_starts[tag] = 1
        end
    end
    def end_elem(parser, tag)
        if @tag_ends.has_key?(tag)
            @tag_ends[tag] += 1
        else
            @tag_ends[tag] = 1
        end
    end
end

class SimpleTest < Test::Unit::TestCase
    
    def test_parse
        xml = File.read(File.join(ROOT, 'fixtures', 'sample.xml'))
        handler = Handler.new
        parser = FFI::Expat.XML_ParserCreate(nil)
        FFI::Expat.XML_UseParserAsHandlerArg(parser)
        FFI::Expat.XML_SetStartElementHandler(parser, handler.method(:start_elem))
        FFI::Expat.XML_SetEndElementHandler(parser, handler.method(:end_elem))
        FFI::Expat.XML_Parse(parser, xml, xml.length, true)
        FFI::Expat.XML_ParserFree(parser)

        assert_equal(handler.tag_starts['catalog'], 1)
        assert_equal(handler.tag_starts['book'], 12)
        assert_equal(handler.tag_starts['author'], 12)
        assert_equal(handler.tag_starts['title'], 12)
        assert_equal(handler.tag_starts['genre'], 12)
        assert_equal(handler.tag_starts['price'], 12)
        assert_equal(handler.tag_starts['publish_date'], 12)
        assert_equal(handler.tag_starts['description'], 12)

        assert_equal(handler.tag_ends['catalog'], 1)
        assert_equal(handler.tag_ends['book'], 12)
        assert_equal(handler.tag_ends['author'], 12)
        assert_equal(handler.tag_ends['title'], 12)
        assert_equal(handler.tag_ends['genre'], 12)
        assert_equal(handler.tag_ends['price'], 12)
        assert_equal(handler.tag_ends['publish_date'], 12)
        assert_equal(handler.tag_ends['description'], 12)
    end
    
end
