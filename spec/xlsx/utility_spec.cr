require "./spec_helper.cr"
include Utility

describe Utility do
  describe "#xl_rowcol_to_cell" do
    it "can convert a zero indexed row/col to xl string reference" do
      tests = [
        # row, col, A1 string
        {0, 0, "A1"},
        {0, 1, "B1"},
        {0, 2, "C1"},
        {0, 9, "J1"},
        {1, 0, "A2"},
        {2, 0, "A3"},
        {9, 0, "A10"},
        {1, 24, "Y2"},
        {7, 25, "Z8"},
        {9, 26, "AA10"},
        {1, 254, "IU2"},
        {1, 255, "IV2"},
        {1, 256, "IW2"},
        {0, 16383, "XFD1"},
        {1048576, 16384, "XFE1048577"},
      ]

      tests.each do |t|
        xl_rowcol_to_cell(t[0], t[1]).should eq t[2]
      end
    end
  end

  describe "#xl_col_to_name" do
    it "can convert a colum index to column string" do
      cases = [
        {0, false, "A"},
        {1, false, "B"},
        {25, false, "Z"},
        {3, true, "$D"},
        {7, true, "$H"},
        {26, false, "AA"},
        {30, true, "$AE"},
        {54, false, "BC"},
      ]

      cases.each do |item|
        num = item[0]
        col_abs = item[1]
        exp = item[2]
        xl_col_to_name(num, col_abs).should eq exp
      end
    end
  end

  describe "#xl_rowcol_to_cell_fast" do
    it "can do fast lookup by caching column names" do
      tests = [
        # row, col, A1 string
        {0, 0, "A1"},
        {0, 1, "B1"},
        {0, 2, "C1"},
        {0, 9, "J1"},
        {1, 0, "A2"},
        {2, 0, "A3"},
        {9, 0, "A10"},
        {1, 24, "Y2"},
        {7, 25, "Z8"},
        {9, 26, "AA10"},
        {1, 254, "IU2"},
        {1, 255, "IV2"},
        {1, 256, "IW2"},
        {0, 16383, "XFD1"},
        {1048576, 16384, "XFE1048577"},
      ]

      tests.each do |test|
        row = test[0]
        col = test[1]
        exp = test[2]
        xl_rowcol_to_cell_fast(row, col).should eq exp
      end
    end
  end
  describe "#xl_cell_to_rowcol" do
    it "can convert a rowcol string reference to a RowCol object" do
      tests = [
        {"A1", RowCol.new(0, 0)},
        {"$A1", RowCol.new(0, 0)},
        {"A$1", RowCol.new(0, 0)},
        {"$A$1", RowCol.new(0, 0)},
        {"B2", RowCol.new(1, 1)},
        {"AA50", RowCol.new(49, 26)},
        {"Z10", RowCol.new(9, 25)},
      ]

      tests.each do |test, expected|
        got = xl_cell_to_rowcol(test)

        got.should eq expected
      end
    end

    it "throws exception if an invalid string is passed" do
      tests = ["ZYS", "foo", "A?1xx", "A:?xys"]
      tests.each do |test|
        expect_raises Exception do
          xl_cell_to_rowcol test
        end
      end
    end
  end
  describe "#xl_cell_to_rowcol_abs" do
    it "converts an absolute reference correctly" do
      tests = [
        {"A1", {0, 0, false, false}},
        {"A$1", {0, 0, true, false}},
        {"$A1", {0, 0, false, true}},
        {"$A$1", {0, 0, true, true}},
      ]

      tests.each do |test|
        got = xl_cell_to_rowcol_abs(test[0])
        exp = test[1]

        got.should eq exp
      end
    end
  end
end
