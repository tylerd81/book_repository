export "package:book_repository/book_list.dart";
export "package:book_repository/repository_interface.dart";

class Book {
  final String id;

  final String title;
  final String author;

  final int numPages;
  final int currentPage;

  final DateTime startedReadingDate;
  final DateTime lastReadDate;

  final String listName;
  final String imageName;

  Book({
    this.id = "ID",
    this.title,
    this.author,
    this.numPages,
    this.currentPage,
    this.startedReadingDate,
    this.lastReadDate,
    this.listName = "default",
    this.imageName = "placeholder.jpg",
  });
}
