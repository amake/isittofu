Window window = Window();

class Window {
  History get history => History();
  Location get location => Location();

  // Mocks for custom extension functions
  String get decodedQuery => null;

  void setQuery(String _) {}
}

class History {
  void pushState(Object _, Object __, Object ___) {}
}

class Location {
  String get search => null;
  String get hash => null;
}
