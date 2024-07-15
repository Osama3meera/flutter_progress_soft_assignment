import 'package:flutter/material.dart';

class AgePickerDropdown extends StatefulWidget {
  final ValueChanged<int>? onChanged;

  const AgePickerDropdown({super.key, this.onChanged});

  @override
  _AgePickerDropdownState createState() => _AgePickerDropdownState();
}

class _AgePickerDropdownState extends State<AgePickerDropdown> {
  int selectedAge = 18;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedAge,
      onChanged: (int? newValue) {
        if (newValue != null) {
          setState(() {
            selectedAge = newValue;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(selectedAge);
          }
        }
      },
      items: List.generate(83, (index) => index + 18)
          .map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('$value years old'),
        );
      }).toList(),
    );
  }
}
