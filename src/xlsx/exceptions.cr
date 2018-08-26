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

  class CellReferenceParseException < Exception
    def initialize(message = "Invalid cell cell reference string, should be like \"A1\"")
      super(message)
    end
  end
end
