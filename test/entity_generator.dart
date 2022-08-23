import 'package:equatable/equatable.dart';
import 'feature_generator.dart';

class Property extends Equatable {
  final int id;
  final String type;
  final String name;
  final bool isList;
  final bool isEquatable;
  final bool isNullable;
  final bool isChangeable;
  final String? jsonName;

  const Property({
    required this.id,
    required this.type,
    required this.name,
    this.isList = false,
    this.isEquatable = false,
    this.isNullable = false,
    this.isChangeable = true,
    this.jsonName,
  });

  String get jsonFullName {
    return jsonName ?? name;
  }

  @override
  List<Object> get props => [id];
}

class Entity extends Equatable {
  final int id;
  final String name;
  final List<Property> properties;
  final bool isToJsonRequired;
  final bool isFromJsonRequired;
  final bool isCopyWithRequired;

  const Entity({
    required this.id,
    required this.name,
    required this.properties,
    required this.isToJsonRequired,
    required this.isCopyWithRequired,
    required this.isFromJsonRequired,
  });

  String get upperCamelCaseName {
    return convertCamelCaseToUpperCamelCase(name);
  }

  String get snakeCaseName {
    return convertCamelCaseToSnakeCase(name);
  }

  @override
  List<Object> get props => [id];
}

void main() {
  Entity entity = const Entity(
    id: 1,
    name: "guild",
    isFromJsonRequired: true,
    isToJsonRequired: true,
    isCopyWithRequired: true,
    properties: [
      Property(id: 1, type: "int", name: "id", isEquatable: true, isChangeable: false),
      Property(id: 2, type: "String", name: "nationalCode"),
      Property(id: 2, type: "String", name: "phoneNumber"),
      Property(id: 2, type: "String", name: "firstName"),
      Property(id: 2, type: "String", name: "lastName"),
      Property(id: 2, type: "String", name: "isicCoding"),
      Property(id: 2, type: "String", name: "organName"),
      Property(id: 2, type: "String", name: "isicName"),
      Property(id: 2, type: "String", name: "guildName"),
      Property(id: 2, type: "String", name: "province"),
      Property(id: 2, type: "String", name: "city"),
      Property(id: 2, type: "String", name: "homeTelephone"),
      Property(id: 2, type: "String", name: "address"),
      Property(id: 2, type: "String", name: "postalCode"),
    ],
  );

  createFile("lib/application/guild/domain/entities/${convertCamelCaseToSnakeCase(entity.name)}.dart", makeEntity(entity));
  createFile("lib/application/guild/data/models/${convertCamelCaseToSnakeCase(entity.name)}_model.dart", makeModel(entity));
}

String makeEntity(Entity entity) {
  String output = "import 'package:equatable/equatable.dart';\n";

  output += "\n\n class ${entity.upperCamelCaseName} extends Equatable {\n\n";
  for (var property in entity.properties) {
    output += property.isList
        ? "final List<${property.type}>${property.isNullable ? "?" : ""} ${property.name};\n"
        : "final ${property.type}${property.isNullable ? "?" : ""} ${property.name};\n";
  }
  output += "const ${entity.upperCamelCaseName}({\n";
  for (var property in entity.properties) {
    output += "required this.${property.name},\n";
  }
  output += " });\n";
  if (entity.isCopyWithRequired) {
    output += "${entity.upperCamelCaseName} copyWith({\n";
    for (var property in entity.properties.where((element) => element.isChangeable).toList()) {
      output += "${property.isList ? "List<${property.type}>" : property.type}? ${property.name},\n";
    }
    output += " }){\n";
    output += "return ${entity.upperCamelCaseName}(\n";
    for (var property in entity.properties) {
      if (property.isChangeable) {
        output += "${property.name}: ${property.name} ?? this.${property.name},\n";
      } else {
        output += "${property.name}: ${property.name},\n";
      }
    }
    output += ");\n";
    output += "}\n";
  }

  output += "\n\n";
  output += "@override\n";
  output +=
      "List<Object> get props => [${entity.properties.where((element) => element.isEquatable).toList().map((e) => e.name).toList().join(',')}];\n";
  output += "\n\n }";
  return output;
}

String makeModel(Entity entity) {
  String output = "import '../../../../common/utils.dart';\n";
  output += "import '../../domain/entities/${entity.snakeCaseName}.dart';\n";

  output += "\n\n class ${entity.upperCamelCaseName}Model extends ${entity.upperCamelCaseName} {\n\n";
  output += "const ${entity.upperCamelCaseName}Model({\n";
  for (var property in entity.properties) {
    output += "required ${property.isList ? "List<${property.type}>" : property.type} ${property.name},\n";
  }
  output += "}) : super(\n";
  for (var property in entity.properties) {
    output += "${property.name}:${property.name},\n";
  }
  output += ");\n";
  if (entity.isFromJsonRequired) {
    output += "factory ${entity.upperCamelCaseName}Model.fromJson(Map<String, dynamic> json) {\n";
    output += "return ${entity.upperCamelCaseName}Model(\n";
    for (var property in entity.properties) {
      output += "${property.name}:${getFromGsonFiled(property)},\n";
    }
    output += ");\n";
    output += "}\n";
  }
  if (entity.isToJsonRequired) {
    output += "Map<String, dynamic> toJson() {\n";
    output += "return {\n";
    for (var property in entity.properties) {
      output += "\"${property.name}\":${property.name},\n";
    }
    output += "};\n";
    output += "}\n";
  }
  output += "\n\n }";
  return output;
}

String getFromGsonFiled(Property property) {
  if (property.isList) {
    switch (property.type) {
      case "int":
        return "JsonParser.listParser(json, ['${property.jsonFullName}']) as List<int>";
      case "String":
        return "JsonParser.listParser(json, ['${property.jsonFullName}']) as List<String>";
      default:
        return "JsonParser.listParser(json, ['${property.jsonFullName}']).map((e) => ${property.type}Model.fromJson(e)).toList()";
    }
  } else {
    switch (property.type) {
      case "int":
        return "JsonParser.intParser(json, ['${property.jsonFullName}'])??0";
      case "String":
        return "JsonParser.stringParser(json, ['${property.jsonFullName}'])";
      default:
        return "JsonParser.parser(json, ['id'])";
    }
  }
}
