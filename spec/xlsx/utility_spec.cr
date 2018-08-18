require "./spec_helper.cr"
include Utility

describe Utility do 
  it "can convert a colum index to column string" do
    cases = [
      { {0, false}, "A"},
      { {1, false}, "B"},
      { {25, false}, "Z"},
      { {3, true}, "$D"},
      { {7, true}, "$H"},
      { {26, false}, "AA"},
      { {30, true}, "$AE"},
      { {54, false}, "BC"},
    ]

    cases.each do |item|
      num = item[0][0]
      col_abs = item[0][1]
      exp = item[1]
      xl_col_to_name(num,col_abs).should eq exp
    end
  end
end
