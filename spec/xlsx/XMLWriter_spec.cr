require "./spec_helper.cr"

class XMLTest < XMLWriter

  def set_xml_writer(filename)
    super
  end
  
  def xml_declaration
    super
  end
end


describe XMLWriter do
  it "initializes without parameters" do
    writer = XMLWriter.new

    writer.should be_a(XMLWriter)
  end

  it "can set an xml_writer with a name" do
    writer = XMLTest.new
    writer.set_xml_writer("testfile")
    writer.xml_declaration
    fb = writer.fh.not_nil!
    puts fb.buffer
  end
  
end