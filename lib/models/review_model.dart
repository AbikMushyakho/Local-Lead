class Review {
  final String id;
  final String userName;
  final String userPhoto;
  final double rating;
  final String date;
  final String comment;
  final String tourType;
  final bool verified;

  const Review({
    required this.id,
    required this.userName,
    required this.userPhoto,
    required this.rating,
    required this.date,
    required this.comment,
    this.tourType = 'Local Tour',
    this.verified = true,
  });
}