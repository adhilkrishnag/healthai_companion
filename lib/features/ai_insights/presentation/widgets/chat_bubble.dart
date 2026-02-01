import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/ai_chat_provider.dart';

/// Chat message bubble widget
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLast;

  const ChatBubble({super.key, required this.message, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: isLast ? 8 : 0,
        left: isUser ? 48 : 0,
        right: isUser ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : theme.cardTheme.color,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MarkdownText(text: message.content, isUser: isUser),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.7)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.secondary,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Simple markdown text renderer
class _MarkdownText extends StatelessWidget {
  final String text;
  final bool isUser;

  const _MarkdownText({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isUser ? Colors.white : theme.colorScheme.onSurface,
    );

    // Simple markdown parsing for bold and lists
    final lines = text.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.startsWith('**') && line.endsWith('**')) {
        // Bold line
        widgets.add(
          Text(
            line.replaceAll('**', ''),
            style: baseStyle?.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      } else if (line.startsWith('- ') || line.startsWith('• ')) {
        // List item
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: baseStyle),
                Expanded(child: Text(line.substring(2), style: baseStyle)),
              ],
            ),
          ),
        );
      } else if (RegExp(r'^\d+\. ').hasMatch(line)) {
        // Numbered list
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(line, style: baseStyle),
          ),
        );
      } else {
        // Regular text with inline bold
        widgets.add(_buildInlineMarkdown(line, baseStyle));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildInlineMarkdown(String text, TextStyle? baseStyle) {
    final parts = <InlineSpan>[];
    final boldPattern = RegExp(r'\*\*(.*?)\*\*');
    int lastEnd = 0;

    for (final match in boldPattern.allMatches(text)) {
      if (match.start > lastEnd) {
        parts.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: baseStyle,
          ),
        );
      }
      parts.add(
        TextSpan(
          text: match.group(1),
          style: baseStyle?.copyWith(fontWeight: FontWeight.bold),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      parts.add(TextSpan(text: text.substring(lastEnd), style: baseStyle));
    }

    if (parts.isEmpty) {
      return Text(text, style: baseStyle);
    }

    return RichText(text: TextSpan(children: parts));
  }
}
