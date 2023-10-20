import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool required;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.required,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      validator: (val) => required && val!.isEmpty ? 'Field is required' : null,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500])),
    );
  }
}

class MyPasswordTextField extends StatefulWidget {
  final controller;
  final String hintText;

  const MyPasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<MyPasswordTextField> createState() => _MyPasswordTextFieldState();
}

class _MyPasswordTextFieldState extends State<MyPasswordTextField> {
  bool _passwordVisible = false;
  Icon _buttonIcon = Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black),
      validator: (val) => val!.isEmpty ? 'Field is required' : null,
      controller: widget.controller,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: _buttonIcon,
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
                if (_passwordVisible == false) {
                  _buttonIcon = Icon(Icons.visibility_off);
                } else {
                  _buttonIcon = Icon(Icons.visibility);
                }
              });
            },
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500])),
    );
  }
}
