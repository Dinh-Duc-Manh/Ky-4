class Comments {
  final int? comment_id; // Nullable ID
  final String content;
  final int tour_id;
  final int user_id;

  Comments(this.comment_id, this.content, this.tour_id, this.user_id);
}
