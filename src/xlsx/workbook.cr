require "./exceptions.cr"
include XlsxExceptions

# Main entry point for creating an Excel workbook
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
  # The workbook is initialized with no worksheets so to do anything
  # with the workbook you will have to add a *worksheet* first.
  # The *worksheet* is the main object interacting with the excel file.
  #
  #    wb = Workbook.new("myworkbook.xlsx")
  #    ws = wb.add_worksheet("mysheet")
  #
  #
  def initialize(@name)
    @worksheets = [] of Worksheet
  end

  # Gets a Array(Worksheet) by name, raises NoWorksheetException if
  # there are no worksheets
  def get_worksheet(name : String?)
    @worksheets.each do |ws|
      if ws.name == name
        return ws
      end
    end
    raise XlsxExceptions::NoWorksheetException.new
  end

  # Gets a Array(Worksheet) by index, raises NoWorksheetException if
  # there are no worksheets
  def get_worksheet(index : Int32)
    ws = @worksheets[index]?
    if ws.nil?
      raise XlsxExceptions::NoWorksheetException.new
    end
    ws
  end

  # Adds a worksheet with the given name (or default name if it isn't specified)
  # to the workbook.
  #
  # If you don't give it a name it will be given a unique name based
  # on the number of sheets added previously (Sheet1, Sheet2, ...)
  def add_worksheet(name : String)
    ws = Worksheet.new name
    @worksheets << ws
    ws
  end

  # ditto
  def add_worksheet
    sheet_no = @worksheets.size + 1
    ws = Worksheet.new "Sheet#{sheet_no}"
    @worksheets << ws
    ws
  end
end
