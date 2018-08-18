module Utility
  # Convert a zero indexed row and column cell reference to a A1 style string.
  #
  # *row* is the cell row. *col* is the cell column. *row_abs*
  # optional flag to make the row absolute, like "B$3" in excel.
  # *col_abs* optional flag to make the column absolute like $B3 in excel.
  # ```
  # xl_row_to_cell(2, 2, true, false) # => "B$2"
  # ```
  def xl_rowcol_to_cell(row : Int32, col : Int32, row_abs = false, col_abs = false) : String
    row += 1 # need base 1 index
    row_abs = row_abs ? "$" : ""
    col_str = xl_col_to_name(col, cl_abs)
  end

  # Convert a zero indexed column cell reference to a string.
  #
  # *col* the cell's column. he cell column. *col_abs* Optional flag to
  # make the column absolute.
  #
  # ```text
  # Returns "AA"
  # ```
  def xl_col_to_name(col_num : Int32, col_abs = false)
    col_num += 1
    col_str = ""
    col_abs = col_abs ? "$" : ""

    while col_num > 0
      remainder = col_num % 26
      if remainder == 0
        remainder = 26
      end

      # convert the remainder to a character
      col_letter = ('A'.ord + remainder - 1).chr

      # Sett the letters in the richt order, from right to left
      col_str = "#{col_letter}#{col_str}"

      # Get the next order of magnitude
      col_num = ((col_num - 1) / 26).to_i32
    end
    "#{col_abs}#{col_str}"
  end
end
