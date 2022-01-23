import 'package:flutter/material.dart';
import 'package:saise_de_temps/models/form_element_model.dart';

class TextFormWidget extends StatefulWidget {
  final FormElementModel question;
  final TextInputType textType;

  const TextFormWidget({
    Key? key,
    required this.question,
    this.textType = TextInputType.text,
  }) : super(key: key);

  @override
  _TextFormWidgetState createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.question.text!),
          TextFormField(
            keyboardType: widget.textType,
          ),
        ],
      ),
    );
  }
}
