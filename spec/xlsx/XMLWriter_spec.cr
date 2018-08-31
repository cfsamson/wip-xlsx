require "./spec_helper.cr"

describe XMLWriter do
  it "initializes coorectly when inherited by a class" do
    writer = XMLTest.new

    writer.should be_a(XMLWriter)
  end

  describe "#xml_declaration" do
    it "can write xml_declaration()" do
      writer = XMLTest.new
      writer.set_xml_writer("testfile")
      writer.xml_declaration
      buffer = writer.fh.not_nil!.buffer.rewind # 1 know that fh is not nill
      xml_test = buffer.gets(14)

      xml_test.should eq "<?xml version="
    end
  end
  describe "#xml_start_tag" do
    it "can write start_tag()" do
      writer = xml_test_factory()
      writer.xml_start_tag "mytag"
      tag = writer.fh.try(&.buffer.to_s)

      tag.should eq "<mytag>"
    end

    it "can write with attributes" do
      writer = xml_test_factory()
      attributes = {"test" => "value", "name" => "carl"}
      writer.xml_start_tag "mytag", attributes
      tag = writer.fh.try(&.buffer.to_s)

      tag.should eq "<mytag test=\"value\" name=\"carl\">"
    end

    it "escapes attributes that need escaping" do
      writer = xml_test_factory()
      attributes = {"span" => "&<>\""}
      writer.xml_start_tag "foo", attributes
      tag = writer.fh.try(&.buffer.to_s)

      tag.should eq "<foo span=\"&amp;&lt;&gt;&quot;\">"
    end

    it "has option to add attributes unencoded" do
      writer = xml_test_factory()
      attributes = {"span" => "&<>\""}
      writer.xml_start_tag_unencoded "foo", attributes
      tag = writer.fh.try(&.buffer.to_s)

      tag.should eq "<foo span=\"&<>\"\">"
    end
  end

  describe "#xml_end_tag" do
    it "can write end an xml_end_tag" do
      writer = xml_test_factory()
      writer.xml_end_tag("foo")
      tag = writer.fh.try(&.buffer.to_s)

      tag.should eq "</foo>"
    end
  end

  describe "#xml_empty_tag" do
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
  end

  describe "#xml_empty_tag_unencoded" do
    it "can write an empty unencoded tag with attributes" do
      writer = xml_test_factory()
      writer.xml_empty_tag_unencoded("foo", {"span" => "&<>\""})
      tag = writer.fh.try(&.buffer.to_s)

      tag.should eq "<foo span=\"&<>\"\"/>"
    end
  end

  describe "#xml_data_element" do
    it "can write xml data element without attributes" do
      writer = xml_test_factory()
      writer.xml_data_element("foo", "bar")
      tagelement = writer.fh.try(&.buffer.to_s)

      tagelement.should eq "<foo>bar</foo>"
    end

    it "can write xml data element with attributes" do
      writer = xml_test_factory()
      writer.xml_data_element("foo", "bar", {"span" => "8"})
      tagelement = writer.fh.try(&.buffer.to_s)

      tagelement.should eq "<foo span=\"8\">bar</foo>"
    end

    it "can write xml data element with data requiring escaping" do
      writer = xml_test_factory()
      writer.xml_data_element("foo", %(&<>"), {"span" => "8"})
      tagelement = writer.fh.try(&.buffer.to_s)

      tagelement.should eq %(<foo span="8">&amp;&lt;&gt;"</foo>)
    end
  end

  describe "#xml_string_element" do
    it "can write a xml string element without attributes" do
      writer = xml_test_factory()
      writer.xml_string_element(99, {"span" => "8"})
      tagelement = writer.fh.try(&.buffer.to_s)

      tagelement.should eq %q(<c span="8" t=\"s\"><v>99</v></c>)
    end
  end

  describe "#xml_si_element" do
    it "can write an xml si element" do
      writer = xml_test_factory()
      writer.xml_si_element("foo", {"span" => "8"})
      tagelement = writer.fh.try(&.buffer.to_s)

      tagelement.should eq %q(<si><t span="8">foo</t></si>)
    end
  end

  describe "#xml_rich_si_element" do
    it "can write a rich si element" do
      writer = xml_test_factory()
      writer.xml_rich_si_element("foo")
      tagelement = writer.fh.try(&.buffer.to_s)

      tagelement.should eq %q(<si>foo</si>)
    end
  end
end

describe "#xml_number_element" do
  it "can write a number element" do
    writer = xml_test_factory()
    writer.xml_number_element(99, {"span" => "8"})
    tagelement = writer.fh.try(&.buffer.to_s)

    tagelement.should eq %q(<c span="8"><v>99</v></c>)
  end
end

describe "#xml_formula_element" do
  it "can write a formula element" do
    writer = xml_test_factory()
    writer.xml_formula_element("1+2", 3, {"span" => "8"})
    tagelement = writer.fh.try(&.buffer.to_s)

    tagelement.should eq %q(<c span="8"><f>1+2</f><v>3</v></c>)
  end
end

describe "#xml_inline_string" do
  it "can write inline string without whitespace" do
    writer = xml_test_factory()
    writer.xml_inline_string("test", false, {"span" => "8"})
    tagelement = writer.fh.try(&.buffer.to_s)

    tagelement.should eq %q(<c span="8" t="inlineStr"><is><t>test</t></is></c>)
  end

  it "can write inline string with whitespace preserved" do
    writer = xml_test_factory()
    writer.xml_inline_string("test", true, {"span" => "8"})
    tagelement = writer.fh.try(&.buffer.to_s)

    exp = %q(<c span="8" t="inlineStr"><is><t xml:space="preserve">test</t></is></c>)
    tagelement.should eq exp
  end
end

describe "#xml_rich_inline_string" do
  it "can write a rich inline string" do
    writer = xml_test_factory()
    writer.xml_rich_inline_string("test", {"span" => "8"})
    tagelement = writer.fh.try(&.buffer.to_s)

    tagelement.should eq %q(<c span="8" t="inlineStr"><is>test</is></c>)
  end
end

def xml_test_factory : XMLTest
  test = XMLTest.new
  test.set_xml_writer("testfile")
  test
end

class XMLTest < XMLWriter
end
