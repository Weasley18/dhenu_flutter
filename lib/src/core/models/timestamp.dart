/// Custom timestamp class to replace Firebase's Timestamp
class Timestamp {
  final int seconds;
  final int nanoseconds;

  const Timestamp(this.seconds, this.nanoseconds);

  /// Creates a timestamp from a [DateTime] object
  factory Timestamp.fromDateTime(DateTime dateTime) {
    final seconds = dateTime.millisecondsSinceEpoch ~/ 1000;
    final nanoseconds = (dateTime.microsecondsSinceEpoch % 1000000) * 1000;
    return Timestamp(seconds, nanoseconds);
  }

  /// Creates a timestamp from milliseconds since epoch
  factory Timestamp.fromMillisecondsSinceEpoch(int milliseconds) {
    final seconds = milliseconds ~/ 1000;
    final nanoseconds = (milliseconds % 1000) * 1000000;
    return Timestamp(seconds, nanoseconds);
  }

  /// Creates a timestamp representing the current time
  factory Timestamp.now() {
    return Timestamp.fromDateTime(DateTime.now());
  }

  /// Converts this timestamp to a [DateTime] object
  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000 + (nanoseconds / 1000000).floor(),
    );
  }

  /// Returns milliseconds since epoch for this timestamp
  int toMillisecondsSinceEpoch() {
    return seconds * 1000 + (nanoseconds / 1000000).floor();
  }

  @override
  bool operator ==(Object other) {
    return other is Timestamp &&
        other.seconds == seconds &&
        other.nanoseconds == nanoseconds;
  }

  @override
  int get hashCode => Object.hash(seconds, nanoseconds);

  @override
  String toString() => 'Timestamp(seconds=$seconds, nanoseconds=$nanoseconds)';
}
