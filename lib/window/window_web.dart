import 'dart:html' as html;

html.Window window = html.window;

extension WindowUtils on html.Window {
  void setQuery(Map<String, String> params) {
    final realParams = Map.of(params)
      ..removeWhere((k, v) => v == null || v.isEmpty);
    final query = Uri(queryParameters: realParams).query;
    history.pushState(null, null, '?$query${location.hash}');
  }

  Map<String, String> get decodedQuery {
    final query = location.search;
    if (query == null || query.isEmpty) {
      return {};
    } else {
      // Remove leading '?'
      return Uri.splitQueryString(query.substring(1));
    }
  }
}
