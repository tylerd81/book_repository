import "./book.dart";
import "./repository_interface.dart";

class BookList extends RepositoryInterface<Book> {
  Map<String, List<Book>> bookLists = {"default": []};

  List<Book> _getList(String listName) {
    return bookLists[listName];
  }

  Future<bool> add(Book book, {bool createListIfNotExists=true}) async {
    var currentList = _getList(book.listName);

    //create the list if it doesn't exist
    if(currentList == null && createList == true) {
      await createList(book.listName);
      currentList = _getList(book.listName);      
    }

    if (currentList == null) {
      return false;
    }
    currentList.add(book);
    return true;
  }

  bool delete(Book item, [String listName = "default"]) {
    var currentList = _getList(listName);
    if (currentList != null) {
      return currentList.remove(item);
    } else {
      return false;
    }
  }

  Future<Book> getById(String id) async {
    for (String key in bookLists.keys) {
      var list = _getList(key);
      for (Book book in list) {
        if (book.id == id) {
          return book;
        }
      }
    }
    return null;
  }

  Future<List<Book>> getAll({String listName = "default"}) async {
    return _getList(listName);
  }

  Future<List<Book>> getSome(int start, int count,
      {String listName = "default"}) async {
    var currentList = _getList(listName);

    if (start < 0) {
      return null;
    }

    //trim the ending index if needed
    if (start + (count - 1) > currentList.length - 1) {
      count = currentList.length - start;
      assert(count > 0);
    }
    return currentList.sublist(start, start + count);
  }

  Future<bool> update(Book book, String listName, Map<String, dynamic> fields) async {
    Book updatedBook = Book(
      id: fields["id"] ?? book.id,
      author: fields["author"] ?? book.author,
      title: fields["title"] ?? book.title,
      numPages: fields["numPages"] ?? book.numPages,
      currentPage: fields["currentPage"] ?? book.currentPage,
      startedReadingDate:
          fields["startingReadingDate"] ?? book.startedReadingDate,
      lastReadDate: fields["lastReadDate"] ?? book.lastReadDate,
      listName: fields["listName"] ?? book.listName,
      imageName: fields["imageName"] ?? book.imageName,
    );
    var currentList =_getList(listName);
    int index = currentList.indexOf(book);
    if(index < 0) {
      return false; // book wasn't found
    }
    currentList[index] = updatedBook;
    return true;
  }

  // // when deleting a list all the items will be moved to the list toList
  Future<bool> deleteList(String listName, {String toList="default"}) {
    return Future.value(false);
  }

  Future<List<String>> getListNames() {
    return Future.value(bookLists.keys.toList());
  }

  Future<bool> createList(String listName) async {
    bookLists.putIfAbsent(listName, () => <Book>[]);
    return true;
  }
}
