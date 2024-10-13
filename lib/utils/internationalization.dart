import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'ar', 'vi'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? arText = '',
    String? viText = '',
  }) =>
      [enText, arText, viText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return FFLocalizations.languages().contains(
      language.endsWith('_')
          ? language.substring(0, language.length - 1)
          : language,
    );
  }

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // OnBoardingPage
  {
    '3h41wkxj': {
      'en': 'Sign in',
      'ar': 'تسجيل الدخول',
      'vi': 'Đăng nhập',
    },
    'c7folydq': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // SignInPage
  {
    'rf7r2nk0': {
      'en': 'Login',
      'ar': 'تسجيل الدخول',
      'vi': 'Đăng nhập',
    },
    'g143uz7d': {
      'en': 'Password',
      'ar': 'كلمة المرور',
      'vi': 'Mật khẩu',
    },
    'cais5tw0': {
      'en': 'Email or Username',
      'ar': 'البريد الإلكتروني أو اسم المستخدم',
      'vi': 'Email hoặc tên người dùng',
    },
    'gs8awxej': {
      'en': 'Sign into',
      'ar': 'تسجيل الدخول',
      'vi': 'Đăng nhập vào',
    },
    'no_security_found':{
      'en': 'No security found',
      'ar': 'لم يتم العثور على الأمان',
      'vi': 'Không tìm thấy bảo mật',
    },
    'no_doc_found':{
      'en': 'No document found',
      'ar': 'لم يتم العثور على وثيقة',
      'vi': 'Không tìm thấy tài liệu nào',
    },
    'no_proposals_found':{
      'en': 'No proposal found',
      'ae': 'لم يتم العثور على أي اقتراح',
      'vi': 'Không tìm thấy đề xuất nào',
    },
    'zlksaikw': {
      'en': 'your',
      'ar': 'لك',
      'vi': 'của bạn',
    },
    'lex9mep0': {
      'en': 'account',
      'ar': 'حساب',
      'vi': 'tài khoản',
    },
    'd9hhr78b': {
      'en': 'account',
      'ar': 'حساب',
      'vi': 'tài khoản',
    },
    'e9zrlew0': {
      'en': 'account',
      'ar': 'حساب',
      'vi': 'tài khoản',
    },
    'zdbe1lx9': {
      'en': 'account',
      'ar': 'حساب',
      'vi': 'tài khoản',
    },
    '1tt86su5': {
      'en': 'your',
      'ar': 'لك',
      'vi': 'của bạn',
    },
    'y8llhhe3': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // NewDetailPage
  {
    'r5la6ony': {
      'en': 'BBC News',
      'ar': 'بي بي سي نيوز',
      'vi': 'tin tức BBC',
    },
    'rog3ydmc': {
      'en': '@bbc',
      'ar': '@بي بي سي',
      'vi': '@bbc',
    },
    'y1dolub7': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // AddDocumentPage
  {
    '4kyuvn3o': {
      'en': 'Upload Document',
      'ar': 'تحميل الوثيقة',
      'vi': 'Tải tài liệu lên',
    },
    'him7gi6o': {
      'en': 'File',
      'ar': 'ملف',
      'vi': 'Tài liệu',
    },
    'lh2w6q42': {
      'en': 'SELECT ',
      'ar': 'يختار',
      'vi': 'Lựa chọn',
    },
    'mpbhr71m': {
      'en': '.',
      'ar': '.',
      'vi': '.',
    },
    'jzvxxaxu': {
      'en': 'Click to upload your document',
      'ar': 'انقر لتحميل المستند الخاص بك',
      'vi': 'Bấm để tải lên tài liệu của bạn',
    },
    'mw4a4y0a': {
      'en': 'Description',
      'ar': 'وصف',
      'vi': 'Sự miêu tả',
    },
    'alsw67uc': {
      'en': 'Document\'s description',
      'ar': 'وصف الوثيقة',
      'vi': 'Mô tả tài liệu',
    },
    '3hz1whes': {
      'en': 'Upload',
      'ar': 'رفع',
      'vi': 'Tải lên',
    },
    'c7ypx4h2': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // NotificationsPage
  {
    'h66hylfo': {
      'en': 'Notifications',
      'ar': 'إشعارات',
      'vi': 'Thông báo',
    },
  },
  // ChatDetailPage
  {
    'dlkgtx0t': {
      'en': 'Proposal',
      'ar': 'عرض',
      'vi': 'Đề xuất',
    },
    'lq59qmsn': {
      'en': 'Schedule Appointment',
      'ar': 'تحديد موعد',
      'vi': 'Lịch hẹn',
    },
    '0lw6g9ud': {
      'en': 'Type new message',
      'ar': 'اكتب رسالة جديدة',
      'vi': 'Nhập tin nhắn mới',
    },
    '95k73u5g': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // ProfilePage
  {
    'p1nsrsd1': {
      'en': '__',
      'ar': '__',
      'vi': '__',
    },
  },
  // ChangePasswordPage
  {
    'yot02jf2': {
      'en': 'Change Password',
      'ar': 'تغيير كلمة المرور',
      'vi': 'Đổi mật khẩu',
    },
    '510yg9y6': {
      'en': 'Current password',
      'ar': 'كلمة السر الحالية',
      'vi': 'Mật khẩu hiện tại',
    },
    '729kp7ui': {
      'en': 'Your current password',
      'ar': 'كلمة السر الحالية الخاصة بك',
      'vi': 'Mật khẩu hiện tại của bạn',
    },
    'ju5jgv6f': {
      'en': 'Invalid password',
      'ar': 'رمز مرور خاطئ',
      'vi': 'Mật khẩu không hợp lệ',
    },
    '2l6qayo4': {
      'en': 'New password',
      'ar': 'كلمة المرور الجديدة',
      'vi': 'Mật khẩu mới',
    },
    'oef8jq9l': {
      'en': 'New password',
      'ar': 'كلمة المرور الجديدة',
      'vi': 'Mật khẩu mới',
    },
    'gtihat6e': {
      'en': 'New password needs at least 6 characters',
      'ar': 'كلمة المرور الجديدة تحتاج إلى 6 أحرف على الأقل',
      'vi': 'Mật khẩu mới cần ít nhất 6 ký tự',
    },
    'lz5cj3qp': {
      'en': 'Confirm new password',
      'ar': 'تأكيد كلمة المرور الجديدة',
      'vi': 'Xác nhận mật khẩu mới',
    },
    'lph5tz72': {
      'en': 'Confirm your new password',
      'ar': 'قم بتأكيد كلمة المرور الجديدة',
      'vi': 'Xác nhận mật khẩu mới của bạn',
    },
    'y6byl3gh': {
      'en': 'Confirm new password must match new password',
      'ar': 'تأكيد كلمة المرور الجديدة يجب أن تتطابق مع كلمة المرور الجديدة',
      'vi': 'Xác nhận mật khẩu mới phải khớp với mật khẩu mới',
    },
    'iy4dy5qk': {
      'en': 'Change password',
      'ar': 'تغيير كلمة المرور',
      'vi': 'Đổi mật khẩu',
    },
    'nfc91a9j': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // changrlanguage
  {
    'english': {
      'en': 'English',
      'ar': 'إنجليزي',
      'vi': 'Tiếng Anh',
    },
    'arabic': {
      'en': 'Arabic',
      'ar': 'عربي',
      'vi': 'tiếng Ả Rập',
    },
    'vietnamese': {
      'en': 'Vietnamese',
      'ar': 'الفيتنامية',
      'vi': 'Tiếng Việt',
    },
  },
  // ProposalDetailPage
  {
    '12cgqet1': {
      'en': 'Proposal',
      'ar': 'عرض',
      'vi': 'Đề xuất',
    },
    'j0hr735r': {
      'en': 'Decline',
      'ar': 'رفض',
      'vi': 'Từ chối',
    },
    'f8pf4flh': {
      'en': 'Accept',
      'ar': 'يقبل',
      'vi': 'Chấp nhận',
    },
    'vhohm2gh': {
      'en': 'Declined at',
      'ar': 'رفض في',
      'vi': 'Bị từ chối tại',
    },
    '0gxshjqc': {
      'en': 'Accepted at',
      'ar': 'مقبول في',
      'vi': 'Được chấp nhận tại',
    },
    'lw93ftpw': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // MainPage
  {
    'ytd2avxs': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // test
  {
    '57k3dgbt': {
      'en': 'SVG',
      'ar': 'SVG',
      'vi': 'SVG',
    },
    'f56350tm': {
      'en': 'SVG Compiler',
      'ar': 'مترجم SVG',
      'vi': 'Trình biên dịch SVG',
    },
    'yux64vyf': {
      'en': 'Example 2',
      'ar': 'مثال 2',
      'vi': 'Ví dụ 2',
    },
    'm89f6pjw': {
      'en': 'Tab View 2',
      'ar': 'عرض علامة التبويب 2',
      'vi': 'Chế độ xem tab 2',
    },
    '0f4cc5jv': {
      'en': 'Example 3',
      'ar': 'مثال 3',
      'vi': 'Ví dụ 3',
    },
    'ow2th2ka': {
      'en': 'Tab View 3',
      'ar': 'عرض علامة التبويب 3',
      'vi': 'Chế độ xem tab 3',
    },
    '7b4df5uj': {
      'en': 'Page Title',
      'ar': 'عنوان الصفحة',
      'vi': 'Tiêu đề trang',
    },
    'm5iym6ry': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // DocumentsListPage2
  {
    'j2jcor2x': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
    'preview': {
      'en': 'Preview',
      'ar': 'معاينة',
      'vi': 'Xem trước',
    },
    'download': {
      'en': 'Download',
      'ar': 'تحميل',
      'vi': 'Tải xuống',
    },
    'signature': {
      'en': 'Signature',
      'ar': 'إمضاء',
      'vi': 'Chữ ký',
    },
  },
  // WebviewPage
  {
    'xptnvk4d': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // NewTransactionPage
  {
    '1rmo2764': {
      'en': 'New Transaction',
      'ar': 'معاملة جديدة',
      'vi': 'Giao dịch mới',
    },
    'lvtq8f1d': {
      'en': 'Transaction type*',
      'ar': 'نوع المعاملة*',
      'vi': 'Loại giao dịch*',
    },
    'mzy7ssrc': {
      'en': 'Alt. Investment',
      'ar': 'بديل. استثمار',
      'vi': 'thay thế. Sự đầu tư',
    },
    'eq4x9n1u': {
      'en': 'Cash Deposit',
      'ar': 'إيداع نقدي',
      'vi': 'Tiên đặt cọc',
    },
    'cxoslr35': {
      'en': 'Cash Withdarw',
      'ar': 'السحب النقدي',
      'vi': 'Rút tiền mặt',
    },
    'ggeo4b0j': {
      'en': 'Clearing Fee',
      'ar': 'رسوم المقاصة',
      'vi': 'Phí thanh toán bù trừ',
    },
    'rf9ijto0': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'z3seosat': {
      'en': 'Transaction status*',
      'ar': 'حالة عملية*',
      'vi': 'Trạng thái giao dịch*',
    },
    'u6kp9mh5': {
      'en': 'Pending',
      'ar': 'قيد الانتظار',
      'vi': 'Chưa giải quyết',
    },
    'mk5ongux': {
      'en': 'Executed',
      'ar': 'أعدم',
      'vi': 'Thực thi',
    },
    'h5kwz5n8': {
      'en': 'Failed',
      'ar': 'فشل',
      'vi': 'Thất bại',
    },
    'pxirwvsb': {
      'en': 'Canceled',
      'ar': 'ألغيت',
      'vi': 'Đã hủy',
    },
    'zq7hd897': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'airvu3wg': {
      'en': 'Currency*',
      'ar': 'عملة*',
      'vi': 'Tiền tệ*',
    },
    'l0lwzjgx': {
      'en': 'USD - US Dollar',
      'ar': 'الدولار الأمريكي - الدولار الأمريكي',
      'vi': 'USD - Đô la Mỹ',
    },
    '1183o2jn': {
      'en': 'VND - Vietnamese Dong',
      'ar': 'VND - دونج فيتنامي',
      'vi': 'VNĐ - Đồng Việt Nam',
    },
    'b2wletq2': {
      'en': 'THB - Thai Baht',
      'ar': 'THB - البات التايلندي',
      'vi': 'THB - Baht Thái',
    },
    'f52mzh01': {
      'en': 'JPY - Japenese Yen',
      'ar': 'الين الياباني - الين الياباني',
      'vi': 'JPY - Yên Nhật',
    },
    'rugmagcn': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    '4ozeqrcz': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
    'cbvxrrgx': {
      'en': 'Amount*',
      'ar': 'كمية*',
      'vi': 'Số lượng*',
    },
    '22c25jl6': {
      'en': 'Amount must be greater than 0',
      'ar': 'يجب أن يكون المبلغ أكبر من 0',
      'vi': 'Số tiền phải lớn hơn 0',
    },
    'n2u1440v': {
      'en': 'USD \$',
      'ar': 'دولار أمريكي',
      'vi': 'USD \$',
    },
    'wbwyrgib': {
      'en': 'Open rate',
      'ar': 'معدل مفتوح',
      'vi': 'Tỉ lệ mở',
    },
    'oba6y3ps': {
      'en': 'USD/USD',
      'ar': 'دولار أمريكي/دولار أمريكي',
      'vi': 'USD/USD',
    },
    'e0lclrlh': {
      'en': 'Transaction Date*',
      'ar': 'تاريخ الصفقة*',
      'vi': 'Ngày Giao dịch*',
    },
    'b2ene7pk': {
      'en': 'Date must be specified',
      'ar': 'يجب تحديد التاريخ',
      'vi': 'Ngày phải được chỉ định',
    },
    'l33tyaq2': {
      'en': 'Accounting Date',
      'ar': 'تاريخ المحاسبة',
      'vi': 'Ngày kế toán',
    },
    '580q4cpd': {
      'en': 'Value Date',
      'ar': 'تاريخ القيمة',
      'vi': 'Ngày giá trị',
    },
    '3gltw1as': {
      'en': 'Client Settlement',
      'ar': 'تسوية العميل',
      'vi': 'Thanh toán của khách hàng',
    },
    '8z8om63p': {
      'en': 'Select...',
      'ar': 'يختار...',
      'vi': 'Lựa chọn...',
    },
    '7qfeihe1': {
      'en': 'su',
      'ar': 'su',
      'vi': 'su',
    },
    'dakksbhl': {
      'en': 'HCM City',
      'ar': 'مدينة اتش سي ام',
      'vi': 'TP.HCM',
    },
    'k05bzcae': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    '609fatzr': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
    'cmvhpvxy': {
      'en': 'Company Settlement',
      'ar': 'تسوية الشركة',
      'vi': 'Giải quyết công ty',
    },
    'dsiy2ndn': {
      'en': 'Select...',
      'ar': 'يختار...',
      'vi': 'Lựa chọn...',
    },
    'e22smxml': {
      'en': 'su',
      'ar': 'su',
      'vi': 'su',
    },
    'hlx823un': {
      'en': 'HCM City',
      'ar': 'مدينة اتش سي ام',
      'vi': 'TP.HCM',
    },
    'p910hiul': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'vrkibydv': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
    'ylem5knl': {
      'en': 'Broker/Counterparty Settlement',
      'ar': 'تسوية الوسيط/الطرف المقابل',
      'vi': 'Giải quyết môi giới/đối tác',
    },
    'ks86zlgi': {
      'en': 'Select...',
      'ar': 'يختار...',
      'vi': 'Lựa chọn...',
    },
    'yvdx9x5p': {
      'en': 'su',
      'ar': 'su',
      'vi': 'su',
    },
    'cnko6piz': {
      'en': 'HCM City',
      'ar': 'مدينة اتش سي ام',
      'vi': 'TP.HCM',
    },
    'ny1fqsr3': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    '5zbutpiz': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
    'j9fxzxjx': {
      'en': 'Notes',
      'ar': 'ملحوظات',
      'vi': 'Ghi chú',
    },
    'zc9jp3sw': {
      'en': 'Create Contact Report',
      'ar': 'إنشاء تقرير جهة الاتصال',
      'vi': 'Tạo báo cáo liên hệ',
    },
    'omnyycbo': {
      'en': 'Generate & Save Invoice',
      'ar': 'إنشاء وحفظ الفاتورة',
      'vi': 'Tạo và lưu hóa đơn',
    },
    'qsuxqtdi': {
      'en': 'Invoice number',
      'ar': 'رقم الفاتورة',
      'vi': 'Số hóa đơn',
    },
    '2gprp57y': {
      'en': 'Invoice currency',
      'ar': 'عملة الفاتورة',
      'vi': 'Đồng tiền hóa đơn',
    },
    'u9zuq2tq': {
      'en': 'USD - US Dollar',
      'ar': 'الدولار الأمريكي - الدولار الأمريكي',
      'vi': 'USD - Đô la Mỹ',
    },
    '2o1zdp3v': {
      'en': 'VND - Vietnamese Dong',
      'ar': 'VND - دونج فيتنامي',
      'vi': 'VNĐ - Đồng Việt Nam',
    },
    'g4zhlylb': {
      'en': 'THB - Thai Baht',
      'ar': 'THB - البات التايلندي',
      'vi': 'THB - Baht Thái',
    },
    'oquoet9p': {
      'en': 'JPY - Japenese Yen',
      'ar': 'الين الياباني - الين الياباني',
      'vi': 'JPY - Yên Nhật',
    },
    'yhnwnefx': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'cm03jx79': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
    'devm6cmv': {
      'en': 'Add Fee / Tax',
      'ar': 'إضافة رسوم/ضريبة',
      'vi': 'Thêm Phí/Thuế',
    },
    'w3yrqad9': {
      'en': 'Create',
      'ar': 'يخلق',
      'vi': 'Tạo nên',
    },
    'rfeltbti': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // NewTradePage
  {
    'z97rvm72': {
      'en': 'New Trade',
      'ar': 'تجارة جديدة',
      'vi': 'Giao dịch mới',
    },
    'ixctvaic': {
      'en': 'Portfolio',
      'ar': '',
      'vi': '',
    },
    '53dk25lw': {
      'en': 'Buy to Open',
      'ar': '',
      'vi': '',
    },
    '6df6xxpt': {
      'en': 'Buy to Close',
      'ar': '',
      'vi': '',
    },
    '81dcf4qa': {
      'en': 'Sell to Open',
      'ar': '',
      'vi': '',
    },
    'lzd9cyr1': {
      'en': 'Sell to Close',
      'ar': '',
      'vi': '',
    },
    'cjuvvsm5': {
      'en': 'Incoming Transfer',
      'ar': '',
      'vi': '',
    },
    'zx1wc2ro': {
      'en': 'Outgoing Transfer',
      'ar': '',
      'vi': '',
    },
    'ht2hsdk3': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'm7418olr': {
      'en': 'Search for transaction type',
      'ar': '',
      'vi': '',
    },
    'nm6nfn4y': {
      'en': 'Portfolio must be given',
      'ar': '',
      'vi': '',
    },
    'rumkikc1': {
      'en': 'Name, ISIN, FIGI or Ticket',
      'ar': 'الاسم، ISIN، FIGI أو التذكرة',
      'vi': 'Tên, ISIN, FIGI hoặc Vé',
    },
    'dmgzjo53': {
      'en': 'Security\'s name must be given',
      'ar': 'يجب إعطاء اسم الأمن',
      'vi': 'Tên của bảo mật phải được cung cấp',
    },
    'whkrwls1': {
      'en': 'Type',
      'ar': 'يكتب',
      'vi': 'Kiểu',
    },
    'lmnve4ua': {
      'en': 'Buy to Open',
      'ar': 'شراء لفتح',
      'vi': 'Mua để mở',
    },
    'kxq6qy7f': {
      'en': 'Buy to Close',
      'ar': 'شراء لإغلاق',
      'vi': 'Mua để đóng',
    },
    'zrj8fd7n': {
      'en': 'Sell to Open',
      'ar': 'بيع لفتح',
      'vi': 'Bán để mở',
    },
    '98cdg04u': {
      'en': 'Sell to Close',
      'ar': 'بيع لإغلاق',
      'vi': 'Bán để đóng',
    },
    'isbfun57': {
      'en': 'Incoming Transfer',
      'ar': 'تحويل وارد',
      'vi': 'Chuyển khoản đến',
    },
    'zswpadhe': {
      'en': 'Outgoing Transfer',
      'ar': 'نقل الصادرة',
      'vi': 'Chuyển khoản đi',
    },
    '4yho5xdn': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'catj4e9j': {
      'en': 'Search for transaction type',
      'ar': 'البحث عن نوع المعاملة',
      'vi': 'Tìm kiếm loại giao dịch',
    },
    '7fx237xy': {
      'en': 'Time In Force',
      'ar': 'الوقت في القوة',
      'vi': 'Thời gian có hiệu lực',
    },
    'f2fyvhfy': {
      'en': 'Date must be specified',
      'ar': 'يجب تحديد التاريخ',
      'vi': 'Ngày phải được chỉ định',
    },
    '2mpa9jiq': {
      'en': 'Notes',
      'ar': 'ملحوظات',
      'vi': 'Ghi chú',
    },
    'u7hyldvt': {
      'en': 'Order Type',
      'ar': 'نوع الطلب',
      'vi': 'Kiểu đơn hàng',
    },
    '2odrp5sn': {
      'en': 'Quantity',
      'ar': 'كمية',
      'vi': 'Số lượng',
    },
    'lz424u11': {
      'en': 'Current Price',
      'ar': 'السعر الحالي',
      'vi': 'Giá hiện tại',
    },
    'bhxqgsuw': {
      'en': 'USD \$',
      'ar': 'دولار أمريكي',
      'vi': 'USD \$',
    },
    'q9p7fv0r': {
      'en': 'Limit Price',
      'ar': 'سعر الحد',
      'vi': 'Giá giới hạn',
    },
    'ee6858r7': {
      'en': 'USD \$',
      'ar': 'دولار أمريكي',
      'vi': 'USD \$',
    },
    'nbthbjny': {
      'en': 'USD \$',
      'ar': 'دولار أمريكي',
      'vi': 'USD \$',
    },
    '4noemhfd': {
      'en': 'Amount',
      'ar': 'كمية',
      'vi': 'Số lượng',
    },
    'n25ml3i7': {
      'en': 'USD \$',
      'ar': 'دولار أمريكي',
      'vi': 'USD \$',
    },
    'h2vfcolj': {
      'en': 'TRANSMIT',
      'ar': 'نقل',
      'vi': 'Chuyển giao',
    },
    '7orhqoys': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // DocumentDetailPage
  {
    'dlgf18jl': {
      'en': 'Document',
      'ar': 'وثيقة',
      'vi': 'Tài liệu',
    },
    'mg8sso38': {
      'en': 'Sign',
      'ar': 'لافتة',
      'vi': 'Dấu hiệu',
    },
    '5tjloy3c': {
      'en': 'Rejected at',
      'ar': 'مرفوض عند',
      'vi': 'Bị từ chối tại',
    },
    'rejected': {
      'en': 'Rejected',
      'ar': 'مرفوض',
      'vi': 'Vật bị loại bỏ',
    },
    'ktrsz8sp': {
      'en': 'Accepted at',
      'ar': 'مقبول في',
      'vi': 'Được chấp nhận tại',
    },
    '9f0ag6b2': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // TransferFundsPage
  {
    'fklubmeg': {
      'en': 'Transfer Funds',
      'ar': 'تحويل الأموال',
      'vi': 'Chuyển tiền',
    },
    'pjltxv8v': {
      'en': 'Transfer type',
      'ar': 'نوع النقل',
      'vi': 'Kiểu chuyển',
    },
    'v2r1dlh4': {
      'en': 'Internal Transfer',
      'ar': 'التحويل الداخلي',
      'vi': 'Chuyển nội bộ',
    },
    'trd84dis': {
      'en': 'External Transfer',
      'ar': 'نقل خارجي',
      'vi': 'Chuyển khoản bên ngoài',
    },
    'd5n27mwd': {
      'en': 'ACH Payment',
      'ar': 'الدفع عبر ACH',
      'vi': 'Thanh toán ACH',
    },
    'sut6gbhe': {
      'en': 'Transfer Type',
      'ar': 'نوع النقل',
      'vi': 'Loại chuyển',
    },
    'ks1k9ld0': {
      'en': 'Account',
      'ar': 'حساب',
      'vi': 'Tài khoản',
    },
    'at0kn69v': {
      'en': 'Select Account',
      'ar': 'حدد حساب',
      'vi': 'Chọn tài khoản',
    },
    '9h7dbdxv': {
      'en': 'Account ****2010',
      'ar': 'الحساب ****2010',
      'vi': 'Tài khoản ****2010',
    },
    'mo20dtfv': {
      'en': 'Account ****2011',
      'ar': 'الحساب ****2011',
      'vi': 'Tài khoản ****2011',
    },
    'm4lj06oh': {
      'en': 'Account ****2012',
      'ar': 'الحساب ****2012',
      'vi': 'Tài khoản ****2012',
    },
    'hg4nab9x': {
      'en': 'Choose an Account',
      'ar': 'اختيار حساب',
      'vi': 'Chọn một tài khoản',
    },
    'drpnsezr': {
      'en': 'Amount',
      'ar': 'كمية',
      'vi': 'Số lượng',
    },
    'mikxtr7z': {
      'en': 'Your current balance:',
      'ar': 'رصيدك الحالي:',
      'vi': 'Số dư hiện tại của bạn:',
    },
    '69029o9e': {
      'en': '\$7,630',
      'ar': '7,630 دولار',
      'vi': '\$7,630',
    },
    '9vu9xcur': {
      'en': 'Or',
      'ar': 'أو',
      'vi': 'Hoặc',
    },
    'szvozgsg': {
      'en': 'Scan Payment',
      'ar': 'مسح الدفع',
      'vi': 'Quét thanh toán',
    },
    'hbinoze8': {
      'en': 'Cancel',
      'ar': 'يلغي',
      'vi': 'Hủy bỏ',
    },
    '1mpq4mv4': {
      'en': 'Send Transfer',
      'ar': 'إرسال نقل',
      'vi': 'Gửi chuyển khoản',
    },
    'umwc3lc6': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // MarketPage
  {
    'yuz0ar1c': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // SelectLanguagePage
  {
    'cnc2a7kn': {
      'en': 'Change Language',
      'ar': 'تغيير اللغة',
      'vi': 'Thay đổi ngôn ngữ',
    },
    'yi7h9iqo': {
      'en': 'Apply',
      'ar': 'يتقدم',
      'vi': 'Áp dụng',
    },
    'tox2fkuw': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // InitialAfterSignInPage
  {
    'kls2a0ck': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // TermOfServiceAndPrivacyPolicyPage
  {
    'ln6ihkb3': {
      'en': 'Logout',
      'ar': 'تسجيل خروج',
      'vi': 'Đăng xuất',
    },
    'ovw4ksp4': {
      'en': 'Term of Service',
      'ar': 'شروط الخدمة',
      'vi': 'Điều khoản dịch vụ',
    },
    'sb815feb': {
      'en': 'Privacy Policy',
      'ar': 'سياسة الخصوصية',
      'vi': 'Chính sách bảo mật',
    },
    'l6rxib8x': {
      'en': 'I\'ve read and agree to the ',
      'ar': 'لقد قرأت ووافقت على',
      'vi': 'Tôi đã đọc và đồng ý với',
    },
    'zfszy2xl': {
      'en': 'Term of Service',
      'ar': 'شرط الخدمة',
      'vi': 'Hạn của dịch vụ',
    },
    'x0c3ht3x': {
      'en': ' and ',
      'ar': ' و ',
      'vi': ' và ',
    },
    'lnywo5pe': {
      'en': 'Privacy Policy',
      'ar': 'سياسة الخصوصية',
      'vi': 'Chính sách bảo mật',
    },
    '8lqdtz8h': {
      'en': 'Accept',
      'ar': 'يقبل',
      'vi': 'Chấp nhận',
    },
    'vpe2dnt0': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // SignDocumentPage
  {
    'nx64605t': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
  },
  // confirm_signature_dialog
  {
    'apuqhrbh': {
      'en': 'Please confirm',
      'ar': 'يرجى تأكيد',
      'vi': 'Vui lòng xác nhận',
    },
    'c4m8fcp2': {
      'en': 'Reject',
      'ar': 'يرفض',
      'vi': 'Từ chối',
    },
    'e1wyk8ql': {
      'en': 'Accept',
      'ar': 'يقبل',
      'vi': 'Chấp nhận',
    },
    'b417i60t': {
      'en': 'Cancel',
      'ar': 'يلغي',
      'vi': 'Hủy bỏ',
    },
  },
  // transactions_list_item
  {
    'nkc71403': {
      'en': 'Security Name',
      'ar': 'اسم الأمان',
      'vi': 'Tên bảo mật',
    },
    'xc0jtpk9': {
      'en': 'Status',
      'ar': 'حالة',
      'vi': 'Trạng thái',
    },
    'j72npzob': {
      'en': 'Type',
      'ar': 'يكتب',
      'vi': 'Kiểu',
    },
    'fyy6awn3': {
      'en': 'Portfolio Name',
      'ar': 'اسم المحفظة',
      'vi': 'Tên danh mục đầu tư',
    },
    'qwicoekk': {
      'en': 'Security Name',
      'ar': 'اسم الأمان',
      'vi': 'Tên bảo mật',
    },
    '691qwpww': {
      'en': 'Quantity',
      'ar': 'كمية',
      'vi': 'Số lượng',
    },
    'xopvpm3o': {
      'en': 'Price',
      'ar': 'سعر',
      'vi': 'Giá',
    },
    'pgdm3cxj': {
      'en': 'Amount',
      'ar': 'كمية',
      'vi': 'Số lượng',
    },
    'yx8usjux': {
      'en': 'Trade Date',
      'ar': 'موعد المبادلة',
      'vi': 'Ngày giao dịch',
    },
    '7r8yq7mw': {
      'en': 'Status',
      'ar': 'حالة',
      'vi': 'Trạng thái',
    },
  },
  // proposal_list_item
  {
    '75vcm9jx': {
      'en': 'Type',
      'ar': 'يكتب',
      'vi': 'Kiểu',
    },
    'yow754bx': {
      'en': 'Advisor',
      'ar': 'مستشار',
      'vi': 'Cố vấn',
    },
    'c1i8ilcn': {
      'en':
          'We believe you are over allocated in GE and are better suited to diversify into technology sector.',
      'ar':
          'نعتقد أنك مُخصص أكثر من اللازم في شركة جنرال إلكتريك وأنك أكثر ملاءمة للتنويع في قطاع التكنولوجيا.',
      'vi':
          'Chúng tôi tin rằng bạn đang được phân bổ quá mức vào GE và phù hợp hơn để đa dạng hóa sang lĩnh vực công nghệ.',
    },
    'y4rezelu': {
      'en': 'ADDITIONAL, COMMENTARY FROM ADVISOR',
      'ar': 'تعليق إضافي من المستشار',
      'vi': 'BỔ SUNG, BÌNH LUẬN TỪ NGƯỜI CỐ VẤN',
    },
    '1wdyw1a0': {
      'en':
          'We\'ve gotten word that GE is about post a bad quarter, so we recommend you sell your position and pick up more Apple',
      'ar':
          'لقد تلقينا أخبارًا تفيد بأن شركة GE على وشك نشر ربع سنوي سيئ، لذا نوصيك ببيع مركزك والحصول على المزيد من Apple',
      'vi':
          'Chúng tôi được biết GE sắp có một quý tồi tệ, vì vậy chúng tôi khuyên bạn nên bán vị thế của mình và mua thêm Apple',
    },
    '99qsbuko': {
      'en': 'Last update',
      'ar': 'اخر تحديث',
      'vi': 'Cập nhật cuối cùng',
    },
    'ke604v9b': {
      'en': 'PREVIEW PROPOSAL',
      'ar': 'عرض المعاينة',
      'vi': 'XEM TRƯỚC ĐỀ XUẤT',
    },
    'prtogarh': {
      'en': 'I read the documents and agree to the terms of the proposal',
      'ar': 'قرأت المستندات وأوافق على شروط الاقتراح',
      'vi': 'Tôi đã đọc tài liệu và đồng ý với các điều khoản của đề xuất',
    },
    '30l50bfj': {
      'en': 'Decline',
      'ar': 'رفض',
      'vi': 'Từ chối',
    },
    'decline_proposal': {
      'en': 'Decline Proposal ?',
      'ar': 'رفض الاقتراح؟',
      'vi': 'Từ chối đề xuất?',
    },
    'accept_proposal': {
      'en': 'Accept Proposal ?',
      'ar': 'قبول الاقتراح؟',
      'vi': 'Chấp nhận đề xuất?',
    },
    '3esw1ind': {
      'en': 'Accept',
      'ar': 'يقبل',
      'vi': 'Chấp nhận',
    },
    'a7lwigx2': {
      'en': 'Declined at',
      'ar': 'رفض في',
      'vi': 'Bị từ chối tại',
    },
    'uolmr1cx': {
      'en': 'Accepted at',
      'ar': 'مقبول في',
      'vi': 'Được chấp nhận tại',
    },
    's1juvlo2': {
      'en': 'OR',
      'ar': 'أو',
      'vi': 'HOẶC',
    },
    'fbk0uba7': {
      'en': 'Call your advisor',
      'ar': 'اتصل بمستشارك',
      'vi': 'Gọi cố vấn của bạn',
    },
    'pkkj5rta': {
      'en': 'Chat with your advisor',
      'ar': 'الدردشة مع المستشار الخاص بك',
      'vi': 'Trò chuyện với cố vấn của bạn',
    },
    'chat': {
      'en': 'Chat',
      'ar': 'محادثة',
      'vi': 'trò chuyện',
    },
    'dperp1f4': {
      'en': 'Schedule appointment',
      'ar': 'تحديد موعد',
      'vi': 'Lịch hẹn',
    },
    'mlj5814u': {
      'en': 'PROPOSAL',
      'ar': 'عرض',
      'vi': 'Đề xuất',
    },
    'sd43hio2': {
      'en': 'Schedule Appointment',
      'ar': 'تحديد موعد',
      'vi': 'Lịch hẹn',
    },
  },
  // bottom_navigation_bar
  {
    'rkobqzvw': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
    'uak0wsex': {
      'en': 'Portfolio',
      'ar': 'مَلَفّ',
      'vi': 'danh mục đầu tư',
    },
    'eg1yw963': {
      'en': 'Transactions',
      'ar': 'عملية',
      'vi': 'Giao dịch',
    },
    '1vddbh59': {
      'en': 'DOCUMENTS',
      'ar': 'وثيقة',
      'vi': 'Tài liệu',
    },
    '0po64aet': {
      'en': 'Proposal',
      'ar': 'عرض',
      'vi': 'Đề xuất',
    },
    'hello': {
      'en': 'Hello! How can I assist you?',
      'ar': 'مرحبًا! كيف يمكنني مساعدتك؟',
      'vi': 'Xin chào! Tôi có thể giúp gì cho bạn?',
    },
    'jmpup8vw': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
    'u9g83xki': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
    'mdc6xyu6': {
      'en': 'Portfolio',
      'ar': 'مَلَفّ',
      'vi': 'Đầu tư',
    },
    '4ihsur3q': {
      'en': 'Portfolio',
      'ar': 'مَلَفّ',
      'vi': 'Đầu tư',
    },
    'd33p2mgm': {
      'en': 'Market',
      'ar': 'سوق',
      'vi': 'Chợ',
    },
    'khwv42ow': {
      'en': 'Document',
      'ar': 'وثيقة',
      'vi': 'Tài liệu',
    },
    'wux5rc10': {
      'en': 'Document',
      'ar': 'وثيقة',
      'vi': 'Tài liệu',
    },
    '5u97oz1q': {
      'en': 'Proposal',
      'ar': 'عرض',
      'vi': 'Đề xuất',
    },
    '6kq446fx': {
      'en': 'Proposal',
      'ar': 'عرض',
      'vi': 'Đề xuất',
    },
  },
  // home_page_view
  {
    'ran9xdwl': {
      'en': 'POPULAR',
      'ar': 'شائع',
      'vi': 'Phổ biến',
    },
    'lwqxf341': {
      'en': 'No News Today',
      'ar': '',
      'vi': '',
    },
    'gln3vyrv': {
      'en': 'RECOMMENDED',
      'ar': 'موصى به',
      'vi': 'Được đề xuất',
    },
    'g2rxi1c1': {
      'en': 'Favourite selection',
      'ar': 'الاختيار المفضل',
      'vi': 'Lựa chọn yêu thích',
    },
    'yiyjkffh': {
      'en': 'REFRESH',
      'ar': 'ينعش',
      'vi': 'Làm mới',
    },
    'yj6g8w9q': {
      'en': 'Swipe left',
      'ar': 'اسحب لليسار',
      'vi': 'Vuốt sang trái',
    },
    '35ozpi3w': {
      'en': 'Swipe right',
      'ar': 'اسحب لليمين',
      'vi': 'Vuốt sang phải',
    },
  },
  // portfolio_page_view
  {
    'pzvyvrig': {
      'en': 'Portfolio',
      'ar': 'مَلَفّ',
      'vi': 'Danh mục đầu tư',
    },
    'l0x6h75l': {
      'en': 'No Portfolio Found',
      'ar': 'لم يتم العثور على محفظة',
      'vi': 'Không tìm thấy danh mục đầu tư',
    },
    '1ozb665k': {
      'en': 'No portfolio found',
      'ar': 'لم يتم العثور على محفظة',
      'vi': 'Không tìm thấy danh mục đầu tư',
    },
  },
  // transactions_page_view
  {
    '1ixt6js5': {
      'en': 'Transaction',
      'ar': 'عملية',
      'vi': 'Giao dịch',
    },
    'n93guv4x': {
      'en': 'All',
      'ar': 'الجميع',
      'vi': 'Tất cả',
    },
    '5xbdmla8': {
      'en': 'Portfolio 1',
      'ar': 'المحفظة 1',
      'vi': 'Danh mục đầu tư 1',
    },
    'ojyp5aek': {
      'en': 'Porfolio 2',
      'ar': 'المحفظة 2',
      'vi': 'Danh mục đầu tư 2',
    },
    'dmr0x7ur': {
      'en': 'Porfolio 3',
      'ar': 'المحفظة 3',
      'vi': 'Danh mục đầu tư 3',
    },
    'kscwd35k': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'uv5le3hr': {
      'en': 'Porfolio\'s name',
      'ar': 'اسم بورفوليو',
      'vi': 'Tên của danh mục đầu tư',
    },
    'u52470kh': {
      'en': 'No Transactions Found',
      'ar': 'لم يتم العثور على أي معاملات',
      'vi': 'Không tìm thấy giao dịch nào',
    },
    '449komyb': {
      'en': 'No Transactions Found',
      'ar': 'لم يتم العثور على أي معاملات',
      'vi': 'Không tìm thấy giao dịch nào',
    },
  },
  // proposal_page_view
  {
    'lt49c1mu': {
      'en': 'Proposal',
      'ar': 'عرض',
      'vi': 'Đề xuất',
    },
    't7tz8m1x': {
      'en': 'A-Z',
      'ar': 'من الألف إلى الياء',
      'vi': 'A-Z',
    },
    'lkq0botg': {
      'en': 'Z-A',
      'ar': 'Z-A',
      'vi': 'Z-A',
    },
    'wdlmnbeh': {
      'en': 'Newest',
      'ar': 'الأحدث',
      'vi': 'Mới nhất',
    },
    'gxc8dzyc': {
      'en': 'Oldest',
      'ar': 'الأقدم',
      'vi': 'Cũ nhất',
    },
    'tb72su8o': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'r3f0hrjr': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
  },
  // file_document_list_item
  {
    '93z66pdg': {
      'en': 'Document',
      'ar': 'وثيقة',
      'vi': 'Tài liệu',
    },
    '0c3w378f': {
      'en': 'Rejected at ',
      'ar': 'مرفوض عند',
      'vi': 'Bị từ chối tại',
    },
    'c64nnx2a': {
      'en': 'Accepted at ',
      'ar': 'مقبول في',
      'vi': 'Được chấp nhận tại',
    },
    'b4bbsw9r': {
      'en': 'Document',
      'ar': 'وثيقة',
      'vi': 'Tài liệu',
    },
  },
  // document_page_view
  {
    'gedmceci': {
      'en': 'A-Z',
      'ar': 'من الألف إلى الياء',
      'vi': 'A-Z',
    },
    '7ifi5rzq': {
      'en': 'Z-A',
      'ar': 'Z-A',
      'vi': 'Z-A',
    },
    '100mebqo': {
      'en': 'Newest',
      'ar': 'الأحدث',
      'vi': 'Mới nhất',
    },
    'f92uq3rg': {
      'en': 'Oldest',
      'ar': 'الأقدم',
      'vi': 'Cũ nhất',
    },
    '2p7wurjj': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'h4estl7l': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
    'qsv6jc1u': {
      'en': 'Upload',
      'ar': 'رفع',
      'vi': 'Tải lên',
    },
  },
  // confirm_cancel_dialog
  {
    'zu3zuhvo': {
      'en': 'Confirm?',
      'ar': 'يتأكد؟',
      'vi': 'Xác nhận?',
    },
    's1jcpzx6': {
      'en': 'Cancel',
      'ar': 'يلغي',
      'vi': 'Hủy bỏ',
    },
    'bdc48oru': {
      'en': 'Confirm',
      'ar': 'يتأكد',
      'vi': 'Xác nhận',
    },
  },
  // positions_list_item
  {
    'tea2m5lq': {
      'en': 'Allocation',
      'ar': 'توزيع',
      'vi': 'Phân bổ',
    },
    'e0dy1vxx': {
      'en': 'ROI',
      'ar': 'عائد الاستثمار',
      'vi': 'ROI',
    },
    '4kttzprb': {
      'en': 'Name',
      'ar': 'اسم',
      'vi': 'Tên',
    },
    '6thwwafn': {
      'en': 'ISIN',
      'ar': 'ISIN',
      'vi': 'ISIN',
    },
    'ivu9tdzj': {
      'en': 'Currency',
      'ar': 'عملة',
      'vi': 'Tiền tệ',
    },
    'fbgy82bc': {
      'en': 'Last Price',
      'ar': 'السعر الاخير',
      'vi': 'Giá cuối cùng',
    },
    'swv2ctiz': {
      'en': 'Cost Price',
      'ar': 'سعر الكلفة',
      'vi': 'Giá cả',
    },
    'cdklrlbv': {
      'en': 'ROI',
      'ar': 'ROI',
      'vi': 'ROI',
    },
    'ox3fj6xq': {
      'en': 'Quantity',
      'ar': 'كمية',
      'vi': 'Số lượng',
    },
    'juhk5a4f': {
      'en': 'Amount',
      'ar': 'كمية',
      'vi': 'Số lượng',
    },
    'xai3n31z': {
      'en': 'Allocation',
      'ar': 'توزيع',
      'vi': 'Phân bổ',
    },
  },
  // position_bottom_sheet
  {
    'qhszshsn': {
      'en': 'Position as of',
      'ar': 'الموقف اعتبارا من',
      'vi': 'Vị trí tính đến thời điểm',
    },
    'zjpj3rb3': {
      'en': 'A-Z',
      'ar': 'من الألف إلى الياء',
      'vi': 'A-Z',
    },
    'qdw51x3q': {
      'en': 'Z-A',
      'ar': 'Z-A',
      'vi': 'Z-A',
    },
    'rp3i5rcp': {
      'en': 'Newest',
      'ar': 'الأحدث',
      'vi': 'Mới nhất',
    },
    'agree_checkbox': {
      'en': 'Please check the checkbox first',
      'ar': 'يرجى تحديد خانة الاختيار أولا',
      'vi': 'Vui lòng tích vào hộp kiểm trước',
    },
    '5dpmi95h': {
      'en': 'Oldest',
      'ar': 'الأقدم',
      'vi': 'Cũ nhất',
    },
    'ar99rnrl': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    '9j789sh8': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
  },
  // document_filter_dialog
  {
    'yfas6pma': {
      'en': 'Filter options',
      'ar': 'خيارات التصفية',
      'vi': 'Tùy chọn bộ lọc',
    },
    'filter': {
      'en': 'FILTER',
      'ar': 'فلتر',
      'vi': 'Lọc',
    },
    'sort': {
      'en': 'SORT',
      'ar': 'نوع',
      'vi': 'LOẠI',
    },
    'xccshnlg': {
      'en': 'Accounts',
      'ar': 'حسابات',
      'vi': 'Tài khoản',
    },
    'nhu5w9hh': {
      'en': 'All Accounts',
      'ar': 'جميع الحسابات',
      'vi': 'Tất cả các tài khoản',
    },
    'rfz2zg29': {
      'en': 'Account 1',
      'ar': 'الحساب 1',
      'vi': 'Tài khoản 1',
    },
    'e8wn77rc': {
      'en': 'Account 2',
      'ar': 'الحساب 2',
      'vi': 'Tài khoản 2',
    },
    'kwzaqasj': {
      'en': 'Account 3',
      'ar': 'الحساب 3',
      'vi': 'Tài khoản 3',
    },
    'coeh05ty': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'ip67vees': {
      'en': 'Search for an account',
      'ar': 'ابحث عن حساب',
      'vi': 'Tìm kiếm tài khoản',
    },
    'bzc91fwt': {
      'en': 'File name',
      'ar': 'اسم الملف',
      'vi': 'Tên tập tin',
    },
    'oxhc1io0': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '1mrmlye5': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '4n2ah71g': {
      'en': 'Types',
      'ar': 'أنواع',
      'vi': 'Các loại',
    },
    'date_in_range': {
      'en': 'Date in range',
      'ar': 'التاريخ في النطاق',
      'vi': 'Ngày trong phạm vi',
    },
    '62i1ajo9': {
      'en': 'All',
      'ar': 'الجميع',
      'vi': 'Tất cả',
    },
    '1bjf87l7': {
      'en': 'Document',
      'ar': 'وثيقة',
      'vi': 'Tài liệu',
    },
    '6ihgprib': {
      'en': 'Form',
      'ar': 'استمارة',
      'vi': 'Hình thức',
    },
    'lhntzq4q': {
      'en': 'Package',
      'ar': 'طَرد',
      'vi': 'Bưu kiện',
    },
    'qdkc9pfm': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    '6b02yqcj': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
    'wy8o7ldl': {
      'en': 'From',
      'ar': 'من',
      'vi': 'Từ',
    },
    '6idca4xe': {
      'en': 'To',
      'ar': 'ل',
      'vi': 'Đến',
    },
    'zw535eku': {
      'en': 'CLEAR',
      'ar': 'يمسح',
      'vi': 'Xoá',
    },
    'r8wu2qe3': {
      'en': 'APPLY',
      'ar': 'يتقدم',
      'vi': 'Áp dụng',
    },
  },
  // add_transaction_fee_tax_form
  {
    '9hzz5hen': {
      'en': 'Fee / Tax',
      'ar': 'الرسوم / الضريبة',
      'vi': 'Phí/Thuế',
    },
    'jpbn01j5': {
      'en': 'Remove',
      'ar': 'يزيل',
      'vi': 'Di dời',
    },
    '3i2s2bd9': {
      'en': 'Transaction type*',
      'ar': 'نوع المعاملة*',
      'vi': 'Loại giao dịch*',
    },
    'wdaoe5f4': {
      'en': 'Clearing Fee',
      'ar': 'رسوم المقاصة',
      'vi': 'Phí thanh toán bù trừ',
    },
    'yiwodewa': {
      'en': 'Commision',
      'ar': 'عمولة',
      'vi': 'hoa hồng',
    },
    'a9s6u8xz': {
      'en': 'Custodian Fee',
      'ar': 'رسوم الحفظ',
      'vi': 'Phí giám sát',
    },
    '0umijckp': {
      'en': 'Fund Fee',
      'ar': 'رسوم الصندوق',
      'vi': 'Phí quỹ',
    },
    '9jezwoj1': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'k1codtqp': {
      'en': 'Currency*',
      'ar': 'عملة*',
      'vi': 'Tiền tệ*',
    },
    'd43g8v0j': {
      'en': 'USD - US Dollar',
      'ar': 'الدولار الأمريكي - الدولار الأمريكي',
      'vi': 'USD - Đô la Mỹ',
    },
    'hbwnm79e': {
      'en': 'VND - Vietnamese Dong',
      'ar': 'VND - دونج فيتنامي',
      'vi': 'VNĐ - Đồng Việt Nam',
    },
    'qxtq12f8': {
      'en': 'THB - Thai Baht',
      'ar': 'THB - البات التايلندي',
      'vi': 'THB - Baht Thái',
    },
    'o8pib8tf': {
      'en': 'JPY - Japenese Yen',
      'ar': 'الين الياباني - الين الياباني',
      'vi': 'JPY - Yên Nhật',
    },
    'wofbw4p8': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    '4m3apom6': {
      'en': 'Search for an item...',
      'ar': 'البحث عن عنصر...',
      'vi': 'Tìm kiếm một mục...',
    },
    'onmbhjgg': {
      'en': 'Amount*',
      'ar': 'كمية*',
      'vi': 'Số lượng*',
    },
    'jqb51s6q': {
      'en': 'Notes',
      'ar': 'ملحوظات',
      'vi': 'Ghi chú',
    },
  },
  // adviso_contact_method_dialog
  {
    'r66fygfn': {
      'en': 'Contact Advisor',
      'ar': 'اتصل بالمستشار',
      'vi': 'Liên hệ tư vấn',
    },
    'k3ixxnvv': {
      'en': 'Call to: ',
      'ar': 'دعوة ل:',
      'vi': 'Gọi tới:',
    },
    't91ag05n': {
      'en': 'Request to be called',
      'ar': 'طلب أن يتم الاتصال به',
      'vi': 'Yêu cầu được gọi',
    },
  },
  // select_file_options_bottom_sheet
  {
    'xg6l8kqn': {
      'en': 'Albums',
      'ar': 'الألبومات',
      'vi': 'Tập ảnh',
    },
    '2w13s18z': {
      'en': 'Camera',
      'ar': 'آلة تصوير',
      'vi': 'Máy ảnh',
    },
    'neu1xpka': {
      'en': 'Folder',
      'ar': 'مجلد',
      'vi': 'Thư mục',
    },
  },
  // proposal_filter_dialog
  {
    '79c9j9tz': {
      'en': 'Filter options',
      'ar': 'خيارات التصفية',
      'vi': 'Tùy chọn bộ lọc',
    },
    'uvch601w': {
      'en': 'Advisor',
      'ar': 'مستشار',
      'vi': 'Cố vấn',
    },
    '52i8slyz': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '58gmka4m': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'rvrrcr87': {
      'en': 'Proposal name',
      'ar': 'اسم الاقتراح',
      'vi': 'Tên đề xuất',
    },
    '3lusoo7q': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '48bz3ofm': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'tl67wc2i': {
      'en': 'Types',
      'ar': 'أنواع',
      'vi': 'Các loại',
    },
    'ti52gke6': {
      'en': 'All',
      'ar': 'الجميع',
      'vi': 'Tất cả',
    },
    'stsemzk4': {
      'en': 'New Buy',
      'ar': 'شراء جديد',
      'vi': 'Mua mới',
    },
    '6p82d124': {
      'en': 'Suggest Sell',
      'ar': 'أقترح بيع',
      'vi': 'Đề nghị bán',
    },
    '7erqfhgc': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'i76kvnmi': {
      'en': 'Search for proposal type...',
      'ar': 'البحث عن نوع الاقتراح...',
      'vi': 'Tìm kiếm loại đề xuất...',
    },
    '7hue4ywl': {
      'en': 'From',
      'ar': 'من',
      'vi': 'Từ',
    },
    'lyqt7dgr': {
      'en': 'To',
      'ar': 'ل',
      'vi': 'Đến',
    },
    'g7rr5vmv': {
      'en': 'Clear',
      'ar': 'واضح',
      'vi': 'Xoá',
    },
    'lmndaaco': {
      'en': 'Apply',
      'ar': 'يتقدم',
      'vi': 'Áp dụng',
    },
  },
  // transaction_bottom_sheet
  {
    'dx3hqly7': {
      'en': 'Transaction as of',
      'ar': 'الصفقة اعتبارا من',
      'vi': 'Giao dịch kể từ',
    },
  },
  // market_page_view
  {
    'prsblk0u': {
      'en': 'Market',
      'ar': 'سوق',
      'vi': 'Chợ',
    },
    'wzls4zjf': {
      'en': 'Type security name',
      'ar': 'اكتب اسم الأمان',
      'vi': 'Nhập tên bảo mật',
    },
  },
  // market_list_item
  {
    '7v8svtoq': {
      'en': 'NEW TRANSACTION',
      'ar': 'معاملة جديدة',
      'vi': 'Giao dịch mới',
    },
  },
  // market_filter_dialog
  {
    '7s9c8pxs': {
      'en': 'Filter options',
      'ar': 'خيارات التصفية',
      'vi': 'Tùy chọn bộ lọc',
    },
    '1p01lh7n': {
      'en': 'Asset Class',
      'ar': 'فئة الأصول',
      'vi': 'Loại tài sản',
    },
    'q1rji7uu': {
      'en': 'All',
      'ar': 'الجميع',
      'vi': 'Tất cả',
    },
    '0j3ikcyz': {
      'en': 'Alternative Investment',
      'ar': 'الاستثمار البديل',
      'vi': 'Đầu tư thay thế',
    },
    '2wib8de2': {
      'en': 'Bond',
      'ar': 'رابطة',
      'vi': 'Liên kết',
    },
    'ub3zx1xd': {
      'en': 'Cfd',
      'ar': 'عقود الفروقات',
      'vi': 'Cfd',
    },
    '47ohy39v': {
      'en': 'Collectible',
      'ar': 'تحصيل',
      'vi': 'sưu tầm',
    },
    'fucq1c6t': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'sotc1ho8': {
      'en': 'Search for an asset class',
      'ar': 'ابحث عن فئة الأصول',
      'vi': 'Tìm kiếm một loại tài sản',
    },
    'zfneqwjq': {
      'en': 'Industry',
      'ar': 'صناعة',
      'vi': 'Ngành công nghiệp',
    },
    'd63k4veh': {
      'en': 'All',
      'ar': 'الجميع',
      'vi': 'Tất cả',
    },
    'hvikpfj5': {
      'en': 'Industrial',
      'ar': 'صناعي',
      'vi': 'Công nghiệp',
    },
    'dv5qr0ef': {
      'en': 'Health Care',
      'ar': 'الرعاىة الصحية',
      'vi': 'Chăm sóc sức khỏe',
    },
    'kwbxaj2d': {
      'en': 'Consumer services',
      'ar': 'خدمات المستهلك',
      'vi': 'Dịch vụ tiêu dùng',
    },
    '8f8r6kpl': {
      'en': 'Ultilities',
      'ar': 'المرافق',
      'vi': 'Tiện ích',
    },
    'duc5sq25': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    '8ltvrr9u': {
      'en': 'Search for an industry',
      'ar': 'ابحث عن صناعة',
      'vi': 'Tìm kiếm một ngành',
    },
    'nkjefkra': {
      'en': 'Currency',
      'ar': 'عملة',
      'vi': 'Tiền tệ',
    },
    '9kbotd9v': {
      'en': 'All',
      'ar': 'الجميع',
      'vi': 'Tất cả',
    },
    '3wp2osm7': {
      'en': 'AED - Emirati Dirham',
      'ar': 'درهم إماراتي - درهم إماراتي',
      'vi': 'AED - Dirham của Tiểu vương quốc Ả Rập thống nhất',
    },
    'dnclvhao': {
      'en': 'USD - US Dollar',
      'ar': 'الدولار الأمريكي - الدولار الأمريكي',
      'vi': 'USD - Đô la Mỹ',
    },
    '2i05dwg2': {
      'en': 'VND - Vietnamese Dong',
      'ar': 'VND - دونج فيتنامي',
      'vi': 'VNĐ - Đồng Việt Nam',
    },
    'msy6t7we': {
      'en': 'Please select...',
      'ar': 'الرجاء التحديد...',
      'vi': 'Vui lòng chọn...',
    },
    'ng4uvnyc': {
      'en': 'Search for a currency',
      'ar': 'ابحث عن عملة',
      'vi': 'Tìm kiếm một loại tiền tệ',
    },
    'jc3m5lbr': {
      'en': 'From',
      'ar': 'من',
      'vi': 'Từ',
    },
    'ww0vqchu': {
      'en': 'To',
      'ar': 'ل',
      'vi': 'Đến',
    },
    'h9jg8nf9': {
      'en': 'Clear',
      'ar': 'واضح',
      'vi': 'Xoá',
    },
    'lafovd94': {
      'en': 'Apply',
      'ar': 'يتقدم',
      'vi': 'Áp dụng',
    },
  },
  // bottom_nav_bar_with_center_actions_menu
  {
    'fiha8uf5': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
    'p38uhcf6': {
      'en': 'Home',
      'ar': 'بيت',
      'vi': 'Trang chủ',
    },
    'xn2nrgyp': {
      'en': 'Portfolio',
      'ar': 'مَلَفّ',
      'vi': 'danh mục đầu tư',
    },
    'new_order': {
      'en': 'NEW ORDER',
      'ar': 'طلب جديد',
      'vi': 'Đơn hàng mới',
    },
    'more': {
      'en': 'More',
      'ar': 'أكثر',
      'vi': 'hơn',
    },
    'a850huyh': {
      'en': 'Portfolio',
      'ar': 'مَلَفّ',
      'vi': 'danh mục đầu tư',
    },
    'nkifu7jq': {
      'en': 'Proposal',
      'ar': 'عرض',
      'vi': 'Đề xuất',
    },
    '32ibm5x3': {
      'en': 'Proposal',
      'ar': 'عرض',
      'vi': 'Đề xuất',
    },
    'w5wtcpj4': {
      'en': 'Profile',
      'ar': 'حساب تعريفي',
      'vi': 'Hồ sơ',
    },
    'e9g2ybjp': {
      'en': 'Profile',
      'ar': 'حساب تعريفي',
      'vi': 'Hồ sơ',
    },
    '5pxwycp5': {
      'en': 'Notification',
      'ar': 'إشعار',
      'vi': 'Thông báo',
    },
    'v9vw92bm': {
      'en': 'Profile',
      'ar': 'حساب تعريفي',
      'vi': 'Hồ sơ',
    },
    'slptsuin': {
      'en': 'Market',
      'ar': 'سوق',
      'vi': 'Chợ',
    },
    'd696b0mg': {
      'en': 'New Trade',
      'ar': 'تجارة جديدة',
      'vi': 'Giao dịch mới',
    },
    'nqqw2mxy': {
      'en': 'Transfer',
      'ar': 'تحويل',
      'vi': 'Chuyển khoản',
    },
    'ba57jiqz': {
      'en': 'Upload',
      'ar': 'رفع',
      'vi': 'Tải lên',
    },
    '13mzcnly': {
      'en': 'Documents',
      'ar': 'وثائق',
      'vi': 'Tài liệu',
    },
    'o5wm04m6': {
      'en': 'MARKET',
      'ar': 'سوق',
      'vi': 'Chợ',
    },
    't2nv4kvj': {
      'en': 'UPLOAD',
      'ar': 'رفع',
      'vi': 'Tải lên',
    },
  },
  // portfolio_issue_detail_bottom_sheet
  {
    'acyeoaaw': {
      'en': 'Portfolio Health Check',
      'ar': 'فحص صحة المحفظة',
      'vi': 'Kiểm tra tình trạng danh mục đầu tư',
    },
    'dxc8grzt': {
      'en': 'Suitability',
      'ar': 'ملاءمة',
      'vi': 'Sự phù hợp',
    },
    '3vkimctv': {
      'en': 'Appropriateness',
      'ar': 'ملاءمة',
      'vi': 'Sự phù hợp',
    },
  },
  // otp_input_dialog
  {
    '2gjb3gie': {
      'en': 'Login Verification',
      'ar': 'التحقق الدخول',
      'vi': 'Xác minh đăng nhập',
    },
    '4odbxp9t': {
      'en': 'Please input the code to continue',
      'ar': 'الرجاء إدخال الرمز للمتابعة',
      'vi': 'Vui lòng nhập mã để tiếp tục',
    },
    '4jp9h6pq': {
      'en':
          'Please confirm that your authentication application is working by entering a generated code below',
      'ar':
          'يرجى التأكد من أن تطبيق المصادقة الخاص بك يعمل عن طريق إدخال الرمز الذي تم إنشاؤه أدناه',
      'vi':
          'Vui lòng xác nhận rằng ứng dụng xác thực của bạn đang hoạt động bằng cách nhập mã được tạo bên dưới',
    },
    'u6n47sl4': {
      'en': 'Verifying...',
      'ar': 'جارٍ التحقق...',
      'vi': 'Đang xác minh...',
    },
    'v5jx3zzx': {
      'en': 'Didn\'t receive any code?',
      'ar': 'لم تتلق أي رمز؟',
      'vi': 'Không nhận được bất kỳ mã nào?',
    },
    'dumdc5yp': {
      'en': 'Resend',
      'ar': 'إعادة إرسال',
      'vi': 'Gửi lại',
    },
  },
  // portfolio_issue
  {
    'efkolajb': {
      'en': 'MINOR ISSUE',
      'ar': 'مسألة ثانوية',
      'vi': 'VẤN ĐỀ NHỎ',
    },
    '05djgw4o': {
      'en': 'MAJOR ISSUE',
      'ar': 'قضية كبرى',
      'vi': 'VẤN ĐỀ LỚN',
    },
    '834hxg71': {
      'en': 'Not checked',
      'ar': 'غير مدقق',
      'vi': 'Chưa được kiểm tra',
    },
    'bwcpcgd0': {
      'en':
          'The following investment are not in line with your financial knowledge',
      'ar': 'الاستثمارات التالية لا تتماشى مع معرفتك المالية',
      'vi':
          'Khoản đầu tư sau đây không phù hợp với kiến ​​thức tài chính của bạn',
    },
    'zz2ivcgu': {
      'en': 'No issues have been detected',
      'ar': 'لم يتم الكشف عن أي مشاكل',
      'vi': 'Không có vấn đề nào được phát hiện',
    },
  },
  // portfolio_list_item
  {
    '83o1ghax': {
      'en': 'NET VALUE',
      'ar': 'صافي القيمة',
      'vi': 'Giá trị ròng',
    },
    'hdgv1exn': {
      'en': 'Date',
      'ar': 'تاريخ',
      'vi': 'Ngày',
    },
    'cm2ob3q4': {
      'en': 'Net Value',
      'ar': 'صافي القيمة',
      'vi': 'Giá trị ròng',
    },
    'y6z0kvbz': {
      'en': 'Portfolio Value',
      'ar': 'قيمة المحفظة',
      'vi': 'Giá trị danh mục đầu tư',
    },
    '57fz6g1m': {
      'en': 'Amount Invested',
      'ar': 'المبلغ المستثمر',
      'vi': 'Số tiền đầu tư',
    },
    'rpfp7xvs': {
      'en': 'Cash Available',
      'ar': 'النقدية المتاحة',
      'vi': 'Tiền mặt có sẵn',
    },
    'zomhasya': {
      'en': 'Performance',
      'ar': 'أداء',
      'vi': 'Hiệu suất',
    },
    '7h0zeqv0': {
      'en': 'Asset Class',
      'ar': 'فئة الأصول',
      'vi': 'Loại tài sản',
    },
    'o00oeypg': {
      'en': 'Currency',
      'ar': 'عملة',
      'vi': 'Tiền tệ',
    },
    '6u2u1x9z': {
      'en': 'Health Alerts',
      'ar': 'التنبيهات الصحية',
      'vi': 'Cảnh báo sức khỏe',
    },
    '2um0eu09': {
      'en': 'Detail',
      'ar': 'التفاصيل',
      'vi': 'Chi tiết',
    },
    'kc4yx2mm': {
      'en': 'MINOR ISSUES',
      'ar': 'قضايا بسيطة',
      'vi': 'VẤN ĐỀ NHỎ',
    },
    'ko88t7mf': {
      'en': 'MAJOR ISSUES',
      'ar': 'القضايا الرئيسية',
      'vi': 'NHỮNG VẤN ĐỀ CHÍNH',
    },
    'iekoi9ve': {
      'en': 'Net Value',
      'ar': 'صافي القيمة',
      'vi': 'Giá trị ròng',
    },
    'kru31dvl': {
      'en': 'Date',
      'ar': 'تاريخ',
      'vi': 'Ngày',
    },
    'ujzajz87': {
      'en': 'Net Value',
      'ar': 'صافي القيمة',
      'vi': 'Giá trị ròng',
    },
    'rkja9ftb': {
      'en': 'Portfolio Value',
      'ar': 'قيمة المحفظة',
      'vi': 'Giá trị danh mục đầu tư',
    },
    '5a5e578w': {
      'en': 'Amount Invested',
      'ar': 'المبلغ المستثمر',
      'vi': 'Số tiền đầu tư',
    },
    '3cxv72l0': {
      'en': 'Cash Available',
      'ar': 'النقدية المتاحة',
      'vi': 'Tiền mặt có sẵn',
    },
    'obobi365': {
      'en': 'Performance',
      'ar': 'أداء',
      'vi': 'Hiệu suất',
    },
    'our3nuo4': {
      'en': 'Asset Class',
      'ar': 'فئة الأصول',
      'vi': 'Loại tài sản',
    },
    '0vemdgda': {
      'en': 'Currency',
      'ar': 'عملة',
      'vi': 'Tiền tệ',
    },
    'ytnf6slz': {
      'en': 'Health Alerts',
      'ar': 'التنبيهات الصحية',
      'vi': 'Cảnh báo sức khỏe',
    },
    '2uu2puwh': {
      'en': 'Detail',
      'ar': 'التفاصيل',
      'vi': 'Chi tiết',
    },
    'neadxzz8': {
      'en': 'MINOR ISSUES',
      'ar': 'مسألة ثانوية',
      'vi': 'VẤN ĐỀ NHỎ',
    },
    '0plh6q0q': {
      'en': 'MAJOR ISSUES',
      'ar': 'قضية كبرى',
      'vi': 'VẤN ĐỀ LỚN',
    },
    'd8zszkbn': {
      'en': 'POSITIONS',
      'ar': 'المواقف',
      'vi': 'Vị trí',
    },
    'position': {
      'en': 'Positions',
      'ar': 'المواقف',
      'vi': 'Vị trí',
    },
    'u192lk22': {
      'en': 'TRANSACTIONS',
      'ar': 'المعاملات',
      'vi': 'Giao dịch',
    },
  },
  // news_feed_swipe_card
  {
    '5tqbxl7s': {
      'en': 'Read',
      'ar': 'يقرأ',
      'vi': 'Đọc',
    },
  },
  // qr_view_dialog
  {
    '0em7xr1j': {
      'en': 'Scan  QR Code',
      'ar': 'مسح رمز الاستجابة السريعة',
      'vi': 'Quét mã QR',
    },
    '7gd5sfox': {
      'en': 'If you cannot scan, please enter the following code manually',
      'ar':
          'إذا لم تتمكن من إجراء المسح الضوئي، فيرجى إدخال الرمز التالي يدويًا',
      'vi': 'Nếu bạn không thể quét, vui lòng nhập thủ công mã sau',
    },
    'smq78s7m': {
      'en': 'Next',
      'ar': 'التالي',
      'vi': 'Kế tiếp',
    },
  },
  // profile_page_view
  {
    'eus8wc7h': {
      'en': 'Profile',
      'ar': 'حساب تعريفي',
      'vi': 'Hồ sơ',
    },
    'wl1ownor': {
      'en': 'Account Settings',
      'ar': 'إعدادت الحساب',
      'vi': 'Cài đặt tài khoản',
    },
    'afxtmzhw': {
      'en': 'Change Password',
      'ar': 'تغيير كلمة المرور',
      'vi': 'Đổi mật khẩu',
    },
    'wvo4yj9k': {
      'en': 'Change Language',
      'ar': 'تغيير اللغة',
      'vi': 'Thay đổi ngôn ngữ',
    },
    'znd2aszb': {
      'en': 'Switch to Dark Mode',
      'ar': 'التبديل إلى الوضع الداكن',
      'vi': 'Chuyển sang chế độ tối',
    },
    'qhhwomg1': {
      'en': 'Switch to Light Mode',
      'ar': 'التبديل إلى وضع الضوء',
      'vi': 'Chuyển sang chế độ sáng',
    },
    'c0xbwwci': {
      'en': 'Logout',
      'ar': 'تسجيل خروج',
      'vi': 'Đăng xuất',
    },
  },
  // select_security_bottom_sheet
  {
    'k3na7l6v': {
      'en': 'SELECT SECURITY',
      'ar': '',
      'vi': '',
    },
    'cuaed5jd': {
      'en': 'Type security name',
      'ar': '',
      'vi': '',
    },
    'ogcb9xww': {
      'en': 'Select',
      'ar': '',
      'vi': '',
    },
  },
  // Miscellaneous
  {
    '2vhx2uhq': {
      'en': 'Do you allow app to use your Camera to take a picture?',
      'ar': 'هل تسمح للتطبيق باستخدام الكاميرا لالتقاط صورة؟',
      'vi':
          'Bạn có cho phép ứng dụng sử dụng Máy ảnh của bạn để chụp ảnh không?',
    },
    '1y3zn4oo': {
      'en':
          'Do you allow app to access to your Photo Library to upload use images on this device?',
      'ar':
          'هل تسمح للتطبيق بالوصول إلى مكتبة الصور الخاصة بك لتحميل الصور المستخدمة على هذا الجهاز؟',
      'vi':
          'Bạn có cho phép ứng dụng truy cập vào Thư viện ảnh của mình để tải lên hình ảnh sử dụng trên thiết bị này không?',
    },
    '7o5te87o': {
      'en': 'Camera is required to take a picture from camera',
      'ar': 'الكاميرا مطلوبة لالتقاط صورة من الكاميرا',
      'vi': 'Cần có máy ảnh để chụp ảnh từ máy ảnh',
    },
    '4xjp6sq7': {
      'en': 'Gallery is required to upload image',
      'ar': 'المعرض مطلوب لتحميل الصورة',
      'vi': 'Cần có thư viện để tải hình ảnh lên',
    },
    'fphiwhqk': {
      'en':
          'Application need your permission to access to your device\'s photo library ',
      'ar': 'يحتاج التطبيق إلى إذنك للوصول إلى مكتبة الصور بجهازك',
      'vi':
          'Ứng dụng cần sự cho phép của bạn để truy cập vào thư viện ảnh trên thiết bị của bạn',
    },
    'cvtkn5qk': {
      'en': 'Do you allow app to use your Microphone to capture video?',
      'ar': 'هل تسمح للتطبيق باستخدام الميكروفون الخاص بك لالتقاط الفيديو؟',
      'vi':
          'Bạn có cho phép ứng dụng sử dụng Micrô của mình để quay video không?',
    },
    'oxsqo115': {
      'en': 'Camera permission is required to take a picture from camera',
      'ar': 'مطلوب إذن الكاميرا لالتقاط صورة من الكاميرا',
      'vi': 'Cần có sự cho phép của máy ảnh để chụp ảnh từ máy ảnh',
    },
    'b7x1hbqf': {
      'en':
          'Do you allow app to access to your storage to use images, audios and videos',
      'ar':
          'هل تسمح للتطبيق بالوصول إلى مساحة التخزين لديك لاستخدام الصور والتسجيلات الصوتية ومقاطع الفيديو؟',
      'vi':
          'Bạn có cho phép ứng dụng truy cập vào bộ nhớ của bạn để sử dụng hình ảnh, âm thanh và video không',
    },
    'deyb946x': {
      'en':
          'Do you allow app to access to your storage to use images, audios and videos',
      'ar':
          'هل تسمح للتطبيق بالوصول إلى مساحة التخزين لديك لاستخدام الصور والتسجيلات الصوتية ومقاطع الفيديو؟',
      'vi':
          'Bạn có cho phép ứng dụng truy cập vào bộ nhớ của bạn để sử dụng hình ảnh, âm thanh và video không',
    },
    '65tsf8oy': {
      'en':
          'Do you allow app to access to your storage to use images, audios and videos',
      'ar':
          'هل تسمح للتطبيق بالوصول إلى مساحة التخزين لديك لاستخدام الصور والتسجيلات الصوتية ومقاطع الفيديو؟',
      'vi':
          'Bạn có cho phép ứng dụng truy cập vào bộ nhớ của bạn để sử dụng hình ảnh, âm thanh và video không',
    },
    'nrqz9nrl': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'e14xsvhe': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'vf2dfq7m': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '09e9gya4': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'sk1q9yox': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '1wxgfplh': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'mwqajidv': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'vvq9imca': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '5wlnaolw': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'd1q1b1di': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '79dj9f3z': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '8z42u34u': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    '0jb7urrb': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'z910mtvf': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'ikyz4fez': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'wgdpd7nr': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'h31pa1aa': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'k7yat2ol': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'd8hjem1f': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'la1dpdex': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'csnijw5r': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'ucrf7q83': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'jjcimwpr': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'goezrdwj': {
      'en': '',
      'ar': '',
      'vi': '',
    },
    'pzglz578': {
      'en': '',
      'ar': '',
      'vi': '',
    },
  },
].reduce((a, b) => a..addAll(b));
