class CaptureValidators {
  static final RegExp _titleRegExp = RegExp(
    r'^.*\S.*$',
  );

  static isValidTitle(String title) {
    print(_titleRegExp.hasMatch(title));
    return _titleRegExp.hasMatch(title);
  }
}
