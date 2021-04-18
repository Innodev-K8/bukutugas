import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DaySelector extends HookWidget {
  final void Function(List<int> selectedDays) onChange;

  DaySelector({required this.onChange});

  @override
  Widget build(BuildContext context) {
    final selectedDay = useState<List<int>>([]);

    useEffect(() {
      onChange(selectedDay.value..sort());
    }, [selectedDay.value]);

    return Container(
      width: double.infinity,
      height: 28.0,
      child: Wrap(
        spacing: 6.0,
        children: [
          DaySelectorItem(
            text: 'S',
            isSelected: selectedDay.value.contains(1),
            onTap: () {
              if (selectedDay.value.contains(1)) {
                selectedDay.value =
                    selectedDay.value.where((element) => element != 1).toList();
              } else {
                selectedDay.value = [1, ...selectedDay.value];
              }
            },
          ),
          DaySelectorItem(
            text: 'S',
            isSelected: selectedDay.value.contains(2),
            onTap: () {
              if (selectedDay.value.contains(2)) {
                selectedDay.value =
                    selectedDay.value.where((element) => element != 2).toList();
              } else {
                selectedDay.value = [2, ...selectedDay.value];
              }
            },
          ),
          DaySelectorItem(
            text: 'R',
            isSelected: selectedDay.value.contains(3),
            onTap: () {
              if (selectedDay.value.contains(3)) {
                selectedDay.value =
                    selectedDay.value.where((element) => element != 3).toList();
              } else {
                selectedDay.value = [3, ...selectedDay.value];
              }
            },
          ),
          DaySelectorItem(
            text: 'K',
            isSelected: selectedDay.value.contains(4),
            onTap: () {
              if (selectedDay.value.contains(4)) {
                selectedDay.value =
                    selectedDay.value.where((element) => element != 4).toList();
              } else {
                selectedDay.value = [4, ...selectedDay.value];
              }
            },
          ),
          DaySelectorItem(
            text: 'J',
            isSelected: selectedDay.value.contains(5),
            onTap: () {
              if (selectedDay.value.contains(5)) {
                selectedDay.value =
                    selectedDay.value.where((element) => element != 5).toList();
              } else {
                selectedDay.value = [5, ...selectedDay.value];
              }
            },
          ),
          DaySelectorItem(
            text: 'S',
            isSelected: selectedDay.value.contains(6),
            onTap: () {
              if (selectedDay.value.contains(6)) {
                selectedDay.value =
                    selectedDay.value.where((element) => element != 6).toList();
              } else {
                selectedDay.value = [6, ...selectedDay.value];
              }
            },
          ),
          DaySelectorItem(
            text: 'M',
            isSelected: selectedDay.value.contains(7),
            onTap: () {
              if (selectedDay.value.contains(7)) {
                selectedDay.value =
                    selectedDay.value.where((element) => element != 7).toList();
              } else {
                selectedDay.value = [7, ...selectedDay.value];
              }
            },
          ),
        ],
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
              ? Theme.of(context).accentColor
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
