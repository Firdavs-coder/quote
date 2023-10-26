class QuoteModel {
  String id;
  String category;
  String author;
  String quote;
  bool isBooked = false;

  QuoteModel({
    required this.id,
    required this.category,
    required this.author,
    required this.quote,
    required this.isBooked,
  });
}
