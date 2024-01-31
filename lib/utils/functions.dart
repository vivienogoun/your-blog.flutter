import 'package:intl/intl.dart';

String formatDate(String inputDate) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(inputDate);

  // Format the DateTime object
  String formattedDate = DateFormat('MMM d, y').format(dateTime);

  return formattedDate;
}

String setFavoritesPosts(String favoritesPosts, String postId) {
  List<String> favoritesPostsList = favoritesPosts.split('-');

  if (favoritesPostsList.contains(postId)) {
    // Pattern is already in the list, remove it
    favoritesPostsList.remove(postId);
  } else {
    // Pattern is not in the list, add it
    favoritesPostsList.add(postId);
  }

  // Join the modified list of patterns back into a string
  String newFavoritesPosts = favoritesPostsList.join('-');

  return newFavoritesPosts;
}