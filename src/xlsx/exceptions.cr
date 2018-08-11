 module XlsxExceptions

  class NoWorksheetException < Exception
    def initialize (message = "Workbook has no worksheets. add_worksheet() first.")
      super(message)
    end
  end
end