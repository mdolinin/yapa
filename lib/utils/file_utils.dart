import 'dart:io';

import 'package:path/path.dart' as path_helper;

class FileUtils {
  static Directory appDocDir;

  static String absolutePath(String pathRelativeToAppDir) {
    String appDocPath = appDocDir?.path ?? '';
    return path_helper.join(appDocPath, pathRelativeToAppDir);
  }
}
