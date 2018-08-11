require "./spec_helper.cr"

describe Workbook do 

  it "takes a filename" do
    wb = Workbook.new("test.xlsx")
    wb.name.should eq "test.xlsx"
  end

  it "can create a worksheet" do
    wb = Workbook.new("test.xlsx")
    wb.add_worksheet("sheet1")

    sheet1 = wb.worksheets[0]
    sheet1.name.should eq "sheet1"
    typeof(sheet1).should eq Worksheet
  end
  
  it "can create ws without a given name" do
    wb = Workbook.new("test.xlsx")
    wb.add_worksheet
    sheet1 = wb.worksheets[0]
    
    sheet1.name.should eq "data"
    typeof(sheet1).should eq Worksheet
  end

  it "returns the worksheet that gets added" do
    wb = Workbook.new("test.xlsx")
    sheet1 = wb.add_worksheet("sheet1")

    typeof(sheet1).should eq Worksheet
    sheet1.name.should eq "sheet1"
  end

  it "raises an exception you access worksheet before it's added" do
    expect_raises(XlsxExceptions::NoWorksheetException) do
      wb = Workbook.new("test.xlsx")
      sheet1 = wb.worksheets[0]
    end
  end
  
end


