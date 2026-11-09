String formatThousands(int value) => value.toString().replaceAllMapped(
  RegExp(r'(?<=\d)(?=(\d{3})+$)'),
  (_) => ' ',
);

String formatWeight(double kilograms) =>
    kilograms.toStringAsFixed(1).replaceAll('.', ',');
