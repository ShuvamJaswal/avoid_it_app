class Brain {
  int _totalPoints = 20;
  int get totalPoints {
    return _totalPoints;
  }

  void decreasePoint(int _points) {
    _totalPoints -= _points;
  }
}
