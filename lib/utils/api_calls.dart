import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kleber_bank/documents/accounts_model.dart';
import 'package:kleber_bank/login/user_info_model.dart';
import 'package:kleber_bank/main_controller.dart';
import 'package:kleber_bank/market/market_list_model.dart';
import 'package:kleber_bank/market/transaction_type_model.dart';
import 'package:kleber_bank/portfolio/portfolio_model.dart';
import 'package:kleber_bank/portfolio/position_model.dart';
import 'package:kleber_bank/portfolio/transaction_model.dart';
import 'package:kleber_bank/utils/shared_pref_utils.dart';
import 'package:provider/provider.dart';

import '../documents/document_model.dart';
import '../home/home_news_model.dart';
import '../login/on_boarding_page_widget.dart';
import '../proposals/chat/chat_history_model.dart';
import '../proposals/proposal_model.dart';
import 'app_const.dart';
import 'common_functions.dart';
import 'end_points.dart';
import 'internationalization.dart';

Future<dynamic> jsonResponse(BuildContext context, Uri uri, String method,
    {Object? body, bool isList = false, bool isJson = false}) async {
  MainController notifier = Provider.of<MainController>(context, listen: false);
  try {
    http.Response response;
    var header = {
      'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'
    };
    if (isJson) {
      header['Content-Type'] = 'application/json';
    }
    if (method == 'post') {
      response = await http.post(uri, body: body, headers: header);
    } else if (method == 'get') {
      response = await http.get(uri, headers: header);
    } else {
      response = await http.put(uri, headers: header);
    }
    print("url $uri");
    print("response ${response.body}");

    if (response.statusCode == 401) {
      CommonFunctions.dismissLoader(context);
      notifier.clearToken();
      CommonFunctions.navigate(context, const OnBoardingPageWidget());
      return jsonDecode(response.body);
    }

    if (response.statusCode != 200) {
      if (jsonDecode(response.body).containsKey('error')) {
        CommonFunctions.showToast(jsonDecode(response.body)['error']);
        return {};
      }
    }
    if (!isList) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body) as List;
    }
  } on SocketException catch (e) {
    CommonFunctions.showToast(AppConst.connectionError);
  } on TimeoutException catch (e) {
    CommonFunctions.showToast(AppConst.connectionTimeOut);
  } catch (e) {
    CommonFunctions.showToast(AppConst.somethingWentWrong);
    // print('add cust error ${e.toString()}::: ${e.stackTrace}');
  }
  return {};
}

