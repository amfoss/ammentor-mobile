import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ammentor/components/theme.dart';

class LinkText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;

  const LinkText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final regex = RegExp(r'(https?:\/\/[^\s]+|www\.[^\s]+)');
    final match = regex.firstMatch(text);

    if (match == null) {
      return Text(
        text,
        style: style ?? AppTextStyles.caption(context).copyWith(color: Colors.white),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    final before = text.substring(0, match.start);
    final url = match.group(0)!;
    final after = text.substring(match.end);

    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style ?? AppTextStyles.caption(context).copyWith(color: Colors.white),
        children: [
          TextSpan(text: before),
          TextSpan(
            text: url,
            style: AppTextStyles.caption(context).copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                String normalized = url;
                if (!normalized.startsWith('http')) {
                  normalized = 'https://$normalized';
                }
                final uri = Uri.parse(normalized);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
