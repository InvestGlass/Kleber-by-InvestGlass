import 'package:kleber_bank/login/user_info_model.dart';
import 'package:intl/intl.dart';

class AppConst{
  static const connectionError='Connection error';
  static const connectionTimeOut='Connection Time Out';
  static const somethingWentWrong='Oops, Something went wrong, Please try again later';

  static UserInfotModel? userModel;

  static NumberFormat formatter = NumberFormat('#,##,###.##');

  static List<String> languageCodes=['en','ar','vi'];

  static const logo='assets/logo.png';
  static const brandLogo='assets/app_launcher_icon.png';
  // static const logo='assets/arab_bank_logo.png';
}