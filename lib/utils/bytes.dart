String formatBytes(int value) {
  if (value < 1024) {
    return '$value B';
  } else if (value < 1024 * 1024) {
    return '${(value / 1024).toStringAsFixed(2)} KB';
  } else if (value < 1024 * 1024 * 1024) {
    return '${(value / (1024 * 1024)).toStringAsFixed(2)} MB';
  } else {
    return '${(value / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
