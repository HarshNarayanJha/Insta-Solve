import 'package:flutter/material.dart';
import 'package:insta_solve/data/util_data.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.filterSubject,
    required this.filterClass,
    required this.onFilterSubject,
    required this.onFilterClass,
    required this.sortOldFirst,
    required this.onSortOldFirst,
  });

  final String filterSubject;
  final String filterClass;
  final bool sortOldFirst;
  final void Function(String) onFilterSubject;
  final void Function(String) onFilterClass;
  final void Function(bool) onSortOldFirst;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String filterSubject;
  late String filterClass;
  late bool sortOldFirst;

  bool filterApplied = false;

  @override
  void initState() {
    super.initState();
    filterSubject = widget.filterSubject;
    filterClass = widget.filterClass;
    sortOldFirst = widget.sortOldFirst;
  }

  @override
  Widget build(BuildContext context) {

    bool filterApplied = filterClass != 'all' || filterSubject != 'all' || sortOldFirst;

    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.filter_alt_rounded),
                const SizedBox(width: 10),
                Text(
                  "Filter Answers",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Text("Filter Subject"),
            leadingAndTrailingTextStyle:
                Theme.of(context).textTheme.bodyLarge,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  menuMaxHeight: 250,
                  alignment: Alignment.centerRight,
                  underline: const SizedBox(),
                  value: filterSubject,
                  icon: Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: const Icon(Icons.subject_rounded),
                  ),
                  onChanged: (String? value) {
                    widget.onFilterSubject(value!);
                    setState(() {
                      filterSubject = value;
                    });
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
              ],
            ),
          ),
          ListTile(
            leading: const Text("Filter Grade"),
            leadingAndTrailingTextStyle:
                Theme.of(context).textTheme.bodyLarge,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  menuMaxHeight: 250,
                  alignment: Alignment.centerRight,
                  underline: const SizedBox(),
                  value: filterClass,
                  icon: Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: const Icon(Icons.class_rounded),
                  ),
                  onChanged: (String? value) {
                    widget.onFilterClass(value!);
                    setState(() {
                      filterClass = value;
                    });
                  },
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('All')),
                    ...UtilData.grades
                        .map<DropdownMenuItem<String>>((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    })
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Text(
                "Sort ${sortOldFirst ? '(Oldest First)' : '(Newest First)'}"),
            leadingAndTrailingTextStyle:
                Theme.of(context).textTheme.bodyLarge,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(sortOldFirst ? Icons.arrow_downward_rounded: Icons.arrow_upward_rounded),
                IconButton(
                  onPressed: () {
                    widget.onSortOldFirst(!sortOldFirst);
                    setState(() {
                      sortOldFirst = !sortOldFirst;
                    });

                  },
                  icon: const Icon(Icons.swap_vert_rounded),
                ),
              ],
            ),
          ),
          ListTile(
            title: ElevatedButton.icon(
              onPressed: (filterApplied)
                  ? () {
                      widget.onFilterClass('all');
                      widget.onFilterSubject('all');
                      widget.onSortOldFirst(false);
                      Navigator.pop(context);
                    }
                  : null,
              label: const Text("Reset Filters"),
              icon: const Icon(Icons.filter_alt_off_rounded),
            ),
          )
        ],
      ),
    );
  }
}
