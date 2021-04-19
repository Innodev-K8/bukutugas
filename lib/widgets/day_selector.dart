import 'package:bukutugas/helpers/helpers.dart';
import 'package:bukutugas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DaySelectorFormField extends FormField<List<int>> {
  DaySelectorFormField({
    FormFieldSetter<List<int>>? onSaved,
    FormFieldValidator<List<int>>? validator,
    AutovalidateMode? autovalidateMode,
    bool readOnly = false,
    List<int>? initialSelectedDays,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialSelectedDays,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<List<int>> state) {
            return Column(
              children: [
                DaySelector(
                  onChange: (selectedDays) {
                    state.didChange(selectedDays);
                  },
                  initialSelectedDays: initialSelectedDays,
                  readOnly: readOnly,
                ),
                state.hasError
                    ? ErrorText(message: state.errorText)
                    : Container()
              ],
            );
          },
        );
}

class DaySelector extends HookWidget {
  final void Function(List<int> selectedDays) onChange;
  final bool readOnly;
  final List<int>? initialSelectedDays;

  DaySelector({
    required this.onChange,
    this.readOnly = false,
    this.initialSelectedDays,
  });

  final days = {
    1: 'S',
    2: 'S',
    3: 'R',
    4: 'K',
    5: 'J',
    6: 'S',
    7: 'M',
  };

  @override
  Widget build(BuildContext context) {
    final selectedDay = useState<List<int>>(initialSelectedDays ?? []);

    return Container(
      width: double.infinity,
      height: 28.0,
      child: Wrap(
        spacing: 6.0,
        children: days
            .map(
              (key, code) => MapEntry(
                key,
                DaySelectorItem(
                  text: code,
                  isSelected: selectedDay.value.contains(key),
                  onTap: () {
                    if (readOnly) return;

                    if (selectedDay.value.contains(key)) {
                      selectedDay.value = selectedDay.value
                          .where((element) => element != key)
                          .toList();
                    } else {
                      selectedDay.value = [key, ...selectedDay.value];
                    }

                    onChange(selectedDay.value..sort());
                  },
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}

class DaySelectorItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function()? onTap;

  const DaySelectorItem({
    Key? key,
    required this.text,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? darken(Theme.of(context).accentColor)
              : Theme.of(context).primaryColorLight,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w600,
                color: !isSelected
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).primaryColorLight,
              ),
        ),
      ),
    );
  }
}
