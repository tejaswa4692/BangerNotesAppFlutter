import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/note_tile.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> notes = [];
  final TextEditingController controller = TextEditingController();

  void addNote() {
    if (controller.text.isEmpty) return;

    setState(() {
      notes.add(
        Note(title: controller.text), // ✅ fixed
      );
      controller.clear();
    });
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Note"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter title"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                addNote();
                Navigator.pop(context);
              },
              child: const Text("Add Note"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose(); // ✅ good practice
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tejaswas Epix Notes")),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteTile(
            note: notes[index],
            onDelete: () => deleteNote(index),
            onTap: () async {
              final updatedContent = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: notes[index]),
                ),
              );

              if (updatedContent != null) {
                setState(() {
                  notes[index].content = updatedContent; // ✅ fixed
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}