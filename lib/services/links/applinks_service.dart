import 'package:app_links/app_links.dart';
import 'package:insight/services/links/applinks_provider_service.dart';

class AppLinksService {
  final AppLinks appLinks;
  final AppLinksProviderService appLinksProvider;
  AppLinksService({required this.appLinks, required this.appLinksProvider}) {
    appLinks.uriLinkStream.listen(_onUriHandler);
  }

  String createDynamicLink({
    required String path,
    required Map<String, String> queryMap,
  }) {
    return 'https://minasov.am/$path${_createQueryParams(queryMap)}'; // TODO: will be changed, now it not work url
  }

  String _createQueryParams(Map<String, String> map) {
    String query = '?';
    map.forEach((key, value) => query += '$key=${value.replaceAll(' ', '_')}&');
    return query.substring(0, query.length - 1);
  }

  void _onUriHandler(Uri event) async {
    appLinksProvider.handleUrl(event);
  }
}
