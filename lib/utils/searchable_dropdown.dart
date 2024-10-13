import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import '../main.dart';
import 'flutter_flow_theme.dart';

class SearchableDropdown extends StatefulWidget {
  final String searchHint;
  final String hint;
  final dynamic selectedValue;

  // final List<dynamic> list;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final bool isSearchable;
  final void Function(dynamic) onChanged;
  final FocusNode? focusNode;
  final List<DropdownMenuItem<dynamic>>? items;
  final bool Function(DropdownMenuItem<dynamic>, String)? searchMatchFn;

  const SearchableDropdown(
      {required this.selectedValue,
      required this.searchHint /*,required this.list*/,
      required this.onChanged,
      required this.items,
      this.isSearchable = true,
      required this.searchMatchFn,
      this.hint = '',
      this.selectedItemBuilder,
      this.focusNode,
      super.key});

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  dynamic selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: rSize*0.056,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rSize*0.010),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 2,
          ),
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<dynamic>(
            isExpanded: true,
            selectedItemBuilder: widget.selectedItemBuilder,
            focusNode: widget.focusNode,
            hint: Text(
              widget.hint,
              style: TextStyle(
                fontSize: rSize*0.014,
                color: Theme.of(context).hintColor,
              ),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  letterSpacing: 0.0,
                ),
            items: widget.items,
            value: List<dynamic>.generate((widget.items??[]).length,(index) =>widget.items![index].value,).contains(selectedValue)?selectedValue:null,
            onChanged: (value) {
              widget.onChanged(value);
              setState(() {
                selectedValue = value;
              });
            },
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: rSize*0.016),
              height: rSize*0.040,
              width: rSize*0.200,decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(rSize*0.010),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2,
              ), // Set the dropdown corner radius here
            ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: rSize*0.200,scrollbarTheme: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.all(Colors.transparent), // Change the scrollbar color here
            ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(rSize*0.010),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 2,
                ), // Set the dropdown corner radius here
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: rSize*0.040,
            ),
            dropdownSearchData: !widget.isSearchable
                ? null
                : DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: rSize*0.050,
                    searchInnerWidget: Container(
                      decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: AppStyles.shadow(),
                          borderRadius: BorderRadius.circular(rSize * 0.01)),
                      margin: EdgeInsets.only(top: rSize*0.010, left: rSize*0.010, right: rSize*0.010),
                      child: TextFormField(
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Roboto',
                              letterSpacing: 0.0,
                            ),
                        controller: textEditingController,
                        // cursorColor: widget.searchCursorColor,
                        // style: widget.searchTextStyle,
                        decoration: AppStyles.inputDecoration(context,
                            hint: widget.searchHint,
                            fillColor: Colors.transparent,
                            borderWidth: 0.2,
                            focusColor: FlutterFlowTheme.of(context).customColor4,
                            contentPadding:EdgeInsets.symmetric(vertical: rSize*0.01, horizontal: rSize*0.01)),
                      ),
                    ),
                    searchMatchFn: widget.searchMatchFn,
                  ),
            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
