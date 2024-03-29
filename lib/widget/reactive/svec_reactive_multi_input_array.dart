import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:svec/extension/list_extension.dart';
import 'package:svec/widget/reactive/svec_form_control.dart';
import 'package:svec/widget/reactive/svec_multi_input_array.dart';
import 'package:svec/widget/svec_multi_input.dart';

//ToDo: Replace 'Add'-button with 'ghostrows' - auto-create new row when typing in last one
class SvecReactiveMultiArray extends StatefulWidget {
  final String label;

  final FormGroup form;
  final String formControlName;

  const SvecReactiveMultiArray({super.key, required this.label, required this.form, required this.formControlName});

  @override
  State<SvecReactiveMultiArray> createState() => _SvecReactiveMultiArrayState();
}

class _SvecReactiveMultiArrayState extends State<SvecReactiveMultiArray> {
  late final SvecMultiInput _initialInput;

  @override
  void initState() {
    super.initState();

    SvecMultiInputArray array = widget.form.control(widget.formControlName) as SvecMultiInputArray;
    _initialInput = array.multiInputControls.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              children: _generateWidgetsForControlName(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _generateWidgetsForControlName() {
    List<Widget> widgets = [];
    AbstractControl control = widget.form.control(widget.formControlName);
    if (control is! SvecMultiInputArray) {
      throw ArgumentError('Passed control was not a SvecMultiArray.');
    }
    Type type = control.genericType;
    switch (type) {
      case const (String):
        widgets.add(
          ReactiveFormArray(
            formArrayName: widget.formControlName,
            builder: (context, formArray, child) {
              List<Widget> fields = [];
              for (SvecMultiInput multiInput in control.multiInputControls) {
                for (AbstractControl abstractControl in multiInput.controls) {
                  fields.add(
                    Expanded(
                      child: ReactiveTextField(
                        formControl: abstractControl as FormControl,
                      ),
                    ),
                  );
                }
              }
              int inputControlAmount = _initialInput.controls.length;
              return Column(
                children: [
                  for (var i = 0; i < fields.length; i += inputControlAmount)
                    Row(
                      children: [
                        ...fields.sublist(i, i + inputControlAmount < fields.length ? i + inputControlAmount : fields.length).separateList(const SizedBox(width: 7)),
                      ],
                    ),
                  Column(
                    children: [
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            control.multiInputControls.add(
                              SvecMultiInput<String>(
                                label: _initialInput.label,
                                outputMagicLetter: _initialInput.outputMagicLetter,
                                [for (AbstractControl _ in _initialInput.controls) SvecFormControl<String>(outputMagicLetter: _initialInput.outputMagicLetter)],
                              ),
                            );
                          });
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        );
      default:
        throw UnsupportedError('Failed to create a SvecReactiveMultiArray for type that is not String.');
    }
    return widgets;
  }
}
