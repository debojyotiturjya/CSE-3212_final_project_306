import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:final_project_debojyoti_64_g_306/constants.dart';
import 'package:final_project_debojyoti_64_g_306/utils/validators.dart';
import 'package:final_project_debojyoti_64_g_306/widget/input_field.dart';

// One form used for BOTH:
//   Create -> MovieFormPage()
//   Update -> MovieFormPage(movieId: id, movie: existingData)
class MovieFormPage extends StatefulWidget {
  final String? movieId;
  final Map<String, dynamic>? movie;
  const MovieFormPage({super.key, this.movieId, this.movie});

  @override
  State<MovieFormPage> createState() => _MovieFormPageState();
}

class _MovieFormPageState extends State<MovieFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _producerController = TextEditingController();
  final TextEditingController _posterController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  bool _isLoading = false;

  bool get _isEdit => widget.movieId != null;

  @override
  void initState() {
    super.initState();
    // When editing, pre-fill the fields with the current values.
    final m = widget.movie;
    if (m != null) {
      _titleController.text = (m['title'] ?? '').toString();
      _genreController.text = (m['genre'] ?? '').toString();
      _yearController.text = (m['releaseYear'] ?? '').toString();
      _producerController.text = (m['producer'] ?? '').toString();
      _posterController.text = (m['posterUrl'] ?? '').toString();
      _synopsisController.text = (m['synopsis'] ?? '').toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _yearController.dispose();
    _producerController.dispose();
    _posterController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _save() async {
    setState(() {
      _isLoading = true;
    });
    final data = {
      'title': _titleController.text.trim(),
      'genre': _genreController.text.trim(),
      'releaseYear': int.parse(_yearController.text.trim()),
      'producer': _producerController.text.trim(),
      'posterUrl': _posterController.text.trim(),
      'synopsis': _synopsisController.text.trim(),
    };
    try {
      final movies = FirebaseFirestore.instance.collection('movies');
      if (_isEdit) {
        // UPDATE
        await movies
            .doc(widget.movieId)
            .update(data)
            .timeout(const Duration(seconds: 20));
      } else {
        // CREATE (remember who added it, so only they can edit/delete it)
        await movies
            .add({...data, 'createdBy': FirebaseAuth.instance.currentUser!.uid})
            .timeout(const Duration(seconds: 20));
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showMessage("Could not save the movie: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? "Edit Movie" : "Add Movie"),
        backgroundColor: kAppBar,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Card(
              color: kCard,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputField(
                        controller: _titleController,
                        keyboardType: TextInputType.text,
                        labelText: "Title",
                        hintText: "Movie title",
                        prefixIcon: const Icon(Icons.movie),
                        validator: (value) => Validators.title(value),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _genreController,
                        keyboardType: TextInputType.text,
                        labelText: "Genre",
                        hintText: "Action, Comedy ...",
                        prefixIcon: const Icon(Icons.category),
                        validator: (value) => Validators.genre(value),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        labelText: "Release year",
                        hintText: "e.g. 2019",
                        prefixIcon: const Icon(Icons.calendar_today),
                        validator: (value) => Validators.releaseYear(value),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _producerController,
                        keyboardType: TextInputType.text,
                        labelText: "Producer",
                        hintText: "Who produced it?",
                        prefixIcon: const Icon(Icons.business),
                        validator: (value) => Validators.producer(value),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _posterController,
                        keyboardType: TextInputType.url,
                        labelText: "Poster link",
                        hintText: "Paste an image link (https://...)",
                        prefixIcon: const Icon(Icons.image),
                        validator: (value) => Validators.posterUrl(value),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: _synopsisController,
                        keyboardType: TextInputType.multiline,
                        labelText: "Short synopsis",
                        hintText: "What is it about?",
                        prefixIcon: const Icon(Icons.notes),
                        maxLines: 4,
                        validator: (value) => Validators.synopsis(value),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _save();
                                } else {
                                  _showMessage(
                                    "Please fix the fields marked in red.",
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(180, 45),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_isEdit ? "Save changes" : "Add movie"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}