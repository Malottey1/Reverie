import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  CustomDropdown({
    required this.hintText,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem;
  bool _isDropdownOpened = false;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Color(0xFFB0BEC5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF69734E)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    widget.hintText,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black54,
                    ),
                  ),
                  value: _selectedItem,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF69734E),
                  ),
                  items: widget.items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem = newValue;
                      _isDropdownOpened = false;
                    });
                    state.didChange(newValue);
                    if (widget.onChanged != null) {
                      widget.onChanged!(newValue);
                    }
                  },
                  onTap: () {
                    setState(() {
                      _isDropdownOpened = true;
                    });
                  },
                ),
              ),
            ),
            if (_isDropdownOpened && state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Color.fromARGB(255, 78, 118, 137),
                    fontSize: 12.0,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}