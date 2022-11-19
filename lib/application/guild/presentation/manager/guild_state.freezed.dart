// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'guild_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GuildState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Guild guild) loaded,
    required TResult Function() loading,
    required TResult Function(Failure failure) error,
    required TResult Function(Failure failure) errorSave,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loaded value) loaded,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
    required TResult Function(ErrorSave value) errorSave,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuildStateCopyWith<$Res> {
  factory $GuildStateCopyWith(
          GuildState value, $Res Function(GuildState) then) =
      _$GuildStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$GuildStateCopyWithImpl<$Res> implements $GuildStateCopyWith<$Res> {
  _$GuildStateCopyWithImpl(this._value, this._then);

  final GuildState _value;
  // ignore: unused_field
  final $Res Function(GuildState) _then;
}

/// @nodoc
abstract class _$$LoadedCopyWith<$Res> {
  factory _$$LoadedCopyWith(_$Loaded value, $Res Function(_$Loaded) then) =
      __$$LoadedCopyWithImpl<$Res>;
  $Res call({Guild guild});
}

/// @nodoc
class __$$LoadedCopyWithImpl<$Res> extends _$GuildStateCopyWithImpl<$Res>
    implements _$$LoadedCopyWith<$Res> {
  __$$LoadedCopyWithImpl(_$Loaded _value, $Res Function(_$Loaded) _then)
      : super(_value, (v) => _then(v as _$Loaded));

  @override
  _$Loaded get _value => super._value as _$Loaded;

  @override
  $Res call({
    Object? guild = freezed,
  }) {
    return _then(_$Loaded(
      guild: guild == freezed
          ? _value.guild
          : guild // ignore: cast_nullable_to_non_nullable
              as Guild,
    ));
  }
}

/// @nodoc

class _$Loaded implements Loaded {
  const _$Loaded({required this.guild});

  @override
  final Guild guild;

  @override
  String toString() {
    return 'GuildState.loaded(guild: $guild)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Loaded &&
            const DeepCollectionEquality().equals(other.guild, guild));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(guild));

  @JsonKey(ignore: true)
  @override
  _$$LoadedCopyWith<_$Loaded> get copyWith =>
      __$$LoadedCopyWithImpl<_$Loaded>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Guild guild) loaded,
    required TResult Function() loading,
    required TResult Function(Failure failure) error,
    required TResult Function(Failure failure) errorSave,
  }) {
    return loaded(guild);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
  }) {
    return loaded?.call(guild);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(guild);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loaded value) loaded,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
    required TResult Function(ErrorSave value) errorSave,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class Loaded implements GuildState {
  const factory Loaded({required final Guild guild}) = _$Loaded;

  Guild get guild;
  @JsonKey(ignore: true)
  _$$LoadedCopyWith<_$Loaded> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingCopyWith<$Res> {
  factory _$$LoadingCopyWith(_$Loading value, $Res Function(_$Loading) then) =
      __$$LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingCopyWithImpl<$Res> extends _$GuildStateCopyWithImpl<$Res>
    implements _$$LoadingCopyWith<$Res> {
  __$$LoadingCopyWithImpl(_$Loading _value, $Res Function(_$Loading) _then)
      : super(_value, (v) => _then(v as _$Loading));

  @override
  _$Loading get _value => super._value as _$Loading;
}

/// @nodoc

class _$Loading implements Loading {
  const _$Loading();

  @override
  String toString() {
    return 'GuildState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Guild guild) loaded,
    required TResult Function() loading,
    required TResult Function(Failure failure) error,
    required TResult Function(Failure failure) errorSave,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loaded value) loaded,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
    required TResult Function(ErrorSave value) errorSave,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements GuildState {
  const factory Loading() = _$Loading;
}

/// @nodoc
abstract class _$$ErrorCopyWith<$Res> {
  factory _$$ErrorCopyWith(_$Error value, $Res Function(_$Error) then) =
      __$$ErrorCopyWithImpl<$Res>;
  $Res call({Failure failure});
}

/// @nodoc
class __$$ErrorCopyWithImpl<$Res> extends _$GuildStateCopyWithImpl<$Res>
    implements _$$ErrorCopyWith<$Res> {
  __$$ErrorCopyWithImpl(_$Error _value, $Res Function(_$Error) _then)
      : super(_value, (v) => _then(v as _$Error));

  @override
  _$Error get _value => super._value as _$Error;

  @override
  $Res call({
    Object? failure = freezed,
  }) {
    return _then(_$Error(
      failure: failure == freezed
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$Error implements Error {
  const _$Error({required this.failure});

  @override
  final Failure failure;

  @override
  String toString() {
    return 'GuildState.error(failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error &&
            const DeepCollectionEquality().equals(other.failure, failure));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(failure));

  @JsonKey(ignore: true)
  @override
  _$$ErrorCopyWith<_$Error> get copyWith =>
      __$$ErrorCopyWithImpl<_$Error>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Guild guild) loaded,
    required TResult Function() loading,
    required TResult Function(Failure failure) error,
    required TResult Function(Failure failure) errorSave,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loaded value) loaded,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
    required TResult Function(ErrorSave value) errorSave,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements GuildState {
  const factory Error({required final Failure failure}) = _$Error;

  Failure get failure;
  @JsonKey(ignore: true)
  _$$ErrorCopyWith<_$Error> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorSaveCopyWith<$Res> {
  factory _$$ErrorSaveCopyWith(
          _$ErrorSave value, $Res Function(_$ErrorSave) then) =
      __$$ErrorSaveCopyWithImpl<$Res>;
  $Res call({Failure failure});
}

/// @nodoc
class __$$ErrorSaveCopyWithImpl<$Res> extends _$GuildStateCopyWithImpl<$Res>
    implements _$$ErrorSaveCopyWith<$Res> {
  __$$ErrorSaveCopyWithImpl(
      _$ErrorSave _value, $Res Function(_$ErrorSave) _then)
      : super(_value, (v) => _then(v as _$ErrorSave));

  @override
  _$ErrorSave get _value => super._value as _$ErrorSave;

  @override
  $Res call({
    Object? failure = freezed,
  }) {
    return _then(_$ErrorSave(
      failure: failure == freezed
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$ErrorSave implements ErrorSave {
  const _$ErrorSave({required this.failure});

  @override
  final Failure failure;

  @override
  String toString() {
    return 'GuildState.errorSave(failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorSave &&
            const DeepCollectionEquality().equals(other.failure, failure));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(failure));

  @JsonKey(ignore: true)
  @override
  _$$ErrorSaveCopyWith<_$ErrorSave> get copyWith =>
      __$$ErrorSaveCopyWithImpl<_$ErrorSave>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Guild guild) loaded,
    required TResult Function() loading,
    required TResult Function(Failure failure) error,
    required TResult Function(Failure failure) errorSave,
  }) {
    return errorSave(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
  }) {
    return errorSave?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Guild guild)? loaded,
    TResult Function()? loading,
    TResult Function(Failure failure)? error,
    TResult Function(Failure failure)? errorSave,
    required TResult orElse(),
  }) {
    if (errorSave != null) {
      return errorSave(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Loaded value) loaded,
    required TResult Function(Loading value) loading,
    required TResult Function(Error value) error,
    required TResult Function(ErrorSave value) errorSave,
  }) {
    return errorSave(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
  }) {
    return errorSave?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Loaded value)? loaded,
    TResult Function(Loading value)? loading,
    TResult Function(Error value)? error,
    TResult Function(ErrorSave value)? errorSave,
    required TResult orElse(),
  }) {
    if (errorSave != null) {
      return errorSave(this);
    }
    return orElse();
  }
}

abstract class ErrorSave implements GuildState {
  const factory ErrorSave({required final Failure failure}) = _$ErrorSave;

  Failure get failure;
  @JsonKey(ignore: true)
  _$$ErrorSaveCopyWith<_$ErrorSave> get copyWith =>
      throw _privateConstructorUsedError;
}
