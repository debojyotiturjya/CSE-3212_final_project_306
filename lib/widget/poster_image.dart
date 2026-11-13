import 'package:material_ui/material_ui.dart';
import 'package:final_project_debojyoti_64_g_306/constants.dart';

// Shows a movie poster from an internet link.
// If the link is broken, a movie icon is shown instead of crashing.
class PosterImage extends StatelessWidget {
  final String url;
  final double? height;
  final BoxFit fit;

  const PosterImage({
    super.key,
    required this.url,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: double.infinity,
          color: Colors.black12,
          alignment: Alignment.center,
          child: const Icon(Icons.movie, size: 50, color: kMaroon),
        );
      },
    );
  }
}