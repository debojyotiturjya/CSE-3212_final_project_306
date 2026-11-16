import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:final_project_debojyoti_64_g_306/constants.dart';
import 'package:final_project_debojyoti_64_g_306/movies/movie_form_page.dart';
import 'package:final_project_debojyoti_64_g_306/movies/rickroll_page.dart';
import 'package:final_project_debojyoti_64_g_306/utils/validators.dart';
import 'package:final_project_debojyoti_64_g_306/widget/input_field.dart';
import 'package:final_project_debojyoti_64_g_306/widget/poster_image.dart';

// Movie details + Watch now + reviews (add / edit / delete your own).
class MovieDetailPage extends StatefulWidget {
  final String movieId;
  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final _reviewFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  DocumentReference<Map<String, dynamic>> get _movieRef =>
      FirebaseFirestore.instance.collection('movies').doc(widget.movieId);

  @override
  void dispose() {
    _reviewController.dispose();
    _editController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // ---------- Watch now (the Rickroll surprise) ----------
  Future<void> _watchNow(String title) async {
    // Open the surprise page IMMEDIATELY. Browsers only allow sound shortly
    // after a tap, so nothing slow may happen before this.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RickrollPage(movieTitle: title),
      ),
    );

    // Rickroll meter +1 (UPDATE on the user's own profile document)
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .update({'rickrollCount': FieldValue.increment(1)})
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      // The surprise still happens even if the counter could not be updated.
    }
  }

  // ---------- generic "Are you sure?" dialog ----------
  void _confirmDelete(String title, Future<void> Function() onYes) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(title),
          contentPadding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await onYes();
                  },
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ---------- DELETE movie ----------
  Future<void> _deleteMovie() async {
    try {
      await _movieRef.delete();
      if (!mounted) return;
      Navigator.pop(context); // back to the catalog
    } catch (e) {
      _showMessage("Could not delete: $e");
    }
  }


  // ---------- reviews: CREATE ----------
  Future<void> _addReview() async {
    if (!_reviewFormKey.currentState!.validate()) return;
    try {
      final profile =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      final name = profile.data()?['firstName'] ?? 'Anonymous';
      await _movieRef.collection('reviews').add({
        'text': _reviewController.text.trim(),
        'userId': _uid,
        'userName': name,
      });
      _reviewController.clear();
    } catch (e) {
      _showMessage("Could not post review: $e");
    }
  }

  // ---------- reviews: UPDATE ----------
  void _editReview(String reviewId, String oldText) {
    _editController.text = oldText;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text("Edit review"),
          contentPadding: const EdgeInsets.all(20),
          children: [
            Form(
              key: _editFormKey,
              child: InputField(
                controller: _editController,
                keyboardType: TextInputType.text,
                labelText: "Your review",
                hintText: "Edit your review",
                validator: (value) => Validators.review(value),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!_editFormKey.currentState!.validate()) return;
                try {
                  await _movieRef.collection('reviews').doc(reviewId).update({
                    'text': _editController.text.trim(),
                  });
                } catch (e) {
                  _showMessage("Could not update review: $e");
                }
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // ---------- reviews: DELETE ----------
  Future<void> _deleteReview(String reviewId) async {
    try {
      await _movieRef.collection('reviews').doc(reviewId).delete();
    } catch (e) {
      _showMessage("Could not delete review: $e");
    }
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kPrimary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reviews",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Form(
          key: _reviewFormKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InputField(
                  controller: _reviewController,
                  keyboardType: TextInputType.text,
                  labelText: "Write a review",
                  hintText: "What did you think?",
                  prefixIcon: const Icon(Icons.rate_review),
                  validator: (value) => Validators.review(value),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: _addReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Post"),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _movieRef.collection('reviews').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final reviews = snapshot.data!.docs;
            if (reviews.isEmpty) {
              return const Text("No reviews yet. Be the first!");
            }
            return Column(
              children: [
                for (final doc in reviews)
                  Card(
                    color: kCard,
                    child: ListTile(
                      title: Text(
                        (doc.data()['userName'] ?? 'Anonymous').toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text((doc.data()['text'] ?? '').toString()),
                      // Only the author sees the edit / delete buttons.
                      trailing:
                          doc.data()['userId'] == _uid
                              ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: "Edit",
                                    onPressed:
                                        () => _editReview(
                                          doc.id,
                                          (doc.data()['text'] ?? '').toString(),
                                        ),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    tooltip: "Delete",
                                    onPressed:
                                        () => _confirmDelete(
                                          "Delete this review?",
                                          () => _deleteReview(doc.id),
                                        ),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              )
                              : null,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listening to the movie document means edits show up instantly.
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _movieRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(backgroundColor: kAppBar, foregroundColor: Colors.white),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(backgroundColor: kAppBar, foregroundColor: Colors.white),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final movie = snapshot.data!.data();
        if (movie == null) {
          return Scaffold(
            appBar: AppBar(backgroundColor: kAppBar, foregroundColor: Colors.white),
            body: const Center(child: Text("This movie was removed.")),
          );
        }

        final title = (movie['title'] ?? '').toString();
        final isOwner = movie['createdBy'] == _uid;

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: kAppBar,
            foregroundColor: Colors.white,
            actions: [
              // Only the person who added the movie can edit or delete it.
              if (isOwner)
                IconButton(
                  tooltip: "Edit movie",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieFormPage(
                          movieId: widget.movieId,
                          movie: movie,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              if (isOwner)
                IconButton(
                  tooltip: "Delete movie",
                  onPressed: () => _confirmDelete("Delete this movie?", _deleteMovie),
                  icon: const Icon(Icons.delete),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PosterImage(
                  url: (movie['posterUrl'] ?? '').toString(),
                  height: 320,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: kPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _infoRow(Icons.category, "Genre", (movie['genre'] ?? '').toString()),
                      _infoRow(Icons.calendar_today, "Release year", (movie['releaseYear'] ?? '').toString()),
                      _infoRow(Icons.business, "Producer", (movie['producer'] ?? '').toString()),
                      const SizedBox(height: 10),
                      const Text(
                        "Synopsis",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (movie['synopsis'] ?? '').toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _watchNow(title),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Watch now"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            foregroundColor: Colors.white,
                            fixedSize: const Size(200, 50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      _buildReviews(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}