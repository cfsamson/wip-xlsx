module XlsxExceptions
  class NoWorksheetException < Exception
    def initialize(message = "Workbook has no worksheets. add_worksheet() first.")
      super(message)
    end
  end
  class XMLException < Exception
    def initialize(message = "Error creating XML file")
      super(message)
    end
  end
end
