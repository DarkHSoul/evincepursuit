import 'package:hive/hive.dart';

part 'variables.g.dart';

@HiveType(typeId: 1)
class Woods extends HiveObject {
  @HiveField(0)
  late int woodcount = 0;
  @HiveField(1)
  late int woodCutters = 0;
  @HiveField(2)
  late int people = 0;
}

@HiveType(typeId: 2)
class Stone extends HiveObject {
  @HiveField(0)
  late int stonecount = 0;
}
