import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Note {
  String title;
  String content;

  Note({this.title = "TODO", this.content = "Foo bar"});
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
          MaterialPageRoute(
              builder: (context) => TodoCardDetailRoute(note: note)),
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
    return Scaffold(
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
          if (notesState.notes.isEmpty)
            Center(child: const Text('Currently, there aren\'t any notes')),
          for (var todo in notesState.notes) TodoCardRoute(note: todo),
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
        child: NoteEditForm(),
      ),
    );
  }
}

class NoteEditForm extends StatefulWidget {
  const NoteEditForm({super.key});

  @override
  NoteEditFormState createState() => NoteEditFormState();
}

class NoteEditFormState extends State<NoteEditForm> {
  final _formKey = GlobalKey<FormState>();
  var newNote = Note();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title:'),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text.';
              }
              return null;
            },
            onSaved: (val) => setState(() => newNote.title = val ?? 'foo'),
          ),
          Padding(padding: EdgeInsets.all(20)),
          Text('Content:'),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text.';
              }
              return null;
            },
            onSaved: (val) => setState(() => newNote.content = val ?? 'bar'),
          ),
          ElevatedButton(
            onPressed: () {
              var formData = _formKey.currentState!;
              formData.save();
              if (formData.validate()) {
                Navigator.pop(context, newNote);
              }
            },
            child: const Text('Finished'),
          ),
        ],
      ),
    );
  }
}
