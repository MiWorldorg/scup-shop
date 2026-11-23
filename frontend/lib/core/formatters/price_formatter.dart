class PriceFormatter {
  PriceFormatter._();

  static String amount(int value) {
    final digits = value.abs().toString();
    final grouped = digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return value < 0 ? '-$grouped' : grouped;
  }
}
