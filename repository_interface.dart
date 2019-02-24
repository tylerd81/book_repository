
abstract class RepositoryInterface<T> {
  Future<bool> add(T item, {bool createListIfNotExists});
  Future<bool> delete(T item);

  Future<T> getById(String id);
  Future<List<T>> getAll({String listName="default"}); // get everything
  Future<List<T>> getSome(int start, int count, {String listName="default"});
  Future<bool> update(T item, Map<String, dynamic> fields);
  
  Future<bool> moveToList(T item, String toListName);

  // when deleting a list all the items will be moved to the list toList
  Future<bool> deleteList(String listName, {String toList="default"});
  Future<List<String>> getListNames();
  Future<bool> createList(String listName);  
}