enum Codecs {
  OPUS('opus'),
  SPEEX('speex'),
  PCMU('PCMU'),
  PCMA('PCMA'),
  GSM('GSM'),
  G722('G722'),
  ILBC('iLBC'),
  ISAC('iSAC'),
  L16('L16');

  final String value;

  const Codecs(this.value);
}
