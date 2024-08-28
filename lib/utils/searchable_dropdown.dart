import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kleber_bank/utils/app_styles.dart';
import 'package:kleber_bank/utils/common_functions.dart';

import 'flutter_flow_theme.dart';

class SearchableDropdown extends StatefulWidget {
  final String searchHint;
  final String hint;
  final dynamic selectedValue;

  // final List<dynamic> list;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final bool isSearchable;
  final void Function(dynamic) onChanged;
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
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 2,
          ),
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<dynamic>(
            isExpanded: true,selectedItemBuilder: widget.selectedItemBuilder,
            hint: Text(
              widget.hint,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto',
                  letterSpacing: 0.0,
                ),
            items: widget.items,
            value: selectedValue,
            onChanged: (value) {
              widget.onChanged(value);
              setState(() {
                selectedValue = value;
              });
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              width: 200,
            ),
            dropdownStyleData: DropdownStyleData(maxHeight: 200, decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondaryBackground,borderRadius: BorderRadius.circular(10),border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2,
            ), // Set the dropdown corner radius here
            ),),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            dropdownSearchData: !widget.isSearchable
                ? null
                : DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                            focusColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
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
