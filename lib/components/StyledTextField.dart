import 'package:flutter/material.dart';
import 'package:get/get.dart';

const height = 70.0;
const outerPadding = EdgeInsets.fromLTRB(15, 15, 20, 10);
const innerPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 10);
const fontSize = 16.0;
const cursorHeight = 20.0;

class StyledTextField extends StatefulWidget {
  final Rx<String> enteredValue;

  const StyledTextField({Key? key, required this.enteredValue})
      : super(key: key);

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: outerPadding,
        child: TextField(
          onChanged: (value) {
            widget.enteredValue.value = value;
          },
          controller: myController,
          style: const TextStyle(fontSize: fontSize),
          cursorHeight: cursorHeight,
          decoration: InputDecoration(
            contentPadding: innerPadding,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                myController.clear();
                widget.enteredValue.value = "";
              },
            ),
          ),
        ),
      ),
    );
  }
}
