import "package:test/test.dart";
import "../book.dart";

// TODO: create a moveToList method that moves a book from one list to the other
// implement the deleteList() method which will need to use the moveToList method
Book createBook({String title="Test Book Title", String listName="default", String id="ID"}) {
  return Book(
    author: "Test Author",
    title: title,
    currentPage: 1,
    numPages: 321,
    id: id,
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
    await repo.add(createBook(listName: "Sci Fi"));

    var sciFiBooks = await repo.getAll(listName: "Sci Fi");
    expect(sciFiBooks.length, equals(1));
  });

  test("Deleting a book from a list should remove it from that list", () async {        
    var sciFiBooks = await repo.getAll(listName: "Sci Fi");
    var bookToRemove = sciFiBooks[0];

    repo.delete(bookToRemove);
    sciFiBooks = await repo.getAll(listName: "Sci Fi");
    expect(sciFiBooks.length, equals(0));
  });

  test("Getting a book by its ID should return a book with ID == ID", () async {
    await repo.add(createBook(id: "#123", title: "Special Book"));
    var foundBook = await repo.getById("#123");
    expect(foundBook.title, equals("Special Book"));
  });

  test("Changing the title of a book and updating it", () async {
    Book book = createBook(title: "First Title", id: "#456");
    await repo.add(book);

    await repo.update(book, {"title" : "Second Title"});
    Book updatedBook = await repo.getById("#456");
    expect(updatedBook.title, equals("Second Title"));

  });

  test("Creating 4 lists should actually create 4 lists", () async {
    RepositoryInterface emptyRepo = BookList();

    await emptyRepo.createList("Sci Fi");
    await emptyRepo.createList("Adventure");
    await emptyRepo.createList("Horror");
    await emptyRepo.createList("Technology");
    //there is the default list auto created

    var lists = await emptyRepo.getListNames();
    expect(lists.length, equals(5));
  });

  test("Adding a book to a list that doesn't exist should create that list" , () async {
    Book book = createBook(listName: "Sarge's books");
    bool status = await repo.add(book);
    expect(status, equals(true));
    var lists = await repo.getListNames();
    expect(lists.contains("Sarge's books"), equals(true));
  });

  test("getAll() should return 5 books that were added", () async {
    var books = [
      createBook(title: "Book 1", listName: "finished books"),
      createBook(title: "Book 2", listName: "finished books"),
      createBook(title: "Book 3", listName: "finished books"),
      createBook(title: "Book 4", listName: "finished books"),
      createBook(title: "Book 5", listName: "finished books"),
    ];

    for(int i = 0; i <books.length; i++) {
      await repo.add(books[i]);
    }

    var bookList = await repo.getAll(listName: "finished books");
    expect(bookList.length, equals(5));
  });
}