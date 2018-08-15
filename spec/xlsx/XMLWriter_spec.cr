require "./spec_helper.cr"

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
end

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

  describe "start.tag()" do
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
  end
end
