import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:insta_solve/data/util_data.dart';

class AnswerFilterWidget extends StatelessWidget {
  const AnswerFilterWidget({
    super.key,
    required this.filterSubject,
    required this.filterClass,
    required this.onFilterSubject,
    required this.onFilterClass,
  });

  final String filterSubject;
  final String filterClass;
  final void Function(String) onFilterSubject;
  final void Function(String) onFilterClass;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.outline, width: 0.2),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.filter_alt_rounded),
              const SizedBox(width: 5),
              Text(
                "Filter Answers",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(
                menuMaxHeight: 250,
                alignment: Alignment.centerRight,
                underline: const SizedBox(),
                value: filterSubject,
                icon: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: const Icon(FluentIcons.book_letter_24_filled),
                ),
                onChanged: (String? value) {
                  // log(value!);
                  onFilterSubject(value!);
                },
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All')),
                  ...UtilData.qtypes
                      .map<DropdownMenuItem<String>>((Prompt val) {
                    return DropdownMenuItem<String>(
                      value: val.name,
                      child: Text(val.name.toTitleCase()),
                    );
                  })
                ],
              ),
              DropdownButton<String>(
                menuMaxHeight: 250,
                value: filterClass,
                icon: const Icon(FluentIcons.video_person_star_24_filled),
                onChanged: (String? value) {
                  onFilterClass(value!);
                },
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All')),
                  ...UtilData.grades
                      .map<DropdownMenuItem<String>>((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val.toTitleCase()),
                    );
                  })
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
