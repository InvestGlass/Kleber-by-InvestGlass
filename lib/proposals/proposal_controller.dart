import 'package:flutter/material.dart';
import 'package:html/parser.dart'; // For parsing HTML
import 'package:html/dom.dart'; // For DOM manipulation
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/src/core/paging_controller.dart';
import 'package:kleber_bank/proposals/chat/chat_history_model.dart';
import 'package:kleber_bank/proposals/proposal_model.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import '../utils/api_calls.dart';
import '../utils/internationalization.dart';

class ProposalController extends ChangeNotifier {
  int selectedIndex = -1;

  int selectedSortIndex = 0;
  String? selectedProposalType, advisorName = '', proposalName = '';
  String direction = 'desc', column = 'created_at';
  List<String> sortList = ['Newest first', 'Oldest first', 'Name (A-Z)', 'Name (Z-A)'];
  int tempSelectedSortIndex=0;
  List<FilterModel> selectedFilterList = [];
  final PagingController<int, ProposalModel> pagingController = PagingController(firstPageKey: 1);

  selectTransactionIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
    } else {
      selectedIndex = -1;
    }
    notifyListeners();
  }

  void updateCheckBox(int index){
    pagingController.itemList![index].isChecked = !pagingController.itemList![index].isChecked;
    notifyListeners();
  }

  void updateState(
    String state,
    int? id,
    int index,
    BuildContext context,
      {Function? onUpdateStatus}) {

    CommonFunctions.showLoader(context);
    ApiCalls.updateProposalState(context,id!, state).then(
      (value) {
        CommonFunctions.dismissLoader(context);
        Navigator.pop(context);
        if (value != null) {
          if (onUpdateStatus!=null) {
            onUpdateStatus(value);
          }
          pagingController.itemList![index] = value;
          notifyListeners();
        }
      },
    );
  }

  List<String> typesList = [];

  void getProposalTypes(BuildContext context) {
    if (typesList.isEmpty) {
      ApiCalls.getProposalTypeList(context).then(
        (value) {
          typesList = value;
          typesList.insert(0,FFLocalizations.of(context).getText(
            'n93guv4x' /* All */,
          ));
          notifyListeners();
        },
      );
    }
  }

  /*----------------------------------------CHAT-----------------------------------------------------*/

   PagingController<int, ChatHistoryModel> chatHistoryPagingController = PagingController(firstPageKey: 1);
  TextEditingController msgController=TextEditingController();
  bool isAttachmentClicked=false,isAddClicked=false;

  List<Map<String, String>> filteredCountryNames=[];
  int selectedCountryIndex=0;

  List<Map<String, String>> countryNames = [
    {"name": "Afghanistan", "code": "af"},
    {"name": "Albania", "code": "al"},
    {"name": "Algeria", "code": "dz"},
    {"name": "Andorra", "code": "ad"},
    {"name": "Angola", "code": "ao"},
    {"name": "Antigua and Barbuda", "code": "ag"},
    {"name": "Argentina", "code": "ar"},
    {"name": "Armenia", "code": "am"},
    {"name": "Australia", "code": "au"},
    {"name": "Austria", "code": "at"},
    {"name": "Azerbaijan", "code": "az"},
    {"name": "Bahamas", "code": "bs"},
    {"name": "Bahrain", "code": "bh"},
    {"name": "Bangladesh", "code": "bd"},
    {"name": "Barbados", "code": "bb"},
    {"name": "Belarus", "code": "by"},
    {"name": "Belgium", "code": "be"},
    {"name": "Belize", "code": "bz"},
    {"name": "Benin", "code": "bj"},
    {"name": "Bhutan", "code": "bt"},
    {"name": "Bolivia", "code": "bo"},
    {"name": "Bosnia and Herzegovina", "code": "ba"},
    {"name": "Botswana", "code": "bw"},
    {"name": "Brazil", "code": "br"},
    {"name": "Brunei", "code": "bn"},
    {"name": "Bulgaria", "code": "bg"},
    {"name": "Burkina Faso", "code": "bf"},
    {"name": "Burundi", "code": "bi"},
    {"name": "Cabo Verde", "code": "cv"},
    {"name": "Cambodia", "code": "kh"},
    {"name": "Cameroon", "code": "cm"},
    {"name": "Canada", "code": "ca"},
    {"name": "Central African Republic", "code": "cf"},
    {"name": "Chad", "code": "td"},
    {"name": "Chile", "code": "cl"},
    {"name": "China", "code": "cn"},
    {"name": "Colombia", "code": "co"},
    {"name": "Comoros", "code": "km"},
    {"name": "Congo (Congo-Brazzaville)", "code": "cg"},
    {"name": "Costa Rica", "code": "cr"},
    {"name": "Croatia", "code": "hr"},
    {"name": "Cuba", "code": "cu"},
    {"name": "Cyprus", "code": "cy"},
    {"name": "Czechia (Czech Republic)", "code": "cz"},
    {"name": "Denmark", "code": "dk"},
    {"name": "Djibouti", "code": "dj"},
    {"name": "Dominica", "code": "dm"},
    {"name": "Dominican Republic", "code": "do"},
    {"name": "Ecuador", "code": "ec"},
    {"name": "Egypt", "code": "eg"},
    {"name": "El Salvador", "code": "sv"},
    {"name": "Equatorial Guinea", "code": "gq"},
    {"name": "Eritrea", "code": "er"},
    {"name": "Estonia", "code": "ee"},
    {"name": "Eswatini", "code": "sz"},
    {"name": "Ethiopia", "code": "et"},
    {"name": "Fiji", "code": "fj"},
    {"name": "Finland", "code": "fi"},
    {"name": "France", "code": "fr"},
    {"name": "Gabon", "code": "ga"},
    {"name": "Gambia", "code": "gm"},
    {"name": "Georgia", "code": "ge"},
    {"name": "Germany", "code": "de"},
    {"name": "Ghana", "code": "gh"},
    {"name": "Greece", "code": "gr"},
    {"name": "Grenada", "code": "gd"},
    {"name": "Guatemala", "code": "gt"},
    {"name": "Guinea", "code": "gn"},
    {"name": "Guinea-Bissau", "code": "gw"},
    {"name": "Guyana", "code": "gy"},
    {"name": "Haiti", "code": "ht"},
    {"name": "Honduras", "code": "hn"},
    {"name": "Hungary", "code": "hu"},
    {"name": "Iceland", "code": "is"},
    {"name": "India", "code": "in"},
    {"name": "Indonesia", "code": "id"},
    {"name": "Iran", "code": "ir"},
    {"name": "Iraq", "code": "iq"},
    {"name": "Ireland", "code": "ie"},
    {"name": "Israel", "code": "il"},
    {"name": "Italy", "code": "it"},
    {"name": "Jamaica", "code": "jm"},
    {"name": "Japan", "code": "jp"},
    {"name": "Jordan", "code": "jo"},
    {"name": "Kazakhstan", "code": "kz"},
    {"name": "Kenya", "code": "ke"},
    {"name": "Kiribati", "code": "ki"},
    {"name": "Korea (North)", "code": "kp"},
    {"name": "Korea (South)", "code": "kr"},
    {"name": "Kuwait", "code": "kw"},
    {"name": "Kyrgyzstan", "code": "kg"},
    {"name": "Laos", "code": "la"},
    {"name": "Latvia", "code": "lv"},
    {"name": "Lebanon", "code": "lb"},
    {"name": "Lesotho", "code": "ls"},
    {"name": "Liberia", "code": "lr"},
    {"name": "Libya", "code": "ly"},
    {"name": "Liechtenstein", "code": "li"},
    {"name": "Lithuania", "code": "lt"},
    {"name": "Luxembourg", "code": "lu"},
    {"name": "Madagascar", "code": "mg"},
    {"name": "Malawi", "code": "mw"},
    {"name": "Malaysia", "code": "my"},
    {"name": "Maldives", "code": "mv"},
    {"name": "Mali", "code": "ml"},
    {"name": "Malta", "code": "mt"},
    {"name": "Marshall Islands", "code": "mh"},
    {"name": "Mauritania", "code": "mr"},
    {"name": "Mauritius", "code": "mu"},
    {"name": "Mexico", "code": "mx"},
    {"name": "Micronesia", "code": "fm"},
    {"name": "Moldova", "code": "md"},
    {"name": "Monaco", "code": "mc"},
    {"name": "Mongolia", "code": "mn"},
    {"name": "Montenegro", "code": "me"},
    {"name": "Morocco", "code": "ma"},
    {"name": "Mozambique", "code": "mz"},
    {"name": "Myanmar (Burma)", "code": "mm"},
    {"name": "Namibia", "code": "na"},
    {"name": "Nauru", "code": "nr"},
    {"name": "Nepal", "code": "np"},
    {"name": "Netherlands", "code": "nl"},
    {"name": "New Zealand", "code": "nz"},
    {"name": "Nicaragua", "code": "ni"},
    {"name": "Niger", "code": "ne"},
    {"name": "Nigeria", "code": "ng"},
    {"name": "North Macedonia", "code": "mk"},
    {"name": "Norway", "code": "no"},
    {"name": "Oman", "code": "om"},
    {"name": "Pakistan", "code": "pk"},
    {"name": "Palau", "code": "pw"},
    {"name": "Palestine", "code": "ps"},
    {"name": "Panama", "code": "pa"},
    {"name": "Papua New Guinea", "code": "pg"},
    {"name": "Paraguay", "code": "py"},
    {"name": "Peru", "code": "pe"},
    {"name": "Philippines", "code": "ph"},
    {"name": "Poland", "code": "pl"},
    {"name": "Portugal", "code": "pt"},
    {"name": "Qatar", "code": "qa"},
    {"name": "Romania", "code": "ro"},
    {"name": "Russia", "code": "ru"},
    {"name": "Rwanda", "code": "rw"},
    {"name": "Saint Kitts and Nevis", "code": "kn"},
    {"name": "Saint Lucia", "code": "lc"},
    {"name": "Saint Vincent and the Grenadines", "code": "vc"},
    {"name": "Samoa", "code": "ws"},
    {"name": "San Marino", "code": "sm"},
    {"name": "Saudi Arabia", "code": "sa"},
    {"name": "Senegal", "code": "sn"},
    {"name": "Serbia", "code": "rs"},
    {"name": "Seychelles", "code": "sc"},
    {"name": "Sierra Leone", "code": "sl"},
    {"name": "Singapore", "code": "sg"},
    {"name": "Slovakia", "code": "sk"},
    {"name": "Slovenia", "code": "si"},
    {"name": "Somalia", "code": "so"},
    {"name": "South Africa", "code": "za"},
    {"name": "Spain", "code": "es"},
    {"name": "Sri Lanka", "code": "lk"},
    {"name": "Sudan", "code": "sd"},
    {"name": "Suriname", "code": "sr"},
    {"name": "Sweden", "code": "se"},
    {"name": "Switzerland", "code": "ch"},
    {"name": "Syria", "code": "sy"},
    {"name": "Tajikistan", "code": "tj"},
    {"name": "Tanzania", "code": "tz"},
    {"name": "Thailand", "code": "th"},
    {"name": "Timor-Leste", "code": "tl"},
    {"name": "Togo", "code": "tg"},
    {"name": "Tonga", "code": "to"},
    {"name": "Trinidad and Tobago", "code": "tt"},
    {"name": "Tunisia", "code": "tn"},
    {"name": "Turkey", "code": "tr"},
    {"name": "Turkmenistan", "code": "tm"},
    {"name": "Tuvalu", "code": "tv"},
    {"name": "Uganda", "code": "ug"},
    {"name": "Ukraine", "code": "ua"},
    {"name": "United Arab Emirates", "code": "ae"},
    {"name": "United Kingdom", "code": "gb"},
    {"name": "United States", "code": "us"},
    {"name": "Uruguay", "code": "uy"},
    {"name": "Uzbekistan", "code": "uz"},
    {"name": "Vanuatu", "code": "vu"},
    {"name": "Venezuela", "code": "ve"},
    {"name": "Vietnam", "code": "vn"},
    {"name": "Yemen", "code": "ye"},
    {"name": "Zambia", "code": "zm"},
    {"name": "Zimbabwe", "code": "zw"}
  ];

  void selectCountry(int i, BuildContext context){
    selectedCountryIndex=i;
    notifyListeners();
    Navigator.pop(context);
  }

  void search(String s) {
    filteredCountryNames=countryNames.where((element) => CommonFunctions.compare(s, element['name'].toString()),).toList();
    notifyListeners();
  }

  void openAttachmentOptions(){
    isAttachmentClicked=!isAttachmentClicked;
    isAddClicked=false;
    notifyListeners();
  }
  void openPlusOptions(){
    isAddClicked=!isAddClicked;
    isAttachmentClicked=false;
    notifyListeners();
  }

  Future<void> takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo =
    await picker.pickImage(source: ImageSource.camera);

  }
  Future<void> selectPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo =
    await picker.pickImage(source: ImageSource.gallery);

  }
  Future<void> selectFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo =
    await picker.pickMedia();

  }

  bool isDialogOpen()=>isAddClicked || isAttachmentClicked;

  String stripHtmlTags(String htmlString) {
    final Document document = parse(htmlString);

    // Remove unsafe elements like <script> and <style>
    document.querySelectorAll('script, style').forEach((element) => element.remove());

    return document.body?.innerHtml ?? '';
  }

  void sendMsg(BuildContext context,{String? msg}) {

    Map<String,dynamic> map={},map2={};
    map['comment']=msg??stripHtmlTags(msgController.text);
    map2['message']=map;
    CommonFunctions.showLoader(context);
    ApiCalls.sendMsg(context, map2).then((value) {
      CommonFunctions.dismissLoader(context);
      if (value!=null) {
        chatHistoryPagingController.itemList!.insert(0,value);
        msgController=TextEditingController(text: '');
        notifyListeners();
      }
    },);
  }

  void tempSelectSort(int value) {
    tempSelectedSortIndex=value;
    notifyListeners();
  }

}

class FilterModel {
  final String name, type;

  FilterModel(this.name, this.type);
}

enum FilterTypes{
SORT,
  ADVISOR,
  PROPOSAL_NAME,
  PROPOSAL_TYPE,
}


