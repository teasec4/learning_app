import 'package:flutter/material.dart';
import 'package:learning_app/presentation/pages/game/widgets/study_mode_tile.dart';
import 'package:learning_app/presentation/view_models/game_view_model/game_view_model.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameViewModel viewModel;

  @override
  void initState() {
    super.initState();
    // Инициализируем данные один раз при создании виджета
    viewModel = GameViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Study")),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: viewModel.mockData.length,
          itemBuilder: (context, index) {
            return StudyModeTile(
              studyModeName: viewModel.mockData[index].title,
              isActive: viewModel.mockData[index].isActive,
              onTap: () {
                setState(() {
                  viewModel.toggleActive(index);
                });
              },
            );
          },
        ),
      ),
    );
  }
}
