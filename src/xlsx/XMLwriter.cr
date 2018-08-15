
# Base class for XlsxWriter
struct FileBuffer
  property name : String
  property buffer : IO::Memory 

  def initialize(@name, @buffer = IO::Memory.new)
    @buffer.set_encoding("UTF-8")
  end
end
class XMLWriter
  getter fh : FileBuffer?

  def initialize
    @fh = nil
    @escapes = Regex.new %q(["&<>\n])
    @internal_fh = false
  end

  # Set the writer filehandle directly. Mainly for testing.
  private def set_filehandle(filehandle)
    @fh = filehandle
    @internal_fh = false
  end

  # Set the XML writer filehandle for the object.
  private def set_xml_writer(filename : String)
    if (@fh.nil?)
      @internal_fh = true
      @fh = FileBuffer.new(filename)
    end
  end

  private def set_xml_writer(file : IO::FileDescriptor)
    @internal_fh = false
    @fh = file
  end

  # Close the XML filehandle if we created it.
  private def close
    @fh.buffer.close if @internal_fh
  end

  # Write the XML declaration.
  private def xml_declaration
    @fh.not_nil!.buffer << %(<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n)
  end
end
