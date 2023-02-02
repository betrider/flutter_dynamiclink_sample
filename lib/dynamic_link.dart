import 'package:dynamiclink/dynamic_result_page.dart';
import 'package:dynamiclink/main.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

class DynamicLink {

  /// 다이나믹 링크 셋팅
  Future<bool> setup() async {
    bool isExistDynamicLink = await _getInitialDynamicLink();
    _addListener();

    return isExistDynamicLink;
  }

  /// 다이마닉 링크 초기화
  Future<bool> _getInitialDynamicLink() async {
    final String? deepLink = await getInitialLink();

    // 앱이 종료됬다가 실행되는 경우
    if (deepLink != null) {
      PendingDynamicLinkData? dynamicLinkData = await FirebaseDynamicLinks.instance.getDynamicLink(
        Uri.parse(deepLink),
      );

      if (dynamicLinkData != null) {
        _redirectScreen('앱이 종료됬다가 실행되는 경우', dynamicLinkData);

        return true;
      }
    }

    return false;
  }

  /// 리스너 연결
  void _addListener() {
    // 앱이 실행중인 경우 실행
    FirebaseDynamicLinks.instance.onLink.listen((
      PendingDynamicLinkData dynamicLinkData,
    ) {
      _redirectScreen('앱이 실행중인 경우', dynamicLinkData);
    }).onError((error) {
      print(error);
    });
  }

  /// 스크린 연결
  void _redirectScreen(String reason, PendingDynamicLinkData dynamicLinkData) {
    if (dynamicLinkData.link.queryParameters.containsKey('id')) {
      String link = dynamicLinkData.link.path.split('/').last;
      String id = dynamicLinkData.link.queryParameters['id']!;

      Navigator.push(
        globalContext!,
        MaterialPageRoute(builder: (context) => DynamicResultPage(title: reason, link: link, id: id)),
      );
    }
  }

  /// 짧은 링크 생성
  Future<String> getShortLink(String screenName, String id) async {
    String dynamicLinkPrefix = 'https://betrider.page.link';
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('$dynamicLinkPrefix/$screenName?id=$id'),
      androidParameters: const AndroidParameters(
        packageName: 'com.betrider.dynamiclink',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.betrider.dynamiclink',
        minimumVersion: '0',
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return dynamicLink.shortUrl.toString();
  }
}
