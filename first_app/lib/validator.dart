class Validator {
  static String? maxLength(v, int max) {
    final value = v.toString();
    if (value == null || value.length > max) {
      return "Количество символов не должно быть больше $max";
    }
    return null;
  }

  static String? minValue(v, int min) {
    final value = int.tryParse('${v}');
    print(value);
    if (value == null || value < min) {
      return "Значение не должно быть меньше $min";
    }
    return null;
  }
}
