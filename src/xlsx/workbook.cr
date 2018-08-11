require "./exceptions.cr"
include XlsxExceptions

# Main entry point for creating an Exel workbook
# Basic usage:
#
#    wb = Workbook.new("myworkbook.xlsx")
#    ws = wb.add_worksheet("sheet1")
#    ws.cells(1,1).value = "This is my workbook"
#    wb.save()
#
#
class Workbook
  property name : String
  @worksheets : Array(Worksheet)

  # Create a new workbook with the given name
  # remember postfix ".xlsx" if you want the file to show as an excel file
  # on you file system
  def initialize(@name)
    @worksheets = [] of Worksheet
  end

  # TODO: Check if this should be get_worksheet() so a index check could be implementd
  # and a proper error message can be given if user tries to access non-existent sheet
  #
  # Gets a Array(Worksheet), raises NoWork
  def worksheets
    if (@worksheets.size < 1)
      raise XlsxExceptions::NoWorksheetException.new
    end
    @worksheets
  end

  # Adds a worksheet with the given name to the workbook
  # the workbook is initialized with no worksheets so to add data you
  # will have to add a worksheet.
  def add_worksheet(@name : String = "data")
    ws = Worksheet.new @name
    @worksheets << ws
    ws
  end
end
