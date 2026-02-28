class CirclePositionData {
  final double topPosition;
  final double rightPosition;
  final double size;
  final double bottomPosition;
  final double leftPosition;

  CirclePositionData({
    required this.topPosition,
    required this.rightPosition,
    required this.size,
    required this.bottomPosition,
    required this.leftPosition,
  });

  factory CirclePositionData.top({
    required double topPosition,
    required double rightPosition,
    required double size,
  }) {
    return CirclePositionData(
      topPosition: topPosition,
      rightPosition: rightPosition,
      size: size,
      bottomPosition: 0,
      leftPosition: 0,
    );
  }

  factory CirclePositionData.bottom({
    required double bottomPosition,
    required double leftPosition,
    required double size,
  }) {
    return CirclePositionData(
      topPosition: 0,
      rightPosition: 0,
      size: size,
      bottomPosition: bottomPosition,
      leftPosition: leftPosition,
    );
  }
}
