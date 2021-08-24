import 'package:movie_tinder/ui/matches/match_Card.dart';
import 'package:flutter/material.dart';
import 'package:movie_tinder/models/match.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future handleDynamicLinks(BuildContext context) async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved
    _handleDeepLink(data, context);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          // 3a. handle link that has been retrieved
          _handleDeepLink(dynamicLink, context);
        }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data, BuildContext context) async{
    final Uri deepLink = data?.link;
    if (deepLink != null) {

      print('_handleDeepLink | deeplink: $deepLink');
      List<String> list = deepLink.toString().split('/');
      MyMatch match = await MyMatch().fromString(list.last);
      showDialog(context: context, builder: (_)=> MatchCard(match: match));
    }
  }



  Future<Uri> createDynamicUrl(MyMatch match) async{

    MyMatch reverse = MyMatch(
      friend: match.user,
      user: match.friend,
      film: match.film
    );

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://tilman.page.link',
      link: Uri.parse('https://movie.tinder/${reverse.toString()}'),
      androidParameters: AndroidParameters(
        packageName: 'de.tilman.movie_tinder',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters:  SocialMetaTagParameters(
        title: 'It\'s a Match!',
        description: 'Du und ${match.user.name} interessiert euch beide für ${match.film.title}.',
        imageUrl: Uri(path: match.film.poster),
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl;
}
}