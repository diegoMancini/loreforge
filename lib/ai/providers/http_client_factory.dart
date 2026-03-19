import 'package:http/http.dart' as http;

/// Creates an HTTP client appropriate for the current platform.
///
/// On web, we'd use BrowserClient, but since conditional imports are
/// complex in Flutter, we use the default [http.Client] which automatically
/// resolves to BrowserClient on web and IOClient on native.
http.Client createPlatformClient() {
  return http.Client();
}
