import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class NotesModel extends ChangeNotifier {
  List<Note> notes = [
    Note(title: "Henlo, world!"),
    Note(title: "Lorem ipsum"),
    Note(title: "Foo bar baz"),
  ];
}

class TodoCardView extends StatelessWidget {
  const TodoCardView({super.key, required this.note});
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content ?? 'Placeholder'),
        onTap: () => print('TODO: Launch view with note details'),
        leading: TextButton(
          child: Icon(Icons.delete),
          onPressed: () => print('TODO: implement deletion of notes'),
        ),
      ),
    );
  }
}

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<NotesModel>();

    return Container(
      child: ListView(
        children: [
          for (var todo in appState.notes)
            TodoCardView(note: todo),
        ],
      ),
    );
  }
}

class HomePageController extends StatelessWidget {
  const HomePageController({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kladderadatsch -- Inbox"),
      ),
      body: DrawerView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("TODO: launch note creation page"),
        tooltip: "Add a new note",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Note {
  String title;
  String? content;

  Note({this.title = "TODO", this.content});
}
