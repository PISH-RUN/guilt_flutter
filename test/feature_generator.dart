import 'dart:io';

import 'package:equatable/equatable.dart';

import 'entity_generator.dart';

void main() async {
  Feature feature = const Feature(
    id: 1,
    name: "profile",
    taskList: [
      Task(
        id: 1,
        cubitName: "getUser",
        methodName: "getUserInfo",
        method: Method.get,
        source: Source.restful,
        facadeFunctionOutput: "UserInfo",
        facadeFunctionParams: [Param(id: 1, type: "UserInfo", name: "user")],
        cubitEntityForSuccess: Param(id: 1, type: "UserInfo", name: "user"),
        offlineMethod: OfflineMethod.justOnline,
      ),
      Task(
        id: 2,
        cubitName: "updateUser",
        methodName: "updateUserInfo",
        method: Method.post,
        source: Source.restful,
        facadeFunctionOutput: "Commentate",
        facadeFunctionParams: [Param(id: 1, type: "UserInfo", name: "user")],
        cubitEntityForSuccess: Param(id: 1, type: "UserInfo", name: "user"),
        offlineMethod: OfflineMethod.justOnline,
      ),
    ],
    entityList: [
      Entity(
        id: 1,
        name: "UserInfo",
        isFromJsonRequired: true,
        isToJsonRequired: true,
        isCopyWithRequired: true,
        properties: [
          Property(id: 1, type: "int", name: "id", isEquatable: true),
          Property(id: 2, type: "String", name: "firstName"),
          Property(id: 3, type: "String", name: "lastName"),
          Property(id: 4, type: "String", name: "phoneNumber"),
          Property(id: 5, type: "String", name: "nationalCode"),
        ],
      ),
    ],
  );

  generateFeature(feature);
}

enum Method { get, getList, getListPaginate, post, delete, put }

enum Source { restful, firebase, hive, remoteConfig, logic, util }

enum OfflineMethod { justOnline, offlineAndOnline, offlineOrOnline }

class Param extends Equatable {
  final int id;
  final String name;
  final String type;

  const Param({
    required this.id,
    required this.type,
    required this.name,
  });

  @override
  List<Object> get props => [id];
}

class Task extends Equatable {
  final int id;
  final String cubitName;
  final String methodName;
  final Method method;
  final Source source;
  final String facadeFunctionOutput;
  final List<Param> facadeFunctionParams;
  final Param cubitEntityForSuccess;
  final OfflineMethod offlineMethod;

  const Task({
    required this.id,
    required this.cubitName,
    required this.methodName,
    required this.method,
    required this.source,
    required this.facadeFunctionOutput,
    required this.facadeFunctionParams,
    required this.cubitEntityForSuccess,
    required this.offlineMethod,
  });

  bool get isGets {
    return method == Method.get || method == Method.getListPaginate || method == Method.getList;
  }

  bool get isGetList {
    return method == Method.getListPaginate || method == Method.getList;
  }

  String get upperCamelCaseName {
    return convertCamelCaseToUpperCamelCase(cubitName);
  }

  String get snakeCaseName {
    return convertCamelCaseToSnakeCase(cubitName);
  }

  @override
  List<Object> get props => [id];
}

class Feature extends Equatable {
  final int id;
  final String name;
  final List<Task> taskList;
  final List<Entity> entityList;

  const Feature({
    required this.id,
    required this.name,
    required this.taskList,
    required this.entityList,
  });

  String get upperCamelCaseName {
    return convertCamelCaseToUpperCamelCase(name);
  }

  String get lowerCamelCaseName {
    return convertCamelCaseToLowerCamelCase(name);
  }

  String get snakeCaseName {
    return convertCamelCaseToSnakeCase(name);
  }

  @override
  List<Object> get props => [id];
}

void createFile(String path, String content) async {
  File file = File(path);
  final isExist = await file.exists();
  if (!isExist) {
    file.createSync(recursive: true);
    file.writeAsString(content);
  }
}

