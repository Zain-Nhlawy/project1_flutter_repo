enum MessageType {
  text,
  image,
  file,
  audio;

  static MessageType fromString(String? typeStr) {
    switch (typeStr?.toUpperCase()) {
      case 'IMAGE':
        return MessageType.image;
      case 'FILE':
        return MessageType.file;
      case 'AUDIO':
        return MessageType.audio;
      case 'TEXT':
      default:
        return MessageType.text;
    }
  }

  String toJson() {
    switch (this) {
      case MessageType.image:
        return 'IMAGE';
      case MessageType.file:
        return 'FILE';
      case MessageType.audio:
        return 'AUDIO';
      case MessageType.text:
        return 'TEXT';
    }
  }
}
