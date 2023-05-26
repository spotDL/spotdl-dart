import 'frame_buffer.dart';

class Frame {
  var _buffer = FrameBuffer();

  int get length => _buffer.length;

  List<int> get bytes => _buffer.bytes;

  /// create a new ID3 text frame
  ///
  /// ### Note
  /// - see [ID3 specification](https://web.archive.org/web/20220127134449/https://id3.org/id3v2.3.0)
  Frame.textFrame(String id, String text) {
    // 1. Header
    //    $xx xx xx xx xx xx xx xx xx xx
    generateFrameHeader(id, text.codeUnits.length);

    // 2. Text encoding
    //    $xx                                   (0x08 for Unicode)
    _buffer.addBytes([0x03]);

    // 3. Information
    //    <text string according to encoding>
    _buffer.addUTF8FrameText(text);
  }

  /// generate frame header
  void generateFrameHeader(String id, int dataSize) {
    // 1. Frame ID
    //    $xx xx xx xx          (four characters)
    if (id.length != 4) {
      throw Exception('Frame ID must be 4 characters long');
    }

    _buffer.addANSIFrameHeader(id);

    // 2. Size
    //    $xx xx xx xx          (4 bytes, leading bit is zero inserted)
    _buffer.addBytes(FrameBufferUtils.getEncodedSize(dataSize));

    // 3. Flags
    //    %abc00000 %ijk00000   (set to 0x00 0x00 for simplicity)
    _buffer.addBytes([0x00, 0x00]);
  }
}
