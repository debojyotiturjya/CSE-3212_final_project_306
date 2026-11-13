import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:final_project_debojyoti_64_g_306/constants.dart';
import 'package:final_project_debojyoti_64_g_306/movies/movie_details_page.dart';
import 'package:final_project_debojyoti_64_g_306/movies/movie_form_page.dart';
import 'package:final_project_debojyoti_64_g_306/widget/poster_image.dart';

// The movie catalog: a scrollable GridView of poster cards read live from Firestore.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FATFLIX",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        backgroundColor: kMaroon,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [
            // Profile header + Rickroll meter, read live from users/{uid}
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data();
                final name =
                    data == null
                        ? "FATFLIX user"
                        : "${data['firstName']} ${data['lastName']}";
                final email = FirebaseAuth.instance.currentUser?.email ?? "";
                final count = data?['rickrollCount'] ?? 0;
                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(color: kMaroon),
                      accountName: Text(name),
                      accountEmail: Text(email),
                      currentAccountPicture: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.music_note),
                      title: const Text("Rickroll meter"),
                      subtitle: const Text("Times you pressed Watch now"),
                      trailing: Text(
                        "$count",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kMaroon,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text("Movie catalog"),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: "Add movie",
        backgroundColor: kMaroon,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MovieFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No movies yet.\nTap the + button to add the first one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            // Fits as many columns as the screen allows (2 on phones, more on desktop).
            // On phones this behaves like crossAxisCount: 2.
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.68,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final movie = docs[index].data();
              final movieId = docs[index].id;
              return _MovieCard(movieId: movieId, movie: movie);
            },
          );
        },
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final String movieId;
  final Map<String, dynamic> movie;
  const _MovieCard({required this.movieId, required this.movie});

  @override
  Widget build(BuildContext context) {
    final title = (movie['title'] ?? '').toString();
    final genre = (movie['genre'] ?? '').toString();
    final year = (movie['releaseYear'] ?? '').toString();
    final posterUrl = (movie['posterUrl'] ?? '').toString();

    return Card(
      color: kPink,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      // InkWell = tappable area with the hand cursor + ripple.
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(movieId: movieId),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: PosterImage(url: posterUrl)),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "$genre • $year",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}