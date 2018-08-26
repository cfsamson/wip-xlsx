require "./exceptions.cr"

module Utility
  private COL_NAMES   = {} of Int32 => String
  private RANGE_PARTS = Regex.new(%q((\$?)([A-Z]{1,3})(\$?)(\d+)))

  # Represents a zero indexed row and column coordinates in the excel cheet.
  #    RowCol.new(0,0) # => "A1"
  #    RowCol.new(1,1) # => "B2"
  #
  record RowCol, row : Int32, col : Int32

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
    col_str = xl_col_to_name(col, col_abs)

    return "#{col_str}#{row_abs}#{row}"
  end

  # Convert a zero indexed column cell reference to a string.
  #
  # *col* the cell's column. he cell column. *col_abs* Optional flag to
  # make the column absolute.

  #    xl_col_to_name(26)
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

  # Optimized version of the xl_rowcol_to_cell function. Only used internally.
  #
  # *row* is the cell row. *col* is the cell column
  #
  #    xl_rowcol_to_cell_fast(2,2) # => "B2"
  #
  # TODO: Consider making protected?
  def xl_rowcol_to_cell_fast(row, col)
    cached_col = COL_NAMES[col]?

    if cached_col
      col_str = cached_col
    else
      col_str = xl_col_to_name(col)
      COL_NAMES[col] = col_str
    end
    "#{col_str}#{row + 1}"
  end

  # Convert a cell reference in A1 notation to a zero indexed row and column.
  # *cell_str*  is an A1 style string (A1, B1, A2 etc)
  #
  # TODO: a string like "A1xx" passes since the start of the stringis a 
  # valid match. This is an edge but we should still consider catching it
  def xl_cell_to_rowcell(cell_str) : RowCol

    # if the string is empty or whitespace, we just return reference to "A1"
    return RowCol.new(0, 0) if cell_str.empty?
    match = RANGE_PARTS.match(cell_str)

    # if no match at all we throw an error
    raise XlsxExceptions::CellReferenceParseException.new if match.nil?

    begin
      col_str = match[2]
      row_str = match[4]

      # convert base 26 columnd string to number
      expon = 0
      col = 0
      col_str.reverse.each_char do |chr|
        col += (chr.ord - 'A'.ord + 1) * (26 ** expon)
        expon += 1
      end

      # convert 1-base index to 0-base index
      row = row_str.to_i32 - 1
      col -= 1

      return RowCol.new(row, col)
    rescue exception
      if typeof(exception) == IndexError
        raise XlsxExceptions::CellReferenceParseException.new
      end
      raise exception
    end
  end
end
