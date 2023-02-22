import 'dart:typed_data';

import 'package:anylearn/models/pocket_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../Theme/colors.dart';
import '../../controllers/auth_service.dart';
import '../../controllers/file_service.dart';
import '../../models/topic.dart';
import '../../models/user.dart';
import '../shared/profile-avatar.dart';

final userInfoProvider = StateProvider<User>((ref) => User());

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  Uint8List? _imageData;
  final _client = PocketClient.client;
  var _topicList = <Topic>[];
  var _topics = <String>[];

  Future<void> getUserInfo() async {
    ref.read(userInfoProvider.notifier).state = User.fromJson(
      PocketClient.model.data,
      PocketClient.model,
    );
    final userTopics = await PocketClient.getUserTopics(PocketClient.model.id);
    ref.read(userInfoProvider).topics = userTopics;
  }

  Future<void> updateProfile(User user) async {
    if (await AuthService.updateProfile(
      user.username,
      user.about,
      _imageData,
      _topics,
    )) {
      context.goNamed(
        'UserProfile',
        params: {
          'userId': PocketClient.model.id,
        },
      );
    }
  }

  Future<void> getTopics() async {
    final list = await PocketClient.getTopics();
    setState(() {
      _topicList = list;
    });
    final userTopics = await PocketClient.getUserTopics(PocketClient.model.id);
    final topicList = <String>[];
    for (var topic in userTopics) {
      topicList.add(topic.id);
    }
    setState(() {
      _topics = topicList;
    });
  }

  Future<void> setAvatar() async {
    final imageData = await FileService.getImage();
    if (imageData.isNotEmpty) {
      setState(() {
        _imageData = imageData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getTopics();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userInfoProvider);

    DecorationImage image = _imageData != null
        ? DecorationImage(
            image: MemoryImage(_imageData!),
            fit: BoxFit.cover,
          )
        : DecorationImage(
            image: NetworkImage(
              _client
                  .getFileUrl(
                      PocketClient.model, PocketClient.model.data['avatar'])
                  .toString(),
            ),
            fit: BoxFit.cover,
          );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: secondaryColor,
          ),
          onPressed: () {
            context.goNamed(
              'UserProfile',
              params: {
                'userId': PocketClient.model.id,
              },
            );
          },
        ),
        title: const Text(
          "Edit",
          style: TextStyle(color: secondaryColor),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: 200.0,
                child: Material(
                  type: MaterialType.circle,
                  color: primarySurface,
                  child: InkWell(
                    onTap: () {
                      setAvatar();
                    },
                    radius: 100.0,
                    child: CircleAvatar(
                      radius: 100.0,
                      child: Container(
                        decoration: BoxDecoration(
                          image: image,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: TextFormField(
                maxLength: 50,
                cursorColor: secondaryColor,
                initialValue: user.username,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: "username",
                  labelStyle: TextStyle(color: secondaryColor),
                  focusColor: secondaryColor,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.0,
                      color: secondaryColor,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    ref.read(userInfoProvider).username = value;
                  });
                },
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                maxLength: 80,
                cursorColor: secondaryColor,
                initialValue: user.about,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: "about",
                  labelStyle: TextStyle(color: secondaryColor),
                  focusColor: secondaryColor,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.0,
                      color: secondaryColor,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    ref.read(userInfoProvider).about = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1.0,
                mainAxisExtent: 200.0,
              ),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _topicList.length,
              itemBuilder: (context, index) => InputChip(
                selected: _topics.contains(_topicList[index].id),
                onPressed: (_topics.length < 3 ||
                        _topics.contains(_topicList[index].id))
                    ? () {
                        if (_topics.contains(_topicList[index].id)) {
                          setState(() {
                            _topics.remove(_topicList[index].id);
                          });
                        } else {
                          setState(() {
                            _topics.add(_topicList[index].id);
                          });
                        }
                      }
                    : null,
                label: Text(_topicList[index].name),
                backgroundColor: primarySurface,
                selectedColor: selectedColor,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: ElevatedButton(
                  onPressed: (_topics.isNotEmpty &&
                          _topics.length <= 3 &&
                          user.username.isNotEmpty)
                      ? () => updateProfile(user)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36.0,
                      vertical: 18.0,
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
