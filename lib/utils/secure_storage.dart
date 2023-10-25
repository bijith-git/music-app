import 'package:get_storage/get_storage.dart';

class SecureStorage {
  GetStorage box = GetStorage();
  initiateBox(String boxName) async {
    await GetStorage.init(boxName);
    box = GetStorage(boxName);
  }

  saveData({required String key, required String value}) {
    box.write(key, value);
  }

  removeData({required String key}) {
    box.remove(key);
  }

  T getData<T>({required String key}) {
    return box.read(key);
  }

  clearStorage() {
    box.erase();
  }
}