void generateFeature(Feature feature) {
  String featurePath = "lib/features/${feature.lowerCamelCaseName}";
  createFile("$featurePath/${feature.snakeCaseName}_injection_container.dart", parseGetItImplementation(feature));
  createFile("$featurePath/domain/repositories/${feature.snakeCaseName}_repository.dart", parseRepositoryInterfaceFile(feature));
  createFile("$featurePath/data/repositories/${feature.snakeCaseName}_repository_impl.dart", parseRepositoryImplFile(feature));
  createFile("$featurePath/domain/use_cases/${feature.snakeCaseName}_main.dart", parseFacadeFile(feature));
  for (var entity in feature.entityList) {
    createFile("$featurePath/domain/entities/${convertCamelCaseToSnakeCase(entity.name)}.dart", makeEntity(entity));
    createFile("$featurePath/data/models/${convertCamelCaseToSnakeCase(entity.name)}_model.dart", makeModel(entity));
  }

  for (var task in feature.taskList) {
    if (task.isGets) {
      createFile("$featurePath/presentation/manager/${convertCamelCaseToSnakeCase(task.cubitName)}_cubit.dart", parseCubitGetFile(feature, task));
    } else {
      createFile("$featurePath/presentation/manager/${convertCamelCaseToSnakeCase(task.cubitName)}_cubit.dart", parseCubitSetFile(feature, task));
    }
    if (task.isGetList) {
      createFile("$featurePath/presentation/widgets/${convertCamelCaseToSnakeCase(task.cubitName)}_widget.dart", parseWidgetGetListFile(task));
    } else if (!task.isGets) {
      createFile("$featurePath/presentation/widgets/${convertCamelCaseToSnakeCase(task.cubitName)}_widget.dart", parseWidgetSetListFile(task));
    }
    createFile("$featurePath/presentation/manager/${convertCamelCaseToSnakeCase(task.cubitName)}_state.dart", parseStateFile(task));
  }
}

String parseGetItImplementation(Feature feature) {
  String output = "import 'package:get_it/get_it.dart';\n";
  output += "import 'package:flutter/cupertino.dart';\n";
  output += "import 'package:flutter_bloc/flutter_bloc.dart';\n";
  output += "import 'domain/repositories/${feature.snakeCaseName}_repository.dart';\n";
  output += "import 'domain/use_cases/${feature.snakeCaseName}_main.dart';\n";
  output += "import 'data/repositories/${feature.snakeCaseName}_repository_impl.dart';\n";
  for (var task in feature.taskList) {
    output += "import 'presentation/manager/${task.snakeCaseName}_cubit.dart';\n";
  }

  output += "\n\nfinal sl = GetIt.instance;\n";
  output += "Future<void> init() async {\n";
  output += "\n// Cubit\n";
  for (var task in feature.taskList) {
    output += "sl.registerFactory(() => ${task.upperCamelCaseName}Cubit(main: sl()));\n";
  }
  output += "\n// Use cases\n";
  output += " sl.registerLazySingleton(() => ${feature.upperCamelCaseName}Main(sl()));\n";

  output += "\n// Repository\n";
  output +=
      "sl.registerLazySingleton<${feature.upperCamelCaseName}Repository>(() => ${feature.upperCamelCaseName}RepositoryImpl(remoteDataSource: sl(),localStorageDataSource: sl()));\n";

  output += "}\n";
  for (var task in feature.taskList) {
    output += "Widget get${task.upperCamelCaseName}Cubit(BuildContext context, Widget child) {\n";
    output += "return BlocProvider<${task.upperCamelCaseName}Cubit>(\n";
    output += "create: (context) => sl<${task.upperCamelCaseName}Cubit>(),\n";
    output += "child: child,\n";
    output += ");\n";
    output += "}\n";
  }
  return output;
}

