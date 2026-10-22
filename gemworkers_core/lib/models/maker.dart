/// A craftsperson credited on stones (public.makers): cutter, jeweller or
/// collector. Never a seller — buyers see makers, not sellers.
class Maker {
  final String? id;
  final String name;

  /// e.g. "Chanthaburi, Thailand"; '' if unknown.
  final String place;
  final String story;
  final String? photoUrl;

  const Maker({
    this.id,
    required this.name,
    this.place = '',
    this.story = '',
    this.photoUrl,
  });

  factory Maker.fromMap(Map<String, dynamic> map) {
    final photo = map['photo_url']?.toString();
    return Maker(
      id: map['id']?.toString(),
      name: map['name']?.toString() ?? '',
      place: map['place']?.toString() ?? '',
      story: map['story']?.toString() ?? '',
      photoUrl: (photo?.isNotEmpty ?? false) ? photo : null,
    );
  }

  /// Empty place / story are stored as NULL.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'place': place.isEmpty ? null : place,
      'story': story.isEmpty ? null : story,
      'photo_url': photoUrl,
    };
  }
}
