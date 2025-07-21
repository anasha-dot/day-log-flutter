enum EntryVisibility { public, private }

class DiaryEntry {
  final String id;
  final String text;
  final String tag;
  final EntryVisibility visibility;
  final String? mediaUrl;

  DiaryEntry({
    required this.id,
    required this.text,
    required this.tag,
    required this.visibility,
    this.mediaUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'tag': tag,
      'visibility': visibility.name,
      'mediaUrl': mediaUrl,
    };
  }

  factory DiaryEntry.fromMap(String id, Map<String, dynamic> map) {
    return DiaryEntry(
      id: id,
      text: map['text'] as String? ?? '',
      tag: map['tag'] as String? ?? '',
      visibility: EntryVisibility.values
          .firstWhere((v) => v.name == map['visibility'], orElse: () => EntryVisibility.private),
      mediaUrl: map['mediaUrl'] as String?,
    );
  }
}