String parseRepositoryImplFunction(Task task) {
  String firstElement = "";
  if (task.method == Method.get || task.method == Method.getList || task.method == Method.getListPaginate) {
    String multiThread = "Future";
    if (task.offlineMethod == OfflineMethod.offlineAndOnline) multiThread = "Stream";
    firstElement = "$multiThread<Either<Failure,${task.facadeFunctionOutput}>>";
  } else {
    firstElement = "Future<RequestResult>";
  }
  String output = "@override\n";
  output +=
      "$firstElement ${task.methodName}(${task.facadeFunctionParams.map((e) => "${e.type} ${e.name}").toList().join(',')}${task.method == Method.getListPaginate ? "${task.facadeFunctionParams.isNotEmpty ? "," : ""}{required int page}" : ""}){";
  output +=
      "final output= remoteDataSource.${task.isGets ? "getFromServer" : "${task.method.name}ToServer"}<${task.isGets ? task.facadeFunctionOutput : "bool"}>(\n";
  output += "url: '\${BASE_URL_API}users/me',\n";
  output += "params: {},\n";
  if (task.isGetList) {
    output +=
        "mapSuccess: (Map<String, dynamic> json) => JsonParser.listParser(json, ['data']).map((element) => ${task.facadeFunctionOutput.replaceAll("List<", "").replaceAll(">", "")}Model.fromJson(element)).toList(),\n";
  } else if (task.isGets) {
    output +=
        "mapSuccess: (Map<String, dynamic> json) => ${task.facadeFunctionOutput.replaceAll("List<", "").replaceAll(">", "")}Model.fromJson(JsonParser.parser(json, ['data'])),\n";
  } else {
    output += "mapSuccess: (Map<String, dynamic> json) => true,\n";
  }
  output += ");\n";
  if (task.isGets) {
    output += "return output;\n";
  } else {
    output += "return RequestResult.fromEither(output);\n";
  }
  output += "}\n";
  return output;
}

String parseRepositoryInterfaceFunction(Task task) {
  String firstElement = "";
  if (task.method == Method.get || task.method == Method.getList || task.method == Method.getListPaginate) {
    String multiThread = "Future";
    if (task.offlineMethod == OfflineMethod.offlineAndOnline) multiThread = "Stream";
    firstElement = "$multiThread<Either<Failure,${task.facadeFunctionOutput}>>";
  } else {
    firstElement = "Future<RequestResult>";
  }
  return "$firstElement ${task.methodName}(${task.facadeFunctionParams.map((e) => "${e.type} ${e.name}").toList().join(',')}${task.method == Method.getListPaginate ? "${task.facadeFunctionParams.isNotEmpty ? "," : ""}{required int page}" : ""});";
}

String parseRepositoryInterfaceFile(Feature feature) {
  String output = "import 'package:dartz/dartz.dart';\n";
  output += "import '../../../../common/failures.dart';\n";
  output += "import '../../../../common/request_result.dart';\n\n";

  output += "\n\n abstract class  ${feature.upperCamelCaseName}Repository{\n\n";
  for (var e in feature.taskList) {
    output += "${parseRepositoryInterfaceFunction(e)}\n\n";
  }
  output += "\n\n }";
  return output;
}

String parseRepositoryImplFile(Feature feature) {
  String output = "import 'package:dartz/dartz.dart';\n";
  output += "import '../../../../common/data/data_source/local_storage_data_source.dart';\n";
  output += "import '../../../../common/data/data_source/remote_data_source.dart';\n";
  output += "import '../../../../common/failures.dart';\n";
  output += "import '../../../../application/constants.dart';\n";
  output += "import '../../domain/repositories/${feature.snakeCaseName}_repository.dart';\n";
  output += "import '../../../../common/request_result.dart';\n\n";
  output += "import '../../../../common/utils.dart';\n\n";
  output += "import '../../../../common/request_result.dart';\n\n";

  output += "\n\n class ${feature.upperCamelCaseName}RepositoryImpl implements ${feature.upperCamelCaseName}Repository {\n\n";
  output += "final RemoteDataSource remoteDataSource;\n";
  output += "final LocalStorageDataSource localStorageDataSource;\n\n";
  output += "${feature.upperCamelCaseName}RepositoryImpl({\n\n";
  output += "required this.remoteDataSource,\n";
  output += "required this.localStorageDataSource,\n";
  output += "});\n\n";
  for (var e in feature.taskList) {
    output += "${parseRepositoryImplFunction(e)}\n\n";
  }
  output += "\n\n }";
  return output;
}

