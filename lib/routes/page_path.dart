import 'package:opinion_easy/view/auth/login_view.dart';
import 'package:opinion_easy/view/auth/complete_profile_view.dart';
import 'package:opinion_easy/view/bottom_nav.dart';
import 'package:opinion_easy/view/deactivated_view.dart';
import 'package:opinion_easy/view/home/home_view.dart';
import 'package:opinion_easy/view/home/notification_view.dart';
import 'package:opinion_easy/view/home/sub_categ_view.dart';
import 'package:opinion_easy/view/home/thank_you_view.dart';
import 'package:opinion_easy/view/profile/profile_content/about_us_view.dart';
import 'package:opinion_easy/view/profile/profile_content/bank_details_view.dart';
import 'package:opinion_easy/view/profile/profile_content/edit_profile.dart';
import 'package:opinion_easy/view/profile/profile_content/faq_view.dart';
import 'package:opinion_easy/view/profile/profile_content/help_view.dart';
import 'package:opinion_easy/view/profile/profile_content/history_view.dart';
import 'package:opinion_easy/view/profile/profile_content/monthly_top_performer_view.dart';
import 'package:opinion_easy/view/profile/profile_content/privacy_policy.dart';
import 'package:opinion_easy/view/profile/profile_content/refer_and_earn.dart';
import 'package:opinion_easy/view/profile/profile_content/terms_and_condition.dart';
import 'package:opinion_easy/view/splash_view.dart';
import 'package:get/get.dart';

import '../In_app_update.dart';

var pagePath = [
  GetPage(
    name: '/',
    page: () => InAppUpdateWrapper(child: SplashView()),
  ),
  GetPage(name: '/login', page: () => LoginView()),
  GetPage(name: '/complete-profile', page: () => CompleteProfileView()),
  GetPage(name: '/register', page: () => CompleteProfileView()),
  GetPage(name: '/bottom-nav', page: () => BottomNav()),
  GetPage(name: '/home', page: () => HomeView()),
  GetPage(name: '/edit-profile', page: () => EditProfileView()),
  GetPage(name: '/privacy-policy', page: () => PrivacyPolicyView()),
  GetPage(name: '/about-us', page: () => AboutUsView()),
  GetPage(name: '/help', page: () => HelpView()),
  GetPage(name: '/terms-and-conditions', page: () => TermsAndConditionsView()),
  GetPage(name: '/faq-view', page: () => FAQView()),
  GetPage(name: '/refer-earn', page: () => ReferAndEarnView()),
  GetPage(name: '/notification', page: () => NotificationView()),
  GetPage(name: '/history', page: () => HistoryView()),
  GetPage(name: '/bank', page: () => BankDetailsView()),
  GetPage(name: '/deactivated', page: () => DeactivatedView()),
  GetPage(name: '/thank-you', page: () => ThankYouView()),
  GetPage(name: '/sub-categ', page: () => SubCategView()),
  GetPage(
    name: '/monthly-top-performer',
    page: () => MonthlyTopPerformerView(),
  ),
];
