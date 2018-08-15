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

  it "can write xml declaration to buffer" do
    writer = XMLTest.new
    writer.set_xml_writer("testfile")
    writer.xml_declaration
    buffer = writer.fh.not_nil!.buffer.rewind
    xml_test = buffer.gets(14)
    
    xml_test.should eq "<?xml version="
  end
  
end