String parseFacadeFile(Feature feature) {
  String output = "import 'package:dartz/dartz.dart';\n";
  output += "import '../../../../common/failures.dart';\n";
  output += "import '../../../../common/request_result.dart';\n";
  output += "import '../repositories/${feature.snakeCaseName}_repository.dart';\n\n";
  output += "\n\nclass ${feature.upperCamelCaseName}Main{\n\n";
  output += "final ${feature.upperCamelCaseName}Repository repository;\n\n";
  output += "${feature.upperCamelCaseName}Main(this.repository);\n\n";

  for (var e in feature.taskList) {
    output += "${parseFacadeFunction(e)}\n\n";
  }
  output += "\n\n }";
  return output;
}

String parseFacadeFunction(Task task) {
  String firstElement = "";
  if (task.method == Method.get || task.method == Method.getList || task.method == Method.getListPaginate) {
    String multiThread = "Future";
    if (task.offlineMethod == OfflineMethod.offlineAndOnline) multiThread = "Stream";
    firstElement = "$multiThread<Either<Failure,${task.facadeFunctionOutput}>>";
  } else {
    firstElement = "Future<RequestResult>";
  }

  String output =
      "$firstElement ${task.methodName}(${task.facadeFunctionParams.map((e) => "${e.type} ${e.name}").toList().join(',')}${task.method == Method.getListPaginate ? "${task.facadeFunctionParams.isNotEmpty ? "," : ""}{int page=1}" : ""}) {";
  output +=
      "\n return repository.${task.methodName}(${task.facadeFunctionParams.map((e) => e.name).toList().join(',')}${task.method == Method.getListPaginate ? "${task.facadeFunctionParams.isNotEmpty ? "," : ""}page:page" : ""});";
  output += "\n}";
  return output;
}

