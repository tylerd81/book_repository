import "./book.dart";
import "./repository_interface.dart";

class BookList extends RepositoryInterface<Book> {
  Map<String, List<Book>> bookLists = {"default":[]};

  bool add(Book book, String listName) {
    List<Book> currentList = bookLists[listName];
    if(currentList == null) {
      return false;
    }

    currentList.add(book);
  }
  // bool delete(T item, String listName);

  // Future<T> getById(String id);
  // Future<List<T>> getAll([String listName="default"]); // get everything
  // Future<List<T>> getSome(int start, int count, [String listName="default"]);
  // Future<bool> update(T item, Map<String, dynamic> fields);
  
  // // when deleting a list all the items will be moved to the list toList
  // Future<bool> deleteList(String listName, [String toList="default"]);
  // Future<List<String>> getListNames();
  // bool createList(String listName);  
}