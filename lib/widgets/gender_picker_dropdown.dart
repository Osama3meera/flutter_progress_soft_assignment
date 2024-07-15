import 'package:flutter/material.dart';

class GenderPickerDropdown extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  GenderPickerDropdown({Key? key, this.onChanged}) : super(key: key);

  @override
  _GenderPickerDropdownState createState() => _GenderPickerDropdownState();
}

class _GenderPickerDropdownState extends State<GenderPickerDropdown> {
  String selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedGender,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedGender = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(selectedGender);
          }
        }
      },
      items: <String>['Male', 'Female'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
