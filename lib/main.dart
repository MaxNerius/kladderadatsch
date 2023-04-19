import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';

void main() {
  runApp(const Kladderadatsch());
}

class Kladderadatsch extends StatelessWidget {
  const Kladderadatsch({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesModel(),
      child: MaterialApp(
        title: 'kladderadatsch',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePageController(),
      ),
    );
  }
}

class HomePageController extends StatelessWidget {
  const HomePageController({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesModel>(builder: (context, notesState, _) =>
      Scaffold(
        appBar: AppBar(
          title: const Text("Kladderadatsch -- Inbox"),
        ),
        body: DrawerRoute(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Note res = await _navigateNoteCreationRoute(context);
            notesState.addNote(res);
          },
          tooltip: "Add a new note",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<Note> _navigateNoteCreationRoute(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (contex) => NoteCreationRoute()),
    );
    return result;
  }
}

