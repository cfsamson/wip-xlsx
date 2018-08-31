require "./spec_helper.cr"

describe Workbook do
  it "takes a filename" do
    wb = Workbook.new("test.xlsx")
    wb.name.should eq "test.xlsx"
  end

  context "add_worksheet" do
    it "can create a worksheet" do
      wb = Workbook.new("test.xlsx")
      wb.add_worksheet("sheet1")

      sheet1 = wb.get_worksheet(0)
      sheet1.name.should eq "sheet1"
      typeof(sheet1).should eq Worksheet
    end

    it "can create worksheet without a given name" do
      wb = Workbook.new("test.xlsx")
      wb.add_worksheet
      sheet1 = wb.get_worksheet(0)

      sheet1.name.should eq "Sheet1"
      typeof(sheet1).should eq Worksheet
    end

    it " can create multiple unique worksheet without given name" do
      wb = Workbook.new("test.xlsx")
      sheet1 = wb.add_worksheet
      sheet2 = wb.add_worksheet
      sheet3 = wb.add_worksheet

      sheet1.name.should_not eq sheet2.name
      sheet1.name.should_not eq sheet3.name
      sheet2.name.should_not eq sheet3.name
    end

    it "returns the worksheet that gets added" do
      wb = Workbook.new("test.xlsx")
      sheet1 = wb.add_worksheet("sheet1")

      typeof(sheet1).should eq Worksheet
      sheet1.name.should eq "sheet1"
    end
  end

  context "get_worksheet" do
    it "can get a worksheet by name" do
      wb = Workbook.new("test.xlsx")
      sheet1 = wb.add_worksheet("sheet1")
      retrieved = wb.get_worksheet("sheet1")

      retrieved.name.should eq sheet1.name
    end

    it "raises an exception you access worksheet before it's added" do
      expect_raises(XlsxExceptions::NoWorksheetException) do
        wb = Workbook.new("test.xlsx")
        sheet1 = wb.get_worksheet(0)
      end
    end

    it "raises an exception if you try to access a worksheet by invalid index" do
      wb = Workbook.new("test.xlsx")
      sheet1 = wb.add_worksheet("sheet1")
      expect_raises(XlsxExceptions::NoWorksheetException) do
        wb.get_worksheet(1)
      end
    end

    it "raises an exception if you try to access a worksheet by invalid name" do
      wb = Workbook.new("test.xlsx")
      sheet1 = wb.add_worksheet("sheet1")
      expect_raises(XlsxExceptions::NoWorksheetException) do
        wb.get_worksheet("sheet2")
      end
    end
  end
end
