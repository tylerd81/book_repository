class User {
  final String name;

  User({this.name});
}

void main() {
  var names = ["tyler", "sarge", "brandi", "morgan"];
  int count = 2;
  int start = 0;

  if(start + (count - 1) > names.length - 1) {
    count = names.length - start;
  }
  for(String n in names.sublist(start, start + count) ) {
    print(n);
  }
  print("Index: ${names.indexOf("spiderman")}");

  var name;

  User user = User(
    name: name ?? "Sarge",
  );

  print(user.name);

  var h = <String, List<String>>{};
  h["names"] = [];

  for(String key in h.keys) {
    print(key);
  }


}

