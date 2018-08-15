require "./spec_helper.cr"

describe XMLWriter do
  it "initializes without parameters" do
    writer = XMLWriter.new

    writer.should be_a(XMLWriter)
  end

  it "can write xml_declaration()" do
    writer = XMLTest.new
    writer.set_xml_writer("testfile")
    writer.xml_declaration
    buffer = writer.fh.not_nil!.buffer.rewind # 1 know that fh is not nill
    xml_test = buffer.gets(14)

    xml_test.should eq "<?xml version="
  end

  it "can write start_tag()" do
    writer = XMLTest.new
    writer.set_xml_writer("testfile")
    writer.xml_start_tag "mytag"
    tag = writer.fh.try(&.buffer.to_s)

    tag.should eq "<mytag>"
  end

  describe "xml_start.tag()" do
    it "can write with attributes" do
      writer = XMLTest.new
      writer.set_xml_writer("testfile")
      attributes = {"test" => "value", "name" => "carl"}
      writer.xml_start_tag "mytag", attributes
      tag = writer.fh.try(&.buffer.to_s)

      tag.should eq "<mytag test=\"value\" name=\"carl\">"
    end

    it "escapes attributes that need escaping" do
      writer = XMLTest.new
      writer.set_xml_writer("testfile")
      attributes = {"span" => "&<>\""}
      writer.xml_start_tag "foo", attributes
      tag = writer.fh.try(&.buffer.to_s)

      tag.should eq "<foo span=\"&amp;&lt;&gt;&quot;\">"
    end

    it "has option to add attributes unencoded" do
      writer = XMLTest.new
      writer.set_xml_writer("testfile")
      attributes = {"span" => "&<>\""}
      writer.xml_start_tag_unencoded "foo", attributes
      tag = writer.fh.try(&.buffer.to_s)

      tag.should eq "<foo span=\"&<>\"\">"
    end
  end

  it "can write end an xml_end_tag" do
    writer = XMLTest.new
    writer.set_xml_writer("testfile")
    writer.xml_end_tag("foo")
    tag = writer.fh.try(&.buffer.to_s)

    tag.should eq "</foo>"
  end

  it "can write an empty xml tag with attributes" do
    writer = xml_test_factory()
    writer.xml_empty_tag("foo", {"tst" => "val"})
    tag = writer.fh.try(&.buffer.to_s)

    tag.should eq %(<foo tst="val"/>)
  end

  it "can write an empty xml tag without attributes" do
    writer = xml_test_factory()
    writer.xml_empty_tag("foo")
    tag = writer.fh.try(&.buffer.to_s)

    tag.should eq %(<foo/>)
  end
  
  it "can write an empty unencoded tag with attributes" do
    writer = xml_test_factory()
    writer.xml_empty_tag_unencoded("foo", {"span" => "&<>\""})
    tag = writer.fh.try(&.buffer.to_s)

    tag.should eq "<foo span=\"&<>\"\"/>"
  end
  
end

def xml_test_factory() : XMLTest
  test = XMLTest.new
  test.set_xml_writer("testfile")
  test
end

class XMLTest < XMLWriter
  def set_xml_writer(filename)
    super
  end

  def xml_declaration
    super
  end

  def xml_start_tag(tag)
    super
  end

  def xml_start_tag(tag, attributes)
    super
  end

  def xml_start_tag_unencoded(tag, attributes)
    super
  end

  def xml_end_tag(tag)
    super
  end

  def xml_empty_tag(tag, attributes)
    super
  end

  def xml_empty_tag_unencoded(tag, attributes)
    super
  end

end
