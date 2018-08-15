
# Base class for XlsxWriter
class XMLWriter
  @fh : IO::FileDescriptor?

  def initialize
    @fh = nil
    @escapes = Regex.new %q("["&<>\n]")
    @internal_fh = false
  end

  # Set the writer filehandle directly. Mainly for testing.
  private def set_filehandle(filehandle)
    @fh = filehandle
    @internal_fh = false
  end

  # Set the XML writer filehandle for the object.
  private def set_xml_writer(filename : String)
    @internal_fh = true
    @fh = IO::FileDescriptor.new(filename)
  end

  private def set_xml_writer(file : IO::FileDescriptor)
    @internal_fh = false
    @fh = file
  end


end