String parseCubitGetFile(Feature feature, Task task) {
  String output = "import 'package:flutter_bloc/flutter_bloc.dart';\n";
  output += "import '${task.snakeCaseName}_state.dart';\n";
  output += "import '../../domain/use_cases/${feature.snakeCaseName}_main.dart';\n";
  output += "\n\n";
  output += "class ${task.upperCamelCaseName}Cubit extends Cubit<${task.upperCamelCaseName}State> {\n";
  output += "final ${feature.upperCamelCaseName}Main _main;\n";
  output += "${task.upperCamelCaseName}Cubit({\n";
  output += "required ${feature.upperCamelCaseName}Main main,\n";
  output += "})  : _main = main,\n";
  output += "super(const ${task.upperCamelCaseName}State.loading());\n";
  output += "\n\n";
  if (task.method == Method.getListPaginate) {
    output += "List<${task.cubitEntityForSuccess.type}> ${task.cubitEntityForSuccess.name}Full = [];\n";
    output += "bool isDataFinished = false;\n";
    output += "int page = 1;\n";
  }
  output += "\n\n";
  output += "Future<void> initialPage(${task.facadeFunctionParams.map((e) => "${e.type} ${e.name}").toList().join(',')}) async {\n";
  output += "emit(const ${task.upperCamelCaseName}State.loading());\n";
  if (task.offlineMethod == OfflineMethod.offlineAndOnline) {
    output += "await for (final response in _main.${task.methodName}(${task.facadeFunctionParams.map((e) => e.name).toList().join(',')})) {\n";
  } else {
    output += "final response = await _main.${task.methodName}(${task.facadeFunctionParams.map((e) => e.name).toList().join(',')});\n";
  }
  output += "response.fold(\n";
  output += "(failure) => emit(${task.upperCamelCaseName}State.error(failure: failure)),\n";
  if (task.method == Method.getListPaginate) {
    output += "(${task.cubitEntityForSuccess.name}) {\n";
    output += "${task.cubitEntityForSuccess.name}Full=[...${task.cubitEntityForSuccess.name}Full,...${task.cubitEntityForSuccess.name}];\n";
    output += "emit(${task.upperCamelCaseName}State.loaded(${task.cubitEntityForSuccess.name}: ${task.cubitEntityForSuccess.name}Full));\n";
    output += "}\n";
  } else if (task.method == Method.getList) {
    output += "(${task.cubitEntityForSuccess.name}) {\n";
    output += "emit(${task.upperCamelCaseName}State.loaded(${task.cubitEntityForSuccess.name}: ${task.cubitEntityForSuccess.name}));\n";
    output += "}\n";
  } else {
    output +=
        "(${task.cubitEntityForSuccess.name}) => emit(${task.upperCamelCaseName}State.loaded(${task.cubitEntityForSuccess.name}: ${task.cubitEntityForSuccess.name})),\n";
  }
  output += ");\n";
  if (task.offlineMethod == OfflineMethod.offlineAndOnline) {
    output += "}\n";
  }
  output += "}\n";
  if (task.method == Method.getListPaginate) {
    output += "Future<void> moreData(${task.facadeFunctionParams.map((e) => "${e.type} ${e.name}").toList().join(',')}) async {\n";
    output += "if (isDataFinished) {\n";
    output += "return;\n";
    output += "}\n";
    output += "page++;\n";
    output +=
        "_main.${task.methodName}(${task.facadeFunctionParams.map((e) => e.name).toList().join(',')}${task.facadeFunctionParams.isNotEmpty ? "," : ""}page:page);\n";
    output += "}\n";
  }
  output += "}\n";
  return output;
}

String parseCubitSetFile(Feature feature, Task task) {
  String output = "import 'package:flutter_bloc/flutter_bloc.dart';\n";
  output += "import '../../domain/use_cases/${feature.snakeCaseName}_main.dart';\n";
  output += "import '${task.snakeCaseName}_state.dart';\n";
  output += "\n\n";
  output += "class ${task.upperCamelCaseName}Cubit extends Cubit<${task.upperCamelCaseName}State> {\n";
  output += "final ${feature.upperCamelCaseName}Main _main;\n";
  output += "${task.upperCamelCaseName}Cubit({\n";
  output += "required ${feature.upperCamelCaseName}Main main,\n";
  output += "})  : _main = main,\n";
  output += "super(const ${task.upperCamelCaseName}State.readyToInput());\n";
  output += "\n\n";
  output += "Future<void> ${task.methodName}(${task.facadeFunctionParams.map((e) => "${e.type} ${e.name}").toList().join(',')}) async {\n";
  output += "emit(const ${task.upperCamelCaseName}State.loading());\n";
  output += "final response = await _main.${task.methodName}(${task.facadeFunctionParams.map((e) => e.name).toList().join(',')});\n";
  output += "response.fold(\n";
  output += "(failure) => emit(${task.upperCamelCaseName}State.error(failure: failure)),\n";
  output += "() => emit(const ${task.upperCamelCaseName}State.success()),\n";
  output += ");\n";
  output += "}\n";
  output += "}\n";
  return output;
}

