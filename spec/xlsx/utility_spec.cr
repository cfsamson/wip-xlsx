require "./spec_helper.cr"
include Utility

describe Utility do 

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
          xl_rowcol_to_cell(t[0],t[1]).should eq t[2]
        end
  end

  it "can convert a colum index to column string" do
    cases = [
      { 0, false, "A"},
      { 1, false, "B"},
      { 25, false, "Z"},
      { 3, true, "$D"},
      { 7, true, "$H"},
      { 26, false, "AA"},
      { 30, true, "$AE"},
      { 54, false, "BC"},
    ]

    cases.each do |item|
      num = item[0]
      col_abs = item[1]
      exp = item[2]
      xl_col_to_name(num,col_abs).should eq exp
    end
  end
end
