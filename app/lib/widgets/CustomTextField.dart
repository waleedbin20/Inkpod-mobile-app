import 'package:app/config/WidgetSpace.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textController;
  final String inputHint;
  final bool isMultiline;
  final bool shoulObscureText;
  const CustomTextField(
      {Key? key,
      required this.textController,
      required this.inputHint,
      this.isMultiline = false,
      this.shoulObscureText = false})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode _focus = new FocusNode();
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() => setState(() => isActive = _focus.hasFocus);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.blueAccent, blurRadius: 5)]
              : null),
      child: TextField(
        keyboardType: widget.isMultiline ? TextInputType.multiline : null,
        maxLines: widget.isMultiline && !widget.shoulObscureText ? 10 : 1,
        controller: widget.textController,
        obscureText: !widget.isMultiline && widget.shoulObscureText,
        focusNode: _focus,
        autofocus: false,
        decoration: InputDecoration(
          hintText: widget.inputHint,
          fillColor: Colors.grey[100],
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
