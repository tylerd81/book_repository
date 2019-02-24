import "package:test/test.dart";
import "../book.dart";

Book createBook([String listName="default"]) {
  return Book(
    author: "Test Author",
    title: "Test Book Title",
    currentPage: 1,
    numPages: 321,
    id: "ID",
    imageName: "placeholder.png",
    lastReadDate: DateTime.now(),
    startedReadingDate: DateTime.now(),
    listName: listName,
  );
}

void main() {
  RepositoryInterface repo = BookList();

  test("There should be a default book list created", () async {
    var bookListNames = await repo.getListNames();
    expect(bookListNames.length, equals(1));
    expect(bookListNames[0], equals("default"));
  });

  test("Adding a new list", () async {
    repo.createList("favorites");
    var bookListNames = await repo.getListNames();
    expect(bookListNames.length, equals(2));
    expect(bookListNames[1], equals("favorites"));
  });

  // test("Deleting a list should actually remove the list", () async {
  //   await repo.deleteList("favorites");

  //   var bookListNames = await repo.getListNames();
  //   expect(bookListNames.length, equals(1));
  //   expect(bookListNames[1], isNullThrownError);
  // });

  test("The default list should start out empty", () async {
    var books = await repo.getAll();
    expect(books.length, equals(0));
  }); 

  test("Adding a book should add it to the default list", () async {
    repo.add(createBook());
    var books = await repo.getAll(); //get all from default list
    expect(books.length, equals(1));
    expect(books[0].title, equals("Test Book Title"));
  });

  test("Create a new list and add a book to it", () async {
    await repo.createList("Sci Fi");
    await repo.add(createBook("Sci Fi"));

    var sciFiBooks = await repo.getAll(listName: "Sci Fi");
    expect(sciFiBooks.length, equals(1));

  });
}