String parseStateFile(Task task) {
  String output = "import 'package:freezed_annotation/freezed_annotation.dart';\n";
  output += "import '../../../../common/failures.dart';\n\n";
  output += "part '${convertCamelCaseToSnakeCase(task.cubitName)}_state.freezed.dart';\n";
  output += "\n\n";
  output += "@freezed\n";
  output += "class ${task.upperCamelCaseName}State with _\$${task.upperCamelCaseName}State {\n";
  output += "const factory ${task.upperCamelCaseName}State.loading() = Loading;\n";
  if (task.isGetList) {
    output += "const factory ${task.upperCamelCaseName}State.empty() = Empty;\n";
  }
  output += "const factory ${task.upperCamelCaseName}State.error({required Failure failure}) = Error;\n";
  if (task.isGets) {
    if (task.isGetList) {
      output +=
          "const factory ${task.upperCamelCaseName}State.loaded({required List<${task.cubitEntityForSuccess.type}> ${task.cubitEntityForSuccess.name}}) = Loaded;\n";
    } else {
      output +=
          "const factory ${task.upperCamelCaseName}State.loaded({required ${task.cubitEntityForSuccess.type} ${task.cubitEntityForSuccess.name}}) = Loaded;\n";
    }
  }
  if (!task.isGets) {
    output += "const factory ${task.upperCamelCaseName}State.readyToInput() = ReadyToInput;\n";
    output += "const factory ${task.upperCamelCaseName}State.success() = Success;\n";
  }
  output += "}\n";

  return output;
}

String convertCamelCaseToSnakeCase(String camelCase) {
  if (camelCase.isEmpty) {
    return "";
  }
  String allLowerCase = camelCase.toLowerCase();
  String output = allLowerCase[0];
  for (int i = 1; i < allLowerCase.length; i++) {
    if (allLowerCase[i] == camelCase[i]) {
      output += allLowerCase[i];
    } else {
      output += "_${allLowerCase[i]}";
    }
  }
  return output;
}

String convertCamelCaseToUpperCamelCase(String camelCase) {
  if (camelCase.isEmpty) {
    return camelCase;
  }
  return (camelCase[0].toUpperCase()) + camelCase.substring(1);
}

String convertCamelCaseToLowerCamelCase(String camelCase) {
  if (camelCase.isEmpty) {
    return camelCase;
  }
  return (camelCase[0].toLowerCase()) + camelCase.substring(1);
}

String parseWidgetGetListFile(Task task) {
  String output = "import 'package:flutter/material.dart';\n";
  output += "import 'package:flutter_bloc/flutter_bloc.dart';\n";
  output += "import 'package:flutter_bloc/flutter_bloc.dart';\n";
  output += "import '../../../../common/widgets/loading_widget.dart';\n";
  output += "import '../../../../application/texts.dart';\n";
  output += "import '../manager/${task.snakeCaseName}_cubit.dart';\n";
  output += task.method == Method.getListPaginate ? "import 'package:very_good_infinite_list/very_good_infinite_list.dart';\n" : "";
  output += "import '../manager/${task.snakeCaseName}_state.dart';\n";
  output += "\n\n";
  output += "class ${task.upperCamelCaseName}ListWidget extends StatelessWidget {\n";
  for (var param in task.facadeFunctionParams) {
    output += "final ${param.type} ${param.name};\n\n";
  }
  output +=
      "const ${task.upperCamelCaseName}ListWidget({${task.facadeFunctionParams.map((param) => "required this.${param.name}").toList().join(",")}${task.facadeFunctionParams.isNotEmpty ? "," : ""}Key? key}) : super(key: key);\n\n";
  output += "@override\n";
  output += "Widget build(BuildContext context) {\n";
  output += "_retry(context);\n";
  output += "return Scaffold(\n";
  output += "body: SafeArea(\n";
  output += "child: BlocBuilder<${task.upperCamelCaseName}Cubit, ${task.upperCamelCaseName}State>(\n";
  output += "builder: (context, state) {\n";
  output += "return state.when(\n";
  output += "loading: () => const LoadingWidget(),\n";
  output += "error: (failure) => Center(child: OurText(failure.message)),\n";
  output += "empty: () => Center(child: OurText(Texts.listIsEmpty)),\n";
  output += "loaded: (${task.cubitEntityForSuccess.name}) {\n";
  if (task.method == Method.getList) {
    output += "return ListView.builder(\n";
    output += "padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),\n";
    output += "scrollDirection: Axis.vertical,\n";
    output += "itemCount: ${task.cubitEntityForSuccess.name}.length,\n";
    output += "itemBuilder: (BuildContext context, int index) {\n";
    output += " return ${task.upperCamelCaseName}ItemWidget(${task.cubitEntityForSuccess.name}[index]);\n";
    output += "},\n);\n";
  } else {
    output += "_isLoading = false;\n";
    output += "return InfiniteList(\n";
    output += "itemCount: ${task.cubitEntityForSuccess.name}.length,\n";
    output += "isLoading: _isLoading,\n";
    output += "onFetchData:()=> _fetchMoreData(context),\n";
    output += "itemBuilder: (context, index) {\n";
    output += " return ${task.upperCamelCaseName}ItemWidget(${task.cubitEntityForSuccess.name}[index]);\n";
    output += "},\n);\n";
  }
  output += "},\n);\n},\n),\n),\n);\n}\n";
  output += "void _retry(BuildContext context) {\n";
  output +=
      "BlocProvider.of<${task.upperCamelCaseName}Cubit>(context).initialPage(${task.facadeFunctionParams.map((e) => e.name).toList().join(",")});\n";
  output += "}\n";
  if (task.method == Method.getListPaginate) {
    output += "void _fetchMoreData(BuildContext context) {\n";
    output += "setState(() {\n";
    output += "_isLoading = true;\n";
    output += "});\n";
    output += "await Future.delayed(const Duration(milliseconds: 300));\n";
    output += "_retry(context);\n";
    output += "}\n";
  }

  output += "}\n";

  return output;
}

