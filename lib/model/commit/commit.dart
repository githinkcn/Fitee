import 'package:fitee/model/commit/file_commit.dart';
import 'package:fitee/model/commit/stats.dart';
import 'package:fitee/model/user/user.dart';

import 'package:json_annotation/json_annotation.dart';

part 'commit.g.dart';

@JsonSerializable()
class Commit {
  String sha;
  String message;
  String url;
  User author;
  User committer;
  Commit commit;
  Stats stats;
  List<FileCommit> files;
  DateTime date;

  Commit({this.sha, this.author, this.message, this.url, this.files, this.date});

  factory Commit.fromJson(Map<String, dynamic> json) => _$CommitFromJson(json);

  Map<String, dynamic> toJson() => _$CommitToJson(this);
}