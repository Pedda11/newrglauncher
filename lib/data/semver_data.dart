class SemverData {
  final int major;
  final int minor;
  final int patch;

  SemverData(this.major, this.minor, this.patch);

  factory SemverData.parse(String input) {
    /// Accepts "1.2.3" and ignores extras like "+123" or "-beta"
    final cleaned = input.split('+').first.split('-').first.trim();
    final parts = cleaned.split('.');
    if (parts.length < 2) {
      throw FormatException('Invalid semver: $input');
    }

    final major = int.tryParse(parts[0]) ?? 0;
    final minor = int.tryParse(parts[1]) ?? 0;
    final patch = parts.length >= 3 ? (int.tryParse(parts[2]) ?? 0) : 0;
    return SemverData(major, minor, patch);
  }

  int compareTo(SemverData other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }
}