String parseWidgetSetListFile(Task task) {
  String output = "import 'package:flutter/material.dart';\n";
  output += "import 'package:flutter_bloc/flutter_bloc.dart';\n";
  output += "import '../../../../common/widgets/show_snake_bar.dart';\n";
  output += "import '../../../../common/widgets/loading_widget.dart';\n";
  output += "import '../manager/${task.snakeCaseName}_cubit.dart';\n";
  output += "import '../manager/${task.snakeCaseName}_state.dart';\n\n\n";
  output += "class ${task.upperCamelCaseName}Widget extends StatefulWidget {\n";
  output += "final ${task.cubitEntityForSuccess.type} Function() passDataToButton;\n";
  output += "const ${task.upperCamelCaseName}Widget({required this.passDataToButton, Key? key}) : super(key: key);\n\n";
  output += "@override\n";
  output += "State<${task.upperCamelCaseName}Widget> createState() => _${task.upperCamelCaseName}WidgetState();\n";
  output += "}\n";
  output += "\n\n";
  output += "class _${task.upperCamelCaseName}WidgetState extends State<${task.upperCamelCaseName}Widget> {\n";
  output += "bool isLoading = false;\n\n";
  output += "@override\n";
  output += "Widget build(BuildContext context) {\n";
  output += "return BlocListener<${task.upperCamelCaseName}Cubit, ${task.upperCamelCaseName}State>(\n";
  output += "listener: (context, state) {\n";
  output += "isLoading = false;\n";
  output += "return state.when(\n";
  output += "readyToInput: () => isLoading = false,\n";
  output += "loading: () => isLoading = true,\n";
  output += "error: (failure) => showSnakeBar(context, failure.message),\n";
  output += "success: () {\n";
  output += "//todo success\n";
  output += "},\n";
  output += ");\n";
  output += "setState(() {});\n";
  output += "},\n";
  output += "child: ElevatedButton(\n";
  output += "onPressed: () {\n";
  output += "BlocProvider.of<${task.upperCamelCaseName}Cubit>(context).${task.methodName}(widget.passDataToButton());\n";
  output += "},\n";
  output += "child: isLoading ? LoadingWidget(size: 25, color: Colors.white) : Text('${task.methodName}'),\n";
  output += "),\n";
  output += ");\n";
  output += "}\n";
  output += "}\n";

  return output;
}