class ApiCalls {
  static Future<bool> login(
      BuildContext context, String email, String pwd) async {
    try {
      var response = await http.post(Uri.parse(EndPoints.login),body: {"email": email, "password": pwd});
      var json=jsonDecode(response.body);
      if (json.containsKey("token")) {
        SharedPrefUtils.instance.putString(TOKEN, json['token']!);
        return true;
      } else {
        CommonFunctions.showToast(json['errors']!);
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<UserInfotModel?> getUserInfo(
    BuildContext context,
  ) async {
    try {
    var response = await http.get(Uri.parse(EndPoints.userInfo),headers : {
      'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'
    });
    var json=jsonDecode(response.body);
    UserInfotModel model = UserInfotModel.fromJson(json);
    AppConst.userModel = model;
      return model;
    }on Error catch (e) {
      print('${e.toString()}  ${e.stackTrace}');
    }
    return null;
  }

  static Future<ProposalModel?> updateProposalState(
      BuildContext context, int id, String state) async {
    try {
      Map<String, dynamic> json = await jsonResponse(
          context,
          Uri.parse('${EndPoints.proposals}/$id/update_state?state=$state'),
          'put');
      return ProposalModel.fromJson(json);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> transmit(
      BuildContext context, Map<String, dynamic> body) async {
    try {
      Map<String, dynamic> json = await jsonResponse(
          context, Uri.parse(EndPoints.transactions), 'post',
          body: jsonEncode(body), isJson: true);
      return json;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> sendOtp(
    BuildContext context,
  ) async {
    try {
      Map<String, dynamic> json = await jsonResponse(
        context,
        Uri.parse(EndPoints.sendOtp),
        'post',
      ); //no params
      return json;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> verifyOtp(
      BuildContext context, String code, String verificationCode) async {
    try {
      Map<String, dynamic> json = await jsonResponse(
          context,
          Uri.parse(
              '${EndPoints.verifyOtp}?code=$code&verification_code=$verificationCode'),
          'post'); //no params
      return json;
    } catch (e) {}
    return null;
  }

  static Future<Map<String, dynamic>?> getTermOfService(
    BuildContext context,
  ) async {
    try {
      Map<String, dynamic> json = await jsonResponse(
          context,
          Uri.parse(
            EndPoints.termOfService,
          ),
          'get');
      return json;
    } on SocketException catch (e) {
      CommonFunctions.showToast(AppConst.connectionError);
    } on TimeoutException catch (e) {
      CommonFunctions.showToast(AppConst.connectionTimeOut);
    } catch (e) {
      CommonFunctions.showToast(AppConst.somethingWentWrong);
      // print('user info API error ${e.toString()}::: ${e.stackTrace}');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> acceptanceTermsOfService(
    BuildContext context,
  ) async {
    try {
      Map<String, dynamic> json = await jsonResponse(context,
          Uri.parse(EndPoints.acceptanceTermsOfService), 'post'); //no params
      return json;
    } catch (e) {}
    return null;
  }

  static Future<List<MarketListModel>> getMarketList(
    BuildContext context,
    int pageKey,
    String searchedWord,
    String selectedClass,
    String selectedIndustry,
    String selectedCurrency,
  ) async {
    try {
      Map<String, dynamic> params = {
        'page': pageKey.toString(),
        'filter[currency_name]': selectedCurrency,
        'filter[name]': searchedWord,
        'filter[asset_class]': selectedClass,
        'filter[industry]': selectedIndustry,
      };
      params.removeWhere(
        (key, value) => value == null || value.toString().isEmpty,
      );
      List<dynamic> json = await jsonResponse(
          context,
          Uri.https(
              EndPoints.apiBaseUrl
                  .replaceAll('/client_portal_api/', '')
                  .replaceAll('https://', ''),
              '/client_portal_api/markets',
              params),
          'get',
          isList: true);

      return marketListModelFromJson(jsonEncode(json));
    } catch (e) {}
    return [];
  }

  static Future<List<PortfolioModel>> getPortfolioList(
      BuildContext context, int pageKey) async {
    String param = '';
    if (pageKey != 0) {
      param = '?page=$pageKey&limit=10$param';
    }
    try {
      List<dynamic> json = (await jsonResponse(
          context,
          Uri.parse(
            '${EndPoints.portfolios}$param',
          ),
          'get')) as List;

      return json.map((jsonItem) => PortfolioModel.fromJson(jsonItem)).toList();
    } on Error catch (e) {
      print('${e.toString()} ${e.stackTrace}');
    }
    return [];
  }

  static Future<PortfolioModel?> getPortfolioData(
      BuildContext context, int id) async {
    try {

      return PortfolioModel.fromJson(await jsonResponse(
          context,
          Uri.parse(
            '${EndPoints.portfolios}/$id',
          ),
          'get'));
    } on Error catch (e) {
      print('${e.toString()} ${e.stackTrace}');
    }
    return null;
  }

  static Future<List<TransactionTypeModel>> getTransactionTypeList(
    BuildContext context,
  ) async {
    try {
      List<dynamic> json = (await jsonResponse(
          context,
          Uri.parse(
            EndPoints.transactionTypes,
          ),
          'get')) as List;

      return json
          .map((jsonItem) => TransactionTypeModel.fromJson(jsonItem))
          .toList();
    } catch (e) {}
    return [];
  }

  static Future<List<PositionModel>> getPositionList(BuildContext context,
      int pageKey, int portfolioId, String column, String direction) async {
    try {
      Map<String, dynamic> params = {
        'page': pageKey.toString(),
        'order[column]': column,
        'order[direction]': direction,
        'limit': '10'
      };
      List<dynamic> json = (await jsonResponse(
          context,
          Uri.https(
              EndPoints.apiBaseUrl
                  .replaceAll('/client_portal_api/', '')
                  .replaceAll('https://', ''),
              '/client_portal_api/portfolios/$portfolioId/portfolio_securities',
              params),
          'get')) as List;

      return json.map((jsonItem) => PositionModel.fromJson(jsonItem)).toList();
    } on Error catch (e) {
      print('${e.toString()} ${e.stackTrace}');
    }
    return [];
  }

  static Future<List<TransactionModel>> getTransactionList(BuildContext context,
      int pageKey, String name, String column, String direction, String selectedDate) async {
    try {
      Map<String, dynamic> params = {
        'page': pageKey.toString(),
        'order[column]': column,
        'order[direction]': direction,
        'limit': '10',
        'filter[portfolio_name]': name,
        'filter[transaction_datetime]': selectedDate
      };
      List<dynamic> json = (await jsonResponse(
          context,
          Uri.https(
              EndPoints.apiBaseUrl
                  .replaceAll('/client_portal_api/', '')
                  .replaceAll('https://', ''),
              '/client_portal_api/transactions',
              params),
          'get')) as List;

      return json
          .map((jsonItem) => TransactionModel.fromJson(jsonItem))
          .toList();
    } on Error catch (e) {
      print('${e.toString()} ${e.stackTrace}');
    }
    return [];
  }

  static Future<List<ProposalModel>> getProposalList(
      int pageKey,
      String proposalName,
      String advisorName,
      String? selectedProposalType,
      String column,
      String direction,
      BuildContext context) async {
    try {
      Map<String, dynamic> params = {
        'order[column]': column,
        'order[direction]': direction,
        'filter[name]': proposalName,
        'filter[advisor]': advisorName,
        'filter[proposal_type]': selectedProposalType,
        'page': pageKey.toString(),
      };

      if (params['filter[proposal_type]'] ==
          FFLocalizations.of(context).getText(
            'n93guv4x' /* All */,
          )) {
        params.remove('filter[proposal_type]');
      }

      print('params $params');

      params.removeWhere(
        (key, value) => value == null || value.toString().isEmpty,
      );
      params.removeWhere(
        (key, value) => value == null || value.toString().isEmpty,
      );
      var url = Uri.https(
          EndPoints.apiBaseUrl
              .replaceAll('/client_portal_api/', '')
              .replaceAll('https://', ''),
          '/client_portal_api/proposals',
          params);

      List<dynamic> json = (await jsonResponse(context, url, 'get')) as List;

      return json.map((jsonItem) => ProposalModel.fromJson(jsonItem)).toList();
    } catch (e) {}
    return [];
  }

  static Future<List<String>> getProposalTypeList(
    BuildContext context,
  ) async {
    try {
      List<dynamic> json = (await jsonResponse(
          context,
          Uri.parse(
            EndPoints.proposalTypes,
          ),
          'get')) as List;

      return json.map((jsonItem) => jsonItem.toString()).toList();
    } catch (e) {}
    return [];
  }

  static Future<List<MarketListModel>> getMarketFilterDropDownData(
      BuildContext context, String endPoint) async {
    try {
      List<dynamic> json = (await jsonResponse(
          context,
          Uri.parse(
            endPoint,
          ),
          'get')) as List;

      return json
          .map((jsonItem) => MarketListModel.fromJson(jsonItem))
          .toList();
    } catch (e) {
      CommonFunctions.showToast(AppConst.somethingWentWrong);
      // print('user info API error ${e.toString()}::: ${e.stackTrace}');
    }
    return [];
  }

  static Future<List<AccountsModel>> getAccountsList(
    BuildContext context,
  ) async {
    try {
      List<dynamic> json = (await jsonResponse(
          context,
          Uri.parse(
            EndPoints.accounts,
          ),
          'get')) as List;

      return accountsModelFromJson(jsonEncode(json));
    } catch (e) {}
    return [];
  }

  static Future<DocumentModel?> getDocumentList(
    BuildContext context,
    int page,
    String? selectedAccount,
    String searchedFile,
    String? selectedType,
    String range,
    List<String> ancestryFolderList,
    List<String> folderPathList,
    String orderDirection,
    String orderColumn,
  ) async {
    try {
      String params = '';
      if ((selectedAccount ?? '').isNotEmpty &&
          selectedAccount !=
              FFLocalizations.of(context).getText(
                'n93guv4x' /* All */,
              )) {
        params += '&filter[account]=$selectedAccount';
      }
      if (range.isNotEmpty) {
        params +=
            '&filter[start_date]=${range.split(' ')[0]}&filter[end_date]=${range.split(' ')[2]}';
      }
      if ((selectedType ?? '').isNotEmpty &&
          selectedType !=
              FFLocalizations.of(context).getText(
                'n93guv4x' /* All */,
              )) {
        params += '&filter[document_type]=${selectedType!.toLowerCase()}';
      }
      if (searchedFile.isNotEmpty) {
        params += '&filter[title]=$searchedFile';
      }
      if (ancestryFolderList.isNotEmpty) {
        params += '&ancestry_folder=${ancestryFolderList.last}';
      }
      if (orderDirection.isNotEmpty) {
        params += '&order[direction]=$orderDirection';
      }
      if (orderColumn.isNotEmpty) {
        params += '&order[column]=$orderColumn';
      }
      for (var element in folderPathList) {
        if (!params.contains('&document[directory_path]=')) {
          params += '&document[directory_path]=$element';
        } else {
          params += element;
        }
      }
      return DocumentModel.fromJson(await jsonResponse(
          context,
          Uri.parse(
            '${EndPoints.documents}?page=$page$params',
          ),
          'get'));
    } catch (e) {}
    return null;
  }

  static Future<bool> changePassword(
      BuildContext context, String currentPwd, String newPwd) async {
    try {
      var url = Uri.parse(
        EndPoints.changePassword,
      );
      Map<String, dynamic> map = await jsonResponse(context, url, 'post',
          body: {"current_password": currentPwd, "new_password": newPwd});
      if (map.containsKey('errors')) {
        if (map['errors'] is List) {
          CommonFunctions.showToast(map['errors'][0]);
        } else {
          CommonFunctions.showToast(map['errors']);
        }

        return false;
      } else {
        return map['success'];
      }
    } catch (e) {}
    return false;
  }

  static Future<Map<String, dynamic>?> uploadDoc(
      XFile file, String desc) async {
    var url = Uri.parse(EndPoints.documents);
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer ${SharedPrefUtils.instance.getString(TOKEN)}'
    });
    var multipartFile = await http.MultipartFile(
        'document[file]', http.ByteStream(file.openRead()), await file.length(),
        filename: file.name);
    request.files.add(multipartFile);
    request.fields['document[description]'] = desc;

    try {
      var response = await request.send();

      String jsonData = await response.stream.transform(utf8.decoder).join();
      Map<String, dynamic> valueMap = json.decode(jsonData);
      print("valueMap ${valueMap.toString()}");
      return valueMap;
    } on SocketException catch (e) {
      CommonFunctions.showToast(AppConst.connectionError);
    } on TimeoutException catch (e) {
      CommonFunctions.showToast(AppConst.connectionTimeOut);
    } catch (e) {
      CommonFunctions.showToast(AppConst.somethingWentWrong);
      // print('user info API error ${e.toString()}::: ${e.stackTrace}');
    }
    return null;
  }

  static Future<Document?> updateDocumentStatus(
      BuildContext context, int id, String status) async {
    try {
      return Document.fromJson(await jsonResponse(
          context,
          Uri.parse(
            '${EndPoints.documents}/$id/update_status?status=$status',
          ),
          'put'));
    } catch (e) {}
    return null;
  }

  static Future<List<HomeNewsModel>> getHomeNews(
    BuildContext context,
  ) async {
    try {
      List<dynamic> map = await jsonResponse(
          context,
          Uri.parse(
            EndPoints.homeNews,
          ),
          'get',
          isList: true);
      return homeNewsModelFromJson(jsonEncode(map));
    } catch (e) {}
    return [];
  }

  static Future<List<ChatHistoryModel>> getChatHistory(
      BuildContext context, int page) async {
    try {
      List<dynamic> map = await jsonResponse(
          context,
          Uri.parse(
            '${EndPoints.chat}?page=$page&limit=10',
          ),
          'get',
          isList: true);
      return chatHistoryModelFromJson(jsonEncode(map));
    } catch (e) {}
    return [];
  }

  static Future<ChatHistoryModel?> sendMsg(
      BuildContext context, Map<String, dynamic> body) async {
    try {
      Map<String, dynamic> map = await jsonResponse(
          context,
          Uri.parse(
            EndPoints.chat,
          ),
          'post',
          body: jsonEncode(body),
          isJson: true);
      return ChatHistoryModel.fromJson(map);
    } catch (e) {
      print('chat error');
    }
    return null;
  }
}
