require "./spec_helper.cr"

describe XMLWriter do
  it "initializes without parameters" do
    writer = XMLWriter.new

    writer.should be_a(XMLWriter)
  end
  
end