import 'package:flutter_cached/flutter_cached.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schulcloud/app/app.dart';

import '../bloc.dart';
import '../data.dart';
import 'article_preview.dart';

/// A screen that displays a list of articles.
class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Bloc>.value(
      value: Bloc(
        storage: StorageService.of(context),
        network: NetworkService.of(context),
        userFetcher: UserFetcherService.of(context),
      ),
      child: Consumer<Bloc>(
        builder: (context, bloc, _) {
          return Scaffold(
            body: CachedBuilder<List<Article>>(
              controller: Bloc.of(context).fetchArticles(),
              errorBannerBuilder: (_, error, st) => ErrorBanner(error, st),
              errorScreenBuilder: (_, error, st) => ErrorScreen(error, st),
              builder: (_, articles) {
                articles.sort((a1, a2) => a2.published.compareTo(a1.published));

                return CustomScrollView(
                  slivers: <Widget>[
                    FancyAppBar.withAvatar(
                      title: Text('News'),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: ArticlePreview(article: articles[index]),
                          );
                        },
                        childCount: articles.length,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
