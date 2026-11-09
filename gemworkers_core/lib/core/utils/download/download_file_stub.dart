void downloadTextFile(String filename, String content, {String mime = 'text/csv'}) {}
Future<void> downloadUrlFile(String url, String filename) async {}
bool get canShareFiles => false;
Future<Object> fetchFileForShare(String url, String filename) async => Object();
Future<bool> shareFile(Object file) async => false;
void saveFile(Object file) {}
