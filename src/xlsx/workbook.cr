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
  # remember postfix ".xlsx" if you want the file to show as an excel file
  # on you file system
  def initialize(@name)
    @worksheets = [] of Worksheet
  end

  # TODO: Check if this should be get_worksheet() so a index check could be implementd
  # and a proper error message can be given if user tries to access non-existent sheet
  #
  # Gets a Array(Worksheet), raises NoWorksheetException if there are no worksheets
  def get_worksheet(name : String?)
    @worksheets.each do |ws|
      if ws.name == name
        return ws
      end
    end
    raise XlsxExceptions::NoWorksheetException.new
  end

  def get_worksheet(index : Int32)
    ws = @worksheets[index]?
    if ws.nil?
      raise XlsxExceptions::NoWorksheetException.new
    end
    ws
  end

  # Adds a worksheet with the given name to the workbook
  # the workbook is initialized with no worksheets so to add data you
  # will have to add a worksheet.
  def add_worksheet(name : String = "default")
    ws : Worksheet
    if(name == "default")
      sheet_no = @worksheets.size + 1
       ws = Worksheet.new "Sheet#{sheet_no}"
    else
    ws = Worksheet.new name
    end
    @worksheets << ws
    ws
  end
end
