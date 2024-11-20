class EndPoints{
  // static String baseUrl='https://staging.investglass.com/';
  static String baseUrl='https://app.investglass.com/';
  static String apiBaseUrl='${baseUrl}client_portal_api/';

  // AUTH
  static String login='${apiBaseUrl}portal_auth/login';
  static String userInfo='${apiBaseUrl}portal_auth/me';
  static String sendOtp='${apiBaseUrl}portal_auth/send_otp';
  static String verifyOtp='${apiBaseUrl}portal_auth/verification_code';
  static String termOfService='${apiBaseUrl}portal_auth/term_of_service';
  static String acceptanceTermsOfService='${apiBaseUrl}portal_auth/acceptance_terms_of_service';
  static String changePassword='${apiBaseUrl}portal_auth/change_password';

  // MARKET
  static String markets='${apiBaseUrl}markets';
  static String currencies='${apiBaseUrl}markets/currencies';
  static String industries='${apiBaseUrl}markets/industries';
  static String assetClasses='${apiBaseUrl}markets/asset_classes';

  // PORTFOLIO
  static String portfolios='${apiBaseUrl}portfolios';
  static String transactions='${apiBaseUrl}transactions';

  // PROPOSALS & CHAT
  static String proposals='${apiBaseUrl}proposals';
  static String proposalTypes='${apiBaseUrl}proposals/proposal_types';
  static String chat='${apiBaseUrl}comments';

  // DOCUMENTS
  static String documents='${apiBaseUrl}documents';
  static String accounts='${apiBaseUrl}accounts';

  // HOME
  static String homeNews='${apiBaseUrl}news/get_rss_news';

  // ADD TRANSACTION
  static String transactionTypes='${apiBaseUrl}transactions/transaction_type';
  static String createTransaction='${apiBaseUrl}transactions';


}