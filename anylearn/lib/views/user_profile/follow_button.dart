import 'package:anylearn/Theme/colors.dart';
import 'package:anylearn/models/pocket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FollowButton extends StatefulWidget {
  const FollowButton(this.follower, this.followee, {super.key});

  final String follower;
  final String followee;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    PocketClient.checkFollowing(
      widget.follower,
      widget.followee,
    ).then(
      (value) => _isFollowing = value,
    );
  }

  Future<void> follow() async {
    setState(() {
      _isLoading = true;
    });
    await PocketClient.follow(widget.follower, widget.followee);
    setState(() {
      _isFollowing = true;
      _isLoading = false;
    });
  }

  Future<void> unfollow() async {
    setState(() {
      _isLoading = true;
    });
    await PocketClient.unFollow(widget.follower, widget.followee);
    setState(() {
      _isFollowing = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : _isFollowing
              ? unfollow
              : follow,
      style: ElevatedButton.styleFrom(
          backgroundColor: _isFollowing ? Colors.grey : secondaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _isFollowing ? "following" : "Follow",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
