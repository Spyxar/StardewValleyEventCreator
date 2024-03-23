import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:svec/checkbox.dart';
import 'package:svec/default_parsers.dart';
import 'package:svec/enum/gender.dart';
import 'package:svec/enum/pet.dart';
import 'package:svec/validator/double_limit_validator.dart';
import 'package:svec/enum/day.dart';
import 'package:svec/widget/svec_form_array.dart';
import 'package:svec/widget/reactive/svec_form_control.dart';
import 'package:svec/svec_form_card_widget.dart';
import 'package:svec/widget/svec_multi_input.dart';
import 'package:svec/widget/reactive/svec_reactive_text_field.dart';

import 'enum/season.dart';
import 'enum/weather.dart';

class SvecFormWidget extends StatefulWidget {
  static const requiredWidthForRow = 1400;

  const SvecFormWidget({super.key});

  @override
  State<SvecFormWidget> createState() => _SvecFormWidgetState();
}

class _SvecFormWidgetState extends State<SvecFormWidget> {
  late FormGroup triggersForm = FormGroup(
    {
      'id': SvecFormControl<int>(validators: [Validators.number, Validators.required], outputMagicLetter: '', parseValue: (value, magicLetter) => '$value'),
      'context': FormGroup(
        {
          'canBeFestivalDay': SvecFormControl<bool>.labeled(label: 'Festival Day', value: true, outputMagicLetter: 'F', parseValue: Parsers.invertedBooleanParser),
          'daysEventCanTrigger': SvecFormControl<List<CheckboxElement>>.labeled(
            label: 'Day',
            value: CheckboxElement.createListFromEnum(Day.values, true),
            outputMagicLetter: 'd',
            parseValue: (value, magicLetter) {
              value = value as List<CheckboxElement>;
              List<String> days = [];
              for (CheckboxElement checkbox in value) {
                if (!checkbox.isChecked) {
                  days.add(checkbox.parseName);
                }
              }
              if (days.isEmpty) {
                return '';
              }
              days.insert(0, magicLetter);
              return days.join(' ');
            },
          ),
          'probability': SvecFormControl<double>.labeled(label: 'Probability', outputMagicLetter: 'r', validators: [
            const DoubleLimitValidator(1, positiveOnly: true),
          ]),
          //ToDo: test this parseValue if it gives supposed output in-game
          //ToDo: show an error if both values are omitted, since event would never be able to trigger
          'weather': SvecFormControl<List<CheckboxElement>>.labeled(
            label: 'Weather',
            value: CheckboxElement.createListFromEnum(Weather.values, true),
            outputMagicLetter: 'w',
            parseValue: (value, magicLetter) {
              value = value as List<CheckboxElement>;
              List<String> weather = [];
              for (CheckboxElement checkbox in value) {
                if (checkbox.isChecked) {
                  weather.add(checkbox.parseName);
                }
              }
              if (weather.isEmpty || weather.length == 2) {
                return '';
              }
              return '$magicLetter ${weather.first}';
            },
          ),
          'year': SvecFormControl<int>.labeled(label: 'Year', outputMagicLetter: 'y'),
          'season': SvecFormControl<List<CheckboxElement>>.labeled(
            label: 'Season',
            value: CheckboxElement.createListFromEnum(Season.values, true),
            outputMagicLetter: 'z',
            parseValue: (value, magicLetter) {
              value = value as List<CheckboxElement>;
              List<String> seasons = [];
              for (CheckboxElement checkbox in value) {
                if (!checkbox.isChecked) {
                  seasons.add(checkbox.parseName);
                }
              }
              if (seasons.isEmpty) {
                return '';
              }
              seasons.insert(0, magicLetter);
              return seasons.join(' ');
            },
          ),
          'totalWalnutsFound': SvecFormControl<int>.labeled(label: 'Total walnuts found', outputMagicLetter: 'N'),
          'npcNotInvisible': SvecFormControl<String>.labeled(label: 'NPC not invisible', outputMagicLetter: 'v'),
          'noFestivalsFor': SvecFormControl<int>.labeled(label: 'No festivals in amount of days', outputMagicLetter: 'U'),
          'specialDialogueNotOngoing': SvecFormControl<String>.labeled(label: 'Special dialogue not in progress', outputMagicLetter: 'A'),
        },
      ),
      //ToDo:
      //  a <x> <y>
      //  f <name> <points>
      //  s <id> <number> (multiple)
      //  x <id> <null/true>
      'current': FormGroup(
        {
          'dating': SvecFormControl<String>.labeled(label: 'Dating', outputMagicLetter: 'D'),
          'marriedTo': SvecFormControl<String>.labeled(label: 'Married to', outputMagicLetter: 'O'),
          'notMarriedTo': SvecFormControl<String>.labeled(label: 'Not married to', outputMagicLetter: 'o'),
          'finishedJoja': SvecFormControl<bool>.labeled(label: 'Finished Joja', value: false, outputMagicLetter: 'J', parseValue: Parsers.booleanParser),
          'dayOfMonth': SvecFormControl<String>.labeled(
            label: 'Day of month',
            outputMagicLetter: 'u',
            parseValue: (value, magicLetter) {
              value = value as String;
              List<String> days = [];
              for (String day in value.split(' ')) {
                int? dayNumber = int.tryParse(day);
                if (dayNumber == null || dayNumber > 28) {
                  continue;
                }
                days.add(day);
              }
              if (days.isEmpty) {
                return '';
              }
              days.insert(0, magicLetter);
              return days.join(' ');
            },
          ),
          'time': SvecMultiInput<String>(
            label: 'Time',
            outputMagicLetter: 't',
            parseValue: (controls, magicLetter) {
              List<String> output = [magicLetter];

              int? minTime = int.tryParse(controls.first.value);
              int? maxTime = int.tryParse(controls.elementAt(1).value);

              if (minTime == null || maxTime == null) {
                return "";
              }

              if (minTime < 600) {
                minTime = 600;
              } else if (minTime > 2600) {
                minTime = 2600;
              }
              if (maxTime < 600) {
                maxTime = 600;
              } else if (maxTime > 2600) {
                maxTime = 2600;
              }

              //ToDo: Show error
              if (minTime > maxTime) {
                return "";
              } else if (maxTime < minTime) {
                return "";
              }

              output.add(minTime.toString());
              output.add(maxTime.toString());

              return output.join(" ");
            },
            [
              SvecFormControl<String>(outputMagicLetter: 't'),
              SvecFormControl<String>(outputMagicLetter: 't'),
            ],
          ),
          'npcInLocation': SvecFormControl<String>.labeled(label: 'NPC in location', outputMagicLetter: 'p'),
          //ToDo: small caveat:
          // 'Usage: /e <event ID> means has seen that event, then /e <event ID> <event ID> means has seen EITHER events, and /e <event ID>/e <event ID> means has seen BOTH events.'
          'eventsSeen': SvecFormArray<String>(label: 'Events seen', outputMagicLetter: 'e', [
            SvecFormControl<String>(outputMagicLetter: 'e'),
          ]),
          'eventsNotSeen': SvecFormArray<String>(label: 'Events not seen', outputMagicLetter: 'k', [
            SvecFormControl<String>(outputMagicLetter: 'k'),
          ]),
          'inFarmHouseAndUpgradedTwice':
              SvecFormControl<bool>.labeled(label: 'Inside twice upgraded farmhouse', outputMagicLetter: 'L', parseValue: Parsers.booleanParser),
          'hasMoney': SvecFormControl<int>.labeled(label: 'Minimum current amount of money', outputMagicLetter: 'M'),
          'moneyEarned': SvecFormControl<int>.labeled(label: 'Minimum amount of money earned', outputMagicLetter: 'm'),
          'seenSecretNote': SvecFormControl<int>.labeled(label: 'Seen secret note', outputMagicLetter: 'S'),
          'reachedMineBottomTimes': SvecFormControl<int>.labeled(label: 'Times bottom of mines reached', outputMagicLetter: 'b'),
          'emptyInventorySlots': SvecFormControl<int>.labeled(label: 'Minimum free inventory slots', outputMagicLetter: 'c'),
          'gender': SvecFormControl<List<CheckboxElement>>.labeled(
            label: 'Gender',
            value: CheckboxElement.createListFromEnum(Gender.values, true),
            outputMagicLetter: 'g',
            parseValue: (value, magicLetter) {
              value = value as List<CheckboxElement>;
              List<String> gender = [];
              for (CheckboxElement checkbox in value) {
                if (checkbox.isChecked) {
                  gender.add(checkbox.parseName);
                }
              }
              if (gender.isEmpty || gender.length == 2) {
                return '';
              }
              return '$magicLetter ${gender.first}';
            },
          ),
          //ToDo: show error when both are checked
          'noPetAndPreference': SvecFormControl<List<CheckboxElement>>.labeled(
            label: 'No pet and prefers',
            value: CheckboxElement.createListFromEnum(Pet.values, false),
            outputMagicLetter: 'h',
            parseValue: (value, magicLetter) {
              value = value as List<CheckboxElement>;
              List<String> pet = [];
              for (CheckboxElement checkbox in value) {
                if (checkbox.isChecked) {
                  pet.add(checkbox.parseName);
                }
              }
              if (pet.isEmpty || pet.length == 2) {
                return '';
              }
              return '$magicLetter ${pet.first}';
            },
          ),
          'hasItem': SvecFormControl<String>.labeled(label: 'Item in inventory', outputMagicLetter: 'i'),
          'playerMoreThan': SvecFormControl<int>.labeled(label: 'Played more days than', outputMagicLetter: 'j'),
          'receivedFlag': SvecFormControl<String>.labeled(label: 'Has received flag', outputMagicLetter: 'n'),
          'notReceivedFlag': SvecFormControl<String>.labeled(label: 'Has not received flag', outputMagicLetter: 'l'),
          'dialogueChosen': SvecFormControl<String>.labeled(
            label: 'Dialogue chosen',
            outputMagicLetter: 'q',
            parseValue: (value, magicLetter) {
              value = value as String;
              List<String> dialogues = [];
              for (String dialogue in value.split(' ')) {
                dialogues.add(dialogue);
              }
              if (dialogues.isEmpty) {
                return '';
              }
              dialogues.insert(0, magicLetter);
              return dialogues.join(' ');
            },
          ),
          'hasDoubleBedOrRoommateNotKrobus': SvecFormControl<bool>.labeled(label: 'Has double bed or roommate (not Krobus)', outputMagicLetter: 'B'),
        },
      ),
      'host': FormGroup(
        {
          'hostFinishedCommunityOrJoja':
              SvecFormControl<bool>.labeled(label: 'Host finished Community Center/Joja', outputMagicLetter: 'C', parseValue: Parsers.booleanParser),
          'hostNotFinishedCommunityOrJoja':
              SvecFormControl<bool>.labeled(label: "Host hasn't finished Community Center/Joja", outputMagicLetter: 'X', parseValue: Parsers.booleanParser),
          'currentPlayerIsHost': SvecFormControl<bool>.labeled(label: 'Player is host', outputMagicLetter: 'H', parseValue: Parsers.booleanParser),
          'hostHasReceivedFlag': SvecFormControl<String>.labeled(label: 'Host has received flag', outputMagicLetter: 'Hn'),
          'hostHasNotReceivedFlag': SvecFormControl<String>.labeled(label: 'Host has not received flag', outputMagicLetter: 'Hl'),
          'hostAndCurrentHaveReceivedFlag': SvecFormControl<String>.labeled(label: 'Host and current have received flag', outputMagicLetter: '*n'),
          'hostAndCurrentHaveNotReceivedFlag': SvecFormControl<String>.labeled(label: 'Host and current have not received flag', outputMagicLetter: '*l'),
        },
      ),
      'action': FormGroup(
        {},
      ),
    },
  );

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: triggersForm,
      child: Column(
        children: <Widget>[
          const SvecReactiveTextField(label: 'Id', controlName: 'id'),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth >= SvecFormWidget.requiredWidthForRow) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvecFormCardWidget(title: 'Context', form: triggersForm.control('context') as FormGroup),
                        const SizedBox(width: 10),
                        SvecFormCardWidget(title: 'Current Player', form: triggersForm.control('current') as FormGroup),
                        const SizedBox(width: 10),
                        SvecFormCardWidget(title: 'Host Player', form: triggersForm.control('host') as FormGroup),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        SvecFormCardWidget(title: 'Actions', form: triggersForm.control('action') as FormGroup),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    SvecFormCardWidget(title: 'Context', form: triggersForm.control('context') as FormGroup),
                    const SizedBox(height: 10),
                    SvecFormCardWidget(title: 'Current Player', form: triggersForm.control('current') as FormGroup),
                    const SizedBox(height: 10),
                    SvecFormCardWidget(title: 'Host Player', form: triggersForm.control('host') as FormGroup),
                    const SizedBox(height: 10),
                    SvecFormCardWidget(title: 'Actions', form: triggersForm.control('action') as FormGroup),
                  ],
                );
              }
            },
          ),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: form.valid ? _onPressed : null,
                  child: const Text('Submit'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onPressed() {
    List<String?> triggers = parseControls(triggersForm.controls).where((s) => s.isNotEmpty).toList();
    List<String?> actions = [];

    String output = '"${triggers.join('/')}": "${actions.join('/')}"';

    _showOutputDialog(output);
  }

  List<String> parseControls(Map<String, AbstractControl<Object?>> controls) {
    List<String> output = [];
    for (AbstractControl<Object?> control in controls.values) {
      if (control is FormGroup) {
        output.addAll(parseControls(control.controls));
      } else if (control is SvecFormArray) {
        List<String> arrayOutput = [];
        for (AbstractControl childControl in control.controls) {
          if (childControl.value == null) {
            continue;
          }
          arrayOutput.add(childControl.value.toString());
        }
        if (arrayOutput.isNotEmpty) {
          arrayOutput.insert(0, control.outputMagicLetter);
        }
        output.add(arrayOutput.join(' '));
      } else if (control is SvecFormControl) {
        if (control.value == null) {
          continue;
        }
        output.add(control.parseValue!(control.value, control.outputMagicLetter));
      } else if (control is SvecMultiInput) {
        output.add(control.parseValue!(control.controls, control.outputMagicLetter));
      }
    }
    return output;
  }

  Future<void> _showOutputDialog(String output) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Output'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(output),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: output));
                Navigator.of(context).pop();
              },
              child: const Text('Copy'),
            ),
          ],
        );
      },
    );
  }
}
