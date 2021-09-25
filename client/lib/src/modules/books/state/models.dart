import 'dart:convert';

class Book {
  Book(
    this.isbn,
    this.title,
    this.description,
    this.author,
    this.publicationDate,
  );

  /// The ISBN of the book.
  final String isbn;

  /// The title of the book.
  final String title;

  /// A description of the item.
  final String description;

  /// The author of this book.
  final String author;

  /// The date on which the book was published.
  final String publicationDate;

  DateTime get publishedAt => DateTime.parse(publicationDate);

  Map<String, dynamic> toMap() {
    return {
      'isbn': isbn,
      'title': title,
      'description': description,
      'author': author,
      'publicationDate': publicationDate,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      map['isbn'] as String,
      map['title'] as String,
      map['description'] as String,
      map['author'] as String,
      map['publicationDate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Book &&
      other.isbn == isbn &&
      other.title == title &&
      other.description == description &&
      other.author == author &&
      other.publicationDate == publicationDate;
  }

  @override
  int get hashCode {
    return isbn.hashCode ^
      title.hashCode ^
      description.hashCode ^
      author.hashCode ^
      publicationDate.hashCode;
  }
}

class Review {
  Review(this.body, this.rating, this.publicationDate);

  /// The actual body of the review.
  final String body;

  /// A rating.
  final int rating;

  /// Publication date of the review.
  final String publicationDate;

  DateTime get publishedAt => DateTime.parse(publicationDate);

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'rating': rating,
      'publicationDate': publicationDate,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      map['body'] as String,
      map['rating'] as int,
      map['publicationDate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Review &&
      other.body == body &&
      other.rating == rating &&
      other.publicationDate == publicationDate;
  }

  @override
  int get hashCode => body.hashCode ^ rating.hashCode ^ publicationDate.hashCode;
}
