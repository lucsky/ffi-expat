require "ffi"

# =============================================================================

module FFI::Expat
    extend FFI::Library
    ffi_lib "expat"

    # -------------------------------------------------------------------------
    
    typedef :pointer, :XML_Parser

    # -------------------------------------------------------------------------
    
    enum :XML_Status, [         :XML_STATUS_ERROR, 
                                :XML_STATUS_OK,
                                :XML_STATUS_SUSPENDED]
    
    enum :XML_Error, [          :XML_ERROR_NONE,
                                :XML_ERROR_NO_MEMORY,
                                :XML_ERROR_SYNTAX,
                                :XML_ERROR_NO_ELEMENTS,
                                :XML_ERROR_INVALID_TOKEN,
                                :XML_ERROR_UNCLOSED_TOKEN,
                                :XML_ERROR_PARTIAL_CHAR,
                                :XML_ERROR_TAG_MISMATCH,
                                :XML_ERROR_DUPLICATE_ATTRIBUTE,
                                :XML_ERROR_JUNK_AFTER_DOC_ELEMENT,
                                :XML_ERROR_PARAM_ENTITY_REF,
                                :XML_ERROR_UNDEFINED_ENTITY,
                                :XML_ERROR_RECURSIVE_ENTITY_REF,
                                :XML_ERROR_ASYNC_ENTITY,
                                :XML_ERROR_BAD_CHAR_REF,
                                :XML_ERROR_BINARY_ENTITY_REF,
                                :XML_ERROR_ATTRIBUTE_EXTERNAL_ENTITY_REF,
                                :XML_ERROR_MISPLACED_XML_PI,
                                :XML_ERROR_UNKNOWN_ENCODING,
                                :XML_ERROR_INCORRECT_ENCODING,
                                :XML_ERROR_UNCLOSED_CDATA_SECTION,
                                :XML_ERROR_EXTERNAL_ENTITY_HANDLING,
                                :XML_ERROR_NOT_STANDALONE,
                                :XML_ERROR_UNEXPECTED_STATE,
                                :XML_ERROR_ENTITY_DECLARED_IN_PE,
                                :XML_ERROR_FEATURE_REQUIRES_XML_DTD,
                                :XML_ERROR_CANT_CHANGE_FEATURE_ONCE_PARSING,
                                # Added in 1.95.7
                                :XML_ERROR_UNBOUND_PREFIX,
                                # Added in 1.95.8.
                                :XML_ERROR_UNDECLARING_PREFIX,
                                :XML_ERROR_INCOMPLETE_PE,
                                :XML_ERROR_XML_DECL,
                                :XML_ERROR_TEXT_DECL,
                                :XML_ERROR_PUBLICID,
                                :XML_ERROR_SUSPENDED,
                                :XML_ERROR_NOT_SUSPENDED,
                                :XML_ERROR_ABORTED,
                                :XML_ERROR_FINISHED,
                                :XML_ERROR_SUSPEND_PE,
                                # Added in 2.0
                                :XML_ERROR_RESERVED_PREFIX_XML,
                                :XML_ERROR_RESERVED_PREFIX_XMLNS,
                                :XML_ERROR_RESERVED_NAMESPACE_URI ]
    
    # -------------------------------------------------------------------------
    
    enum :XML_Content_Type, [   :XML_CTYPE_EMPTY, 1,
                                :XML_CTYPE_ANY,
                                :XML_CTYPE_MIXED,
                                :XML_CTYPE_NAME,
                                :XML_CTYPE_CHOICE,
                                :XML_CTYPE_SEQ ]
    
    enum :XML_Content_Quant, [  :XML_CQUANT_NONE,
                                :XML_CQUANT_OPT,
                                :XML_CQUANT_REP,
                                :XML_CQUANT_PLUS ]
    
    class XML_Content < FFI::Struct
        layout  :type,          :XML_Content_Type,
                :quant,         :XML_Content_Quant,
                :name,          :string,
                :numchildren,   :int,
                :children,      :pointer
    end
        
    attach_function :XML_ParserCreate, [:string], :XML_Parser
    attach_function :XML_ParserCreateNS, [:string, :char], :XML_Parser
    attach_function :XML_ParserReset, [:XML_Parser, :string], :bool

    callback :XML_ElementDeclHandler, [:pointer, :string, XML_Content], :void
    attach_function :XML_SetElementDeclHandler, [:XML_Parser, :XML_ElementDeclHandler], :void

    callback :XML_AttlistDeclHandler, [:pointer, :string, :string, :string, :string, :int], :void
    attach_function :XML_SetAttlistDeclHandler, [:XML_Parser, :XML_AttlistDeclHandler], :void

    callback :XML_XmlDeclHandler, [:pointer, :string, :string, :int], :void
    attach_function :XML_SetXmlDeclHandler, [:XML_Parser, :XML_XmlDeclHandler], :void

    callback :XML_Encoding_convert, [:pointer, :string], :int
    callback :XML_Encoding_release, [:pointer], :void
    class XML_Encoding < FFI::Struct
        layout  :map,                   [:char, 256],
                :data,                  :pointer,
                :convert,               :XML_Encoding_convert,
                :release,               :XML_Encoding_release
    end

    callback :XML_StartElementHandler, [:pointer, :string, :pointer], :void
    callback :XML_EndElementHandler, [:pointer, :string], :void
    attach_function :XML_SetElementHandler, [:XML_Parser, :XML_StartElementHandler, :XML_EndElementHandler], :void
    attach_function :XML_SetStartElementHandler, [:XML_Parser, :XML_StartElementHandler], :void
    attach_function :XML_SetEndElementHandler, [:XML_Parser, :XML_EndElementHandler], :void
    attach_function :XML_GetSpecifiedAttributeCount, [:XML_Parser], :int
    attach_function :XML_GetIdAttributeIndex, [:XML_Parser], :int

    callback :XML_CharacterDataHandler, [:pointer, :pointer, :int], :void
    attach_function :XML_SetCharacterDataHandler, [:XML_Parser, :XML_CharacterDataHandler], :void

    callback :XML_ProcessingInstructionHandler, [:pointer, :string, :string], :void
    attach_function :XML_SetProcessingInstructionHandler, [:XML_Parser, :XML_ProcessingInstructionHandler], :void

    callback :XML_CommentHandler, [:pointer, :string], :void
    attach_function :XML_SetCommentHandler, [:XML_Parser, :XML_CommentHandler], :void

    callback :XML_StartCdataSectionHandler, [:pointer], :void
    callback :XML_EndCdataSectionHandler, [:pointer], :void
    attach_function :XML_SetCdataSectionHandler, [:XML_Parser, :XML_StartCdataSectionHandler, :XML_EndCdataSectionHandler], :void
    attach_function :XML_SetStartCdataSectionHandler, [:XML_Parser, :XML_StartCdataSectionHandler], :void
    attach_function :XML_SetEndCdataSectionHandler, [:XML_Parser, :XML_EndCdataSectionHandler], :void
    
    callback :XML_DefaultHandler, [:pointer, :pointer, :int], :void
    attach_function :XML_SetDefaultHandler, [:XML_Parser, :XML_DefaultHandler], :void
    attach_function :XML_SetDefaultHandlerExpand, [:XML_Parser, :XML_DefaultHandler], :void
    
    callback :XML_StartDoctypeDeclHandler, [:pointer, :string, :string, :string, :int], :void
    callback :XML_EndDoctypeDeclHandler, [:pointer, :pointer], :void
    attach_function :XML_SetDoctypeDeclHandler, [:XML_Parser, :XML_StartDoctypeDeclHandler, :XML_EndDoctypeDeclHandler], :void
    attach_function :XML_SetStartDoctypeDeclHandler, [:XML_Parser, :XML_StartDoctypeDeclHandler], :void
    attach_function :XML_SetEndDoctypeDeclHandler, [:XML_Parser, :XML_EndDoctypeDeclHandler], :void
    
    callback :XML_EntityDeclHandler, [:pointer, :string, :int, :pointer, :int, :string, :string, :string, :string], :void
    attach_function :XML_SetEntityDeclHandler, [:XML_Parser, :XML_EntityDeclHandler], :void

    callback :XML_NotationDeclHandler, [:pointer, :string, :string, :string, :string], :void
    attach_function :XML_SetNotationDeclHandler, [:XML_Parser, :XML_NotationDeclHandler], :void
    
    callback :XML_StartNamespaceDeclHandler, [:pointer, :string, :string], :void
    callback :XML_EndNamespaceDeclHandler, [:pointer, :string], :void
    attach_function :XML_SetNamespaceDeclHandler, [:XML_Parser, :XML_StartNamespaceDeclHandler, :XML_EndNamespaceDeclHandler], :void
    attach_function :XML_SetStartNamespaceDeclHandler, [:XML_Parser, :XML_StartNamespaceDeclHandler], :void
    attach_function :XML_SetEndNamespaceDeclHandler, [:XML_Parser, :XML_EndNamespaceDeclHandler], :void
    
    callback :XML_NotStandaloneHandler, [:pointer], :void
    attach_function :XML_SetNotStandaloneHandler, [:XML_Parser, :XML_NotStandaloneHandler], :void
    
    callback :XML_ExternalEntityRefHandler, [:pointer, :string, :string, :string, :string], :void
    attach_function :XML_SetExternalEntityRefHandler, [:XML_Parser, :XML_ExternalEntityRefHandler], :void
    
    callback :XML_SkippedEntityHandler, [:pointer, :string, :int], :void
    attach_function :XML_SetExternalEntityRefHandlerArg, [:XML_Parser, :pointer], :void
    attach_function :XML_SetSkippedEntityHandler, [:XML_Parser, :XML_SkippedEntityHandler], :void

    callback :XML_UnknownEncodingHandler, [:pointer, :string, XML_Encoding], :int
    attach_function :XML_SetUnknownEncodingHandler, [:XML_Parser, :XML_UnknownEncodingHandler, :pointer], :void

    # -------------------------------------------------------------------------

    attach_function :XML_DefaultCurrent, [:XML_Parser], :void
    attach_function :XML_SetReturnNSTriplet, [:XML_Parser, :int], :void
    attach_function :XML_SetUserData, [:XML_Parser, :pointer], :void
    attach_function :XML_SetEncoding, [:XML_Parser, :string], :XML_Status
    attach_function :XML_UseParserAsHandlerArg, [:XML_Parser], :void
    attach_function :XML_UseForeignDTD, [:XML_Parser, :bool], :XML_Error
    attach_function :XML_SetBase, [:XML_Parser, :string], :XML_Status
    attach_function :XML_GetBase, [:XML_Parser], :string

    # -------------------------------------------------------------------------

    attach_function :XML_Parse, [:XML_Parser, :pointer, :int, :bool], :XML_Status
    attach_function :XML_GetBuffer, [:XML_Parser, :int], :pointer
    attach_function :XML_ParseBuffer, [:XML_Parser, :int, :int], :XML_Status
    attach_function :XML_StopParser, [:XML_Parser, :bool], :XML_Status
    attach_function :XML_ResumeParser, [:XML_Parser], :XML_Status

    enum :XML_Parsing, [:XML_INITIALIZED, :XML_PARSING, :XML_FINISHED, :XML_SUSPENDED]
    class XML_ParsingStatus < FFI::Struct
        layout  :parsing,       :XML_Parsing,
                :finalBuffer,   :bool
    end
    attach_function :XML_GetParsingStatus, [:XML_Parser, :buffer_out], :void

    # -------------------------------------------------------------------------

    enum :XML_ParamEntityParsing, [:XML_PARAM_ENTITY_PARSING_NEVER, :XML_PARAM_ENTITY_PARSING_UNLESS_STANDALONE, :XML_PARAM_ENTITY_PARSING_ALWAYS]

    attach_function :XML_ExternalEntityParserCreate, [:XML_Parser, :string, :string], :XML_Parser
    attach_function :XML_SetParamEntityParsing, [:XML_Parser, :XML_ParamEntityParsing], :int

    # -------------------------------------------------------------------------

    attach_function :XML_GetErrorCode, [:XML_Parser], :XML_Error
    attach_function :XML_GetCurrentLineNumber, [:XML_Parser], :ulong
    attach_function :XML_GetCurrentColumnNumber, [:XML_Parser], :ulong
    attach_function :XML_GetCurrentByteIndex, [:XML_Parser], :ulong
    attach_function :XML_GetCurrentByteCount, [:XML_Parser], :int
    attach_function :XML_GetInputContext, [:XML_Parser, :buffer_out, :buffer_out], :pointer

    # -------------------------------------------------------------------------

    attach_function :XML_FreeContentModel, [:XML_Parser, :pointer], :void
    attach_function :XML_ParserFree, [:XML_Parser], :void
    attach_function :XML_ErrorString, [:XML_Error], :string

    # -------------------------------------------------------------------------
    
    class XML_Expat_Version < FFI::Struct
        layout  :major, :int, 
                :minor, :int, 
                :micro, :int
    end

    attach_function :XML_ExpatVersion, [ ], :string
    attach_function :XML_ExpatVersionInfo, [ ], XML_Expat_Version.by_value

    # -------------------------------------------------------------------------
    
    enum :XML_FeatureEnum, [:XML_FEATURE_END,
                            :XML_FEATURE_UNICODE,
                            :XML_FEATURE_UNICODE_WCHAR_T,
                            :XML_FEATURE_DTD,
                            :XML_FEATURE_CONTEXT_BYTES,
                            :XML_FEATURE_MIN_SIZE,
                            :XML_FEATURE_SIZEOF_XML_CHAR,
                            :XML_FEATURE_SIZEOF_XML_LCHAR,
                            :XML_FEATURE_NS,
                            :XML_FEATURE_LARGE_SIZE ]
    
    class XML_Feature < FFI::Struct
        layout :feature, :XML_FeatureEnum,
               :name,    :string,
               :value,   :long
    end
    
    attach_function :XML_GetFeatureList, [ ], :pointer

    # -------------------------------------------------------------------------

