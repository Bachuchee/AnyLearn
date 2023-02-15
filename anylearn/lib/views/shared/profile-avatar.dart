import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    Key? key,
    this.userImage,
    this.size = 40.0,
    this.onClick,
  }) : super(key: key);

  final ImageProvider? userImage;
  final double size;
  final void Function()? onClick;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(100.0),
        ),
      ),
      color: const Color(0x00000000),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100.0),
          ),
        ),
        onTap: widget.onClick,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: widget.size,
            width: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x00000000),
              image: widget.userImage != null
                  ? DecorationImage(image: widget.userImage!, fit: BoxFit.cover)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
