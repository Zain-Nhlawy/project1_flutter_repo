import 'package:flutter/material.dart';

class QaCard extends StatefulWidget {
  final String userName;
  final String question;
  final List<String> replies;

  const QaCard({
    super.key,
    required this.userName,
    required this.question,
    required this.replies,
  });

  @override
  State<QaCard> createState() => _QaCardState();
}

class _QaCardState extends State<QaCard>
    with TickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Text(
              widget.question,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              borderRadius:
                  BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: Theme.of(context)
                          .primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _expanded
                          ? "Hide Replies"
                          : "${widget.replies.length} Replies",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        color: Theme.of(context)
                            .primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AnimatedSize(
              duration: const Duration(
                milliseconds: 250,
              ),
              curve: Curves.easeInOut,
              child: !_expanded
                  ? const SizedBox.shrink()
                  : Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Column(
                        children: widget.replies
                            .map(
                              (reply) => Container(
                                width:
                                    double.infinity,
                                margin:
                                    const EdgeInsets
                                        .only(
                                  bottom: 8,
                                ),
                                padding:
                                    const EdgeInsets
                                        .all(12),
                                decoration:
                                    BoxDecoration(
                                  color: Colors
                                      .grey.shade100,
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const Icon(
                                      Icons.reply,
                                      size: 18,
                                      color:
                                          Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        reply,
                                        style:
                                            const TextStyle(
                                          height:
                                              1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}