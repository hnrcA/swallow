enum MessageEnum {
  text('text'),
  picture('picture'),
  video('video');

  const MessageEnum(this.type);
  final String type;
}

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'text':
        return MessageEnum.text;
      case 'picture':
        return MessageEnum.picture;
      case 'video':
        return MessageEnum.video;
      default:
        return MessageEnum.text;
    }
  }
}