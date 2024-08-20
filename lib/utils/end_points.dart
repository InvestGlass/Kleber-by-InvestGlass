class EndPoints{
  static String baseUrl='https://staging.investglass.com/client_portal_api/';
  // static String baseUrl='https://app.investglass.com/client_portal_api/';

  // AUTH
  static String login='${baseUrl}portal_auth/login';
  static String userInfo='${baseUrl}portal_auth/me';
  static String sendOtp='${baseUrl}portal_auth/send_otp';
  static String verifyOtp='${baseUrl}portal_auth/verification_code';
  static String termOfService='${baseUrl}portal_auth/term_of_service';
  static String acceptanceTermsOfService='${baseUrl}portal_auth/acceptance_terms_of_service';
  static String changePassword='${baseUrl}portal_auth/change_password';

  // MARKET
  static String markets='${baseUrl}markets';
  static String currencies='${baseUrl}markets/currencies';
  static String industries='${baseUrl}markets/industries';
  static String assetClasses='${baseUrl}markets/asset_classes';

  // PORTFOLIO
  static String portfolios='${baseUrl}portfolios';
  static String transactions='${baseUrl}transactions';

  // PROPOSALS
  static String proposals='${baseUrl}proposals';
  static String proposalTypes='${baseUrl}proposals/proposal_types';

  // DOCUMENTS
  static String documents='${baseUrl}documents';
  static String accounts='${baseUrl}accounts';

  // HOME
  static String homeNews='${baseUrl}news/get_rss_news';

}