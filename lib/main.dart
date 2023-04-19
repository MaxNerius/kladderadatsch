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
  List<Note> _notes = [
    Note(title: "Henlo, world!"),
    Note(title: "Lorem ipsum"),
    Note(title: "Foo bar baz"),
  ];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void removeNote(Note note) {
    if (!_notes.contains(note)) return;
    _notes.remove(note);
    notifyListeners();
  }
}

class TodoCardRoute extends StatelessWidget {
  const TodoCardRoute({super.key, required this.note});
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content ?? 'Placeholder'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TodoCardDetailRoute(note: note)),
        ),
        leading: Consumer<NotesModel>(
          builder: (context, notesState, _) => TextButton(
            child: Icon(Icons.delete),
            onPressed: () => notesState.removeNote(note),
          ),
        ),
      ),
    );
  }
}

class TodoCardDetailRoute extends StatelessWidget {
  const TodoCardDetailRoute({super.key, required this.note});
  final Note note;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Placeholder(),
        ),
      ),
    );
  }
}

class DrawerRoute extends StatelessWidget {
  const DrawerRoute({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesModel>(
      builder: (context, notesState, _) => ListView(
        children: [
          for (var todo in notesState.notes)
            TodoCardRoute(note: todo),
        ],
      ),
    );
  }
}

class NoteCreationRoute extends StatelessWidget {
  const NoteCreationRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create new note')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Finish'),
          onPressed: () => Navigator.pop(context, Note(title: 'I come from the CreationRoute!')),
        ),
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

class Note {
  String title;
  String? content;

  Note({this.title = "TODO", this.content});
}
