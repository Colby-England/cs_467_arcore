class JulianDays {
  final double julianDay1970 = 2440587.50000;

  double getJulian(dtNow) {
    /* Start day is 4713 BC 01JAN00
  2440587.50000  <- From ^ 4713 BC 01JAN00 to epoch unix = 0 in epoch unix
  */
    var ms = (dtNow.toUtc()).millisecondsSinceEpoch;
    return julianDay1970 + (((ms / 1000).round()) / 86400);
  }
}
