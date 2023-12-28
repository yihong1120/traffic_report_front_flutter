class SocialAccount {
  final String provider;
  final String uid;

  SocialAccount({required this.provider, required this.uid});

  factory SocialAccount.fromJson(Map<String, dynamic> json) {
    return SocialAccount(
      provider: json['provider'] as String,
      uid: json['uid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'uid': uid,
    };
  }
}