class GameViewModel{
  List<MockStudyModeTile> _mockData;
  GameViewModel() : _mockData = [] {
    _mockData = _generateMockTiles(6);
  }
  
  List<MockStudyModeTile> get mockData => _mockData;
  
  List<MockStudyModeTile> _generateMockTiles(int count) {
    return List.generate(count, (index) => MockStudyModeTile(title: 'mode nomber ${index}', isActive: false));
  }
  
  void toggleActive(int index) {
    _mockData[index].isActive = !_mockData[index].isActive;
  }
  
}


class MockStudyModeTile {
  final String title;
  bool isActive;

  MockStudyModeTile({required this.title, required this.isActive});

}