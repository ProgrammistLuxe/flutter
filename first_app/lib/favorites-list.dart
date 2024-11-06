import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({
    super.key,
    required this.favorites,
    required this.deleteFavorite,
  });
  final List<WordPair> favorites;
  final Function(WordPair) deleteFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IconData icon = Icons.delete_forever;
    final style = theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold);
    if (favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        'У вас имеется ${favorites.length} элемента(ов)',
        style: style,
      ),
      SizedBox(height: 16),
      Container(
        height: 500,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (var i = 0; i < favorites.length; i++)
              ListTile(
                leading: ElevatedButton.icon(
                  onPressed: () {
                    deleteFavorite(favorites[i]);
                  },
                  icon: Icon(icon),
                  label: Text('Delete'),
                ),
                title: Text(favorites[i].asUpperCase,
                    semanticsLabel:
                        "${favorites[i].first} ${favorites[i].second}"),
                // Row(children: [
                //   Padding(
                //     padding: const EdgeInsets.only(top: 10, right: 10),
                //     child: Row(
                //       children: [
                //         Text(favorites[i].asCamelCase,
                //             semanticsLabel:
                //                 "${favorites[i].first} ${favorites[i].second}"),
                //         ElevatedButton.icon(
                //           onPressed: () {
                //             deleteFavorite(favorites[i]);
                //           },
                //           icon: Icon(icon),
                //           label: Text('Delete'),
                //         ),
                //       ],
                //     ),
                //   )
                // ])
              )
          ],
        ),
      )
    ]));
  }
}
