import 'package:flutter/material.dart';

import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_hero_banner.dart';
import '../widgets/katinat_about_section.dart';
import '../widgets/katinat_promo_section.dart';
import '../widgets/katinat_news_section.dart';
import '../widgets/katinat_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: KatinatAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KatinatHeroBanner(),
            KatinatAboutSection(),
            KatinatPromoSection(),
            KatinatNewsSection(),
            KatinatFooter(),
          ],
        ),
      ),
    );
  }
}
