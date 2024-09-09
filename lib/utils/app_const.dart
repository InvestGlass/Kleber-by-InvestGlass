import 'package:kleber_bank/login/user_info_model.dart';
import 'package:intl/intl.dart';

class AppConst{
  static const connectionError='Connection error';
  static const connectionTimeOut='Connection Time Out';
  static const somethingWentWrong='Oops, Something went wrong, Please try again later';

  static UserInfotModel? userModel;

  static NumberFormat formatter = NumberFormat('#,##,###.##');

  static List<String> languageCodes=['en','ar','vi'];
}