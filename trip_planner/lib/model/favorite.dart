class Favorite {
  int favorite_id;
  int tour_id;
  int user_id;

  Favorite(this.favorite_id, this.tour_id, this.user_id);

  Map<String, Object?> toMap() {
    return {
      'favorite_id': favorite_id,
      'tour_id': tour_id,
      'user_id': user_id,
    };
  }
}
