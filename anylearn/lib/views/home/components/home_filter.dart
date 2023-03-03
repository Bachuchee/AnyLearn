import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/topic.dart';

final filterProvider = StateProvider<Topic?>((ref) => null);

class HomeFilters extends ConsumerStatefulWidget with PreferredSizeWidget {
  const HomeFilters({super.key});

  @override
  get preferredSize {
    return const Size(double.infinity, 50.0);
  }

  @override
  ConsumerState<HomeFilters> createState() => _HomeFiltersState();
}

class _HomeFiltersState extends ConsumerState<HomeFilters> {
  final List<Topic> _topicList = [const Topic("For You", "", "")];

  @override
  void initState() {
    super.initState();
    PocketClient.getTopics().then(
      (value) => setState(
        () {
          _topicList.addAll(value);
        },
      ),
    );
  }

  void updateFilter(bool isSelected, Topic topic) {
    Topic? newTopic;
    if (isSelected) {
      newTopic = topic;
    }
    ref.read(filterProvider.notifier).state = newTopic;
  }

  @override
  Widget build(BuildContext context) {
    final curFilter = ref.watch(filterProvider);

    return Container(
      width: double.infinity,
      height: 50.0,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _topicList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: index != 0
              ? FilterChip(
                  label: Text(
                    _topicList[index].name,
                  ),
                  avatar: const Icon(
                    Icons.circle,
                    color: secondaryColor,
                  ),
                  onSelected: (isSelected) {
                    updateFilter(isSelected, _topicList[index]);
                  },
                  selected: curFilter != null &&
                      curFilter.name == _topicList[index].name,
                )
              : FilterChip(
                  label: Text(_topicList[index].name),
                  showCheckmark: false,
                  avatar: const Icon(
                    Icons.interests,
                    color: secondaryColor,
                  ),
                  onSelected: (isSelected) {
                    updateFilter(isSelected, _topicList[index]);
                  },
                  selected: curFilter != null &&
                      curFilter.name == _topicList[index].name,
                ),
        ),
      ),
    );
  }
}
