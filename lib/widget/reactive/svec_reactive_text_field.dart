import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SvecReactiveTextField extends StatelessWidget {
  final String label;
  final String controlName;

  const SvecReactiveTextField({super.key, required this.label, required this.controlName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ReactiveTextField(
        formControlName: controlName,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
