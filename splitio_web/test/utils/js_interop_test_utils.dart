import 'dart:js_interop';

@JS('Object.keys')
external JSArray<JSString> _objectKeys(JSObject obj);

@JS('Reflect.get')
external JSAny? _reflectGet(JSObject target, JSAny propertyKey);

List<dynamic> jsArrayToList(JSArray obj) {
  return obj.toDart.map(jsAnyToDart).toList();
}

Map<String, dynamic> jsObjectToMap(JSObject obj) {
  return {
    for (final jsKey in _objectKeys(obj).toDart)
      jsKey.toDart: jsAnyToDart(_reflectGet(obj, jsKey)),
  };
}

dynamic jsAnyToDart(JSAny? value) {
  if (value is JSArray) {
    return jsArrayToList(value);
  } else if (value is JSObject) {
    return jsObjectToMap(value);
  } else if (value is JSString) {
    return value.toDart;
  } else if (value is JSNumber) {
    return value.toDartDouble;
  } else if (value is JSBoolean) {
    return value.toDart;
  } else {
    return value; // JS null and undefined are null in Dart
  }
}