end

# =============================================================================

xml = <<-XML
<?xml version="1.0"?>
<catalog>
   <book id="bk101">
      <author>Gambardella, Matthew</author>
      <title>XML Developer's Guide</title>
      <genre>Computer</genre>
      <price>44.95</price>
      <publish_date>2000-10-01</publish_date>
      <description>An in-depth look at creating applications 
      with XML.</description>
   </book>
   <book id="bk102">
      <author>Ralls, Kim</author>
      <title>Midnight Rain</title>
      <genre>Fantasy</genre>
      <price>5.95</price>
      <publish_date>2000-12-16</publish_date>
      <description>A former architect battles corporate zombies, 
      an evil sorceress, and her own childhood to become queen 
      of the world.</description>
   </book>
   <book id="bk103">
      <author>Corets, Eva</author>
      <title>Maeve Ascendant</title>
      <genre>Fantasy</genre>
      <price>5.95</price>
      <publish_date>2000-11-17</publish_date>
      <description>After the collapse of a nanotechnology 
      society in England, the young survivors lay the 
      foundation for a new society.</description>
   </book>
   <book id="bk104">
      <author>Corets, Eva</author>
      <title>Oberon's Legacy</title>
      <genre>Fantasy</genre>
      <price>5.95</price>
      <publish_date>2001-03-10</publish_date>
      <description>In post-apocalypse England, the mysterious 
      agent known only as Oberon helps to create a new life 
      for the inhabitants of London. Sequel to Maeve 
      Ascendant.</description>
   </book>
   <book id="bk105">
      <author>Corets, Eva</author>
      <title>The Sundered Grail</title>
      <genre>Fantasy</genre>
      <price>5.95</price>
      <publish_date>2001-09-10</publish_date>
      <description>The two daughters of Maeve, half-sisters, 
      battle one another for control of England. Sequel to 
      Oberon's Legacy.</description>
   </book>
   <book id="bk106">
      <author>Randall, Cynthia</author>
      <title>Lover Birds</title>
      <genre>Romance</genre>
      <price>4.95</price>
      <publish_date>2000-09-02</publish_date>
      <description>When Carla meets Paul at an ornithology 
      conference, tempers fly as feathers get ruffled.</description>
   </book>
   <book id="bk107">
      <author>Thurman, Paula</author>
      <title>Splish Splash</title>
      <genre>Romance</genre>
      <price>4.95</price>
      <publish_date>2000-11-02</publish_date>
      <description>A deep sea diver finds true love twenty 
      thousand leagues beneath the sea.</description>
   </book>
   <book id="bk108">
      <author>Knorr, Stefan</author>
      <title>Creepy Crawlies</title>
      <genre>Horror</genre>
      <price>4.95</price>
      <publish_date>2000-12-06</publish_date>
      <description>An anthology of horror stories about roaches,
      centipedes, scorpions  and other insects.</description>
   </book>
   <book id="bk109">
      <author>Kress, Peter</author>
      <title>Paradox Lost</title>
      <genre>Science Fiction</genre>
      <price>6.95</price>
      <publish_date>2000-11-02</publish_date>
      <description>After an inadvertant trip through a Heisenberg
      Uncertainty Device, James Salway discovers the problems 
      of being quantum.</description>
   </book>
   <book id="bk110">
      <author>O'Brien, Tim</author>
      <title>Microsoft .NET: The Programming Bible</title>
      <genre>Computer</genre>
      <price>36.95</price>
      <publish_date>2000-12-09</publish_date>
      <description>Microsoft's .NET initiative is explored in 
      detail in this deep programmer's reference.</description>
   </book>
   <book id="bk111">
      <author>O'Brien, Tim</author>
      <title>MSXML3: A Comprehensive Guide</title>
      <genre>Computer</genre>
      <price>36.95</price>
      <publish_date>2000-12-01</publish_date>
      <description>The Microsoft MSXML3 parser is covered in 
      detail, with attention to XML DOM interfaces, XSLT processing, 
      SAX and more.</description>
   </book>
   <book id="bk112">
      <author>Galos, Mike</author>
      <title>Visual Studio 7: A Comprehensive Guide</title>
      <genre>Computer</genre>
      <price>49.95</price>
      <publish_date>2001-04-16</publish_date>
      <description>Microsoft Visual Studio 7 is explored in depth,
      looking at how Visual Basic, Visual C++, C#, and ASP+ are 
      integrated into a comprehensive development 
      environment.</description>
   </book>
</catalog>
XML

handle_start = Proc.new do |parser, tag, attrs|
#    p FFI::Expat.XML_GetSpecifiedAttributeCount(parser)
#    puts tag
end

parser = FFI::Expat.XML_ParserCreate(nil)
FFI::Expat.XML_UseParserAsHandlerArg(parser)
FFI::Expat.XML_SetStartElementHandler(parser, handle_start)
FFI::Expat.XML_Parse(parser, xml, xml.length, true)
FFI::Expat.XML_ParserFree(parser)
