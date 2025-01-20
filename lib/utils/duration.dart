String formatDuration(Duration duration) {
  return duration.toString().split('.')[0].split(':').skip(1).join(':');
}
