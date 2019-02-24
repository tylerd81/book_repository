
abstract class RepositoryInterface<T> {
  bool add(T item, String listName);
  bool delete(T item, String listName);

  Future<T> getById(String id);
  Future<List<T>> getAll([String listName="default"]); // get everything
  Future<List<T>> getSome(int start, int count, [String listName="default"]);
  Future<bool> update(T item, Map<String, dynamic> fields);
  
  // when deleting a list all the items will be moved to the list toList
  Future<bool> deleteList(String listName, [String toList="default"]);
  Future<List<String>> getListNames();
  bool createList(String listName);  
}