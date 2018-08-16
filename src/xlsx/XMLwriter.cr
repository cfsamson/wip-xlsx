require "./exceptions.cr"

private class FileBuffer
  property name : String
  property buffer : IO::Memory

  def initialize(@name, @buffer = IO::Memory.new)
    @buffer.set_encoding("UTF-8")
  end
end

# Base class for XlsxWriter
class XMLWriter
  getter fh : FileBuffer?

  def initialize
    @fh = nil
    @escapes = Regex.new %q(["&<>\n])
    @internal_fh = false
  end

  # Set the writer filehandle directly. Mainly for testing.
  private def set_filehandle(filehandle)
    @fh = filehandle
    @internal_fh = false
  end

  # Set the XML writer filehandle for the object.
  private def set_xml_writer(filename : String)
    if (@fh.nil?)
      @internal_fh = true
      @fh = FileBuffer.new(filename)
    end
  end

  private def set_xml_writer(file : FileBuffer)
    @internal_fh = false
    @fh = file
  end

  # Close the XML filehandle if we created it.
  private def close
    @fh.buffer.close if @internal_fh
  end

  # Write the XML declaration.
  private def xml_declaration
    decl = %(<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n)
    @fh.try(&.buffer.print decl) # {|fh| fh.buffer << decl}

  end

  # Write an XML start tag with optional attributes.
  private def xml_start_tag(tag, attributes : Hash(String, String))
    raise XMLException.new("There is no filehandle set") if @fh.nil?
    buff = @fh.not_nil!.buffer
    buff << "<#{tag}"
    attributes.each do |key, value|
      value = escape_attributes(value)
      buff << %( #{key}="#{value}")
    end
    buff << ">"
  end

  # ditto
  private def xml_start_tag(tag)
    tag = "<%s>" % tag
    fh = @fh
    fh.buffer << tag if fh
  end

  # Write an empty XML tag with optional, unencoded, attributes.
  # This is a minor speed optimization for elements that don't
  # need encoding.
  private def xml_start_tag_unencoded(tag, attributes : Hash(String, String))
    raise XMLException.new("There is no filehandle set") if @fh.nil?
    buff = @fh.not_nil!.buffer
    buff << "<#{tag}"
    attributes.each { |key, value| buff << %( #{key}="#{value}") }
    buff << ">"
  end

  # Write an XML end tag.
  private def xml_end_tag(tag)
    @fh.try(&.buffer.print "</#{tag}>")
  end

  # Write an empty XML tag with optional attributes.
  def xml_empty_tag(tag, attributes = {} of String => String)
    attributes.each do |key, value|
      value = escape_attributes value
      tag += %( #{key}="#{value}")
    end
    @fh.try(&.buffer.print "<#{tag}/>")
  end

  # Write an empty XML tag with optional, unencoded, attributes.
  # This is a minor speed optimization for elements that don't
  # need encoding.
  def xml_empty_tag_unencoded(tag, attributes = {} of String => String)
    attributes.each do |key, value|
      tag += %( #{key}="#{value}")
    end
    @fh.try(&.buffer.print "<#{tag}/>")
  end

  # Write an XML element containing data with optional attributes.
  def xml_data_element(tag, data, attributes = {} of String => String)
    end_tag = tag

    attributes.each do |key, value|
      value = escape_attributes(value)
      tag += %( #{key}="#{value}")
    end

    data = escape_data(data)
    @fh.try(&.buffer.print "<#{tag}>#{data}</#{end_tag}>")
  end

  # Optimized tag writer for <c> cell string elements in the inner loop.
  def xml_string_element(index, attributes = {} of String => String)
    attr = ""
    attributes.each do |key, value|
      value = escape_attributes(value)
      attr += %( #{key}="#{value}")
    end
    @fh.try(&.buffer.print %q(<c%s t=\"s\"><v>%d</v></c>) % [attr, index])
  end

  # Optimized tag writer for shared strings <si> elements.
  def xml_si_element(str, attributes = {} of String => String)
    attr = ""

    attributes.each do |key, value|
      value = escape_attributes(value)
      attr += %( #{key}="#{value}")
    end

    str = escape_data(str)
    @fh.try(&.buffer.print %q(<si><t%s>%s</t></si>) % [attr, str])
  end

  # Optimized tag writer for shared strings <si> rich string elements.
  def xml_rich_si_element(str)
    @fh.try(&.buffer.print %q(<si>%s</si>) % str)
  end

  

  # Escape XML characters in attributes.
  private def escape_attributes(attribute)
    begin
      return attribute if @escapes.match(attribute).nil?
    rescue
      return attribute
    end

    attribute = attribute.gsub('&', "&amp;")
    attribute = attribute.gsub("\"", "&quot;")
    attribute = attribute.gsub('<', "&lt;")
    attribute = attribute.gsub('>', "&gt;")
    attribute = attribute.gsub('\n', "&#xA;")
  end

  # Escape XML characters in data sections of tags.  Note, this
  # is different from _escape_attributes() in that double quotes
  # are not escaped by Excel.
  private def escape_data(data)
    begin
      return data if @escapes.match(data).nil?
    rescue
      return data
    end
    data = data.gsub('&', "&amp;")
    data = data.gsub('<', "&lt;")
    data = data.gsub('>', "&gt;")
  end
end
