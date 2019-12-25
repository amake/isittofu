import 'dart:html' as html;

html.Window window = html.window;

extension WindowUtils on html.Window {
  void setQuery(String string) => history.pushState(
      null, null, '?${Uri.encodeQueryComponent(string)}${location.hash}');

  String get decodedQuery {
    final query = location.search;
    return query == null || query.isEmpty
        ? null
        // Remove leading '?'
        : Uri.decodeQueryComponent(query.substring(1));
  }
}
