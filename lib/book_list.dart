import "package:book_repository/book.dart";
import "package:book_repository/repository_interface.dart";

class BookList extends RepositoryInterface<Book> {
  Map<String, List<Book>> bookLists = {"default": []};

  List<Book> _getList(String listName) {
    return bookLists[listName];
  }

  Future<bool> add(Book book, {bool createListIfNotExists=true}) async {
    var currentList = _getList(book.listName);

    //create the list if it doesn't exist
    if(currentList == null && createListIfNotExists == true) {
      await createList(book.listName);
      currentList = _getList(book.listName);      
    }

    if (currentList == null) {
      return false;
    }
    currentList.add(book);
    return true;
  }

  Future<bool> delete(Book item) async {
    var currentList = _getList(item.listName);
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
    if(bookLists.containsKey(listName)) {
      return _getList(listName);
    }else{
      return null;
    }
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

  Future<Book> update(Book book, Map<String, dynamic> fields, {insertBook=true}) async {
    // Problem: if a book is changed to a different list by changing
    // the list name, the original book will still be in the old list.
    // Also, this book won't be found in the list because it doesn't
    // exist there yet... so this will fail anyways

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
    var currentList =_getList(book.listName);
    int index = currentList.indexOf(book);
    if(index < 0) {
      return null; // book wasn't found
    }

    if(insertBook == true) {
      currentList[index] = updatedBook;
    }
    return updatedBook;
  }

  Future<Book> moveToList(Book book, String toListName) async {
    if(!bookLists.containsKey(toListName)) {
      return null;
    }
    
    Book updatedBook = await update(book, {"listName":toListName}, insertBook: false);
    add(updatedBook);

    // remove the old book
    delete(book);
    return updatedBook;
  }

  // // when deleting a list all the items will be moved to the list toList
  Future<bool> deleteList(String listName, {String toList="default"}) async {
    if(listName == "default") {
      return false; // don't allow deleting the default list
    }
    
    if(bookLists.containsKey(listName)) {
      bookLists.remove(listName);
    }
    return true;
  }

  Future<List<String>> getListNames() {
    return Future.value(bookLists.keys.toList());
  }

  Future<bool> createList(String listName) async {
    bookLists.putIfAbsent(listName, () => <Book>[]);
    return true;
  }
}
