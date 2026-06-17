// This is a generated file - do not edit.
//
// Generated from track.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class TrackMetadata extends $pb.GeneratedMessage {
  factory TrackMetadata({
    $core.String? trackId,
    $core.String? title,
    $core.String? artistId,
    $core.String? artistName,
    $core.String? duration,
    $core.String? thumbnailUrl,
    $core.String? originalYoutubeId,
    $core.int? playCount,
    $core.int? likesCount,
  }) {
    final result = create();
    if (trackId != null) result.trackId = trackId;
    if (title != null) result.title = title;
    if (artistId != null) result.artistId = artistId;
    if (artistName != null) result.artistName = artistName;
    if (duration != null) result.duration = duration;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (originalYoutubeId != null) result.originalYoutubeId = originalYoutubeId;
    if (playCount != null) result.playCount = playCount;
    if (likesCount != null) result.likesCount = likesCount;
    return result;
  }

  TrackMetadata._();

  factory TrackMetadata.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrackMetadata.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackMetadata',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'artistId')
    ..aOS(4, _omitFieldNames ? '' : 'artistName')
    ..aOS(5, _omitFieldNames ? '' : 'duration')
    ..aOS(6, _omitFieldNames ? '' : 'thumbnailUrl')
    ..aOS(7, _omitFieldNames ? '' : 'originalYoutubeId')
    ..aI(8, _omitFieldNames ? '' : 'playCount')
    ..aI(9, _omitFieldNames ? '' : 'likesCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackMetadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackMetadata copyWith(void Function(TrackMetadata) updates) =>
      super.copyWith((message) => updates(message as TrackMetadata))
          as TrackMetadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackMetadata create() => TrackMetadata._();
  @$core.override
  TrackMetadata createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrackMetadata getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrackMetadata>(create);
  static TrackMetadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get artistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set artistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArtistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearArtistId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get artistName => $_getSZ(3);
  @$pb.TagNumber(4)
  set artistName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasArtistName() => $_has(3);
  @$pb.TagNumber(4)
  void clearArtistName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get duration => $_getSZ(4);
  @$pb.TagNumber(5)
  set duration($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDuration() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get thumbnailUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set thumbnailUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasThumbnailUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearThumbnailUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get originalYoutubeId => $_getSZ(6);
  @$pb.TagNumber(7)
  set originalYoutubeId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOriginalYoutubeId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOriginalYoutubeId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get playCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set playCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPlayCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlayCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get likesCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set likesCount($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLikesCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearLikesCount() => $_clearField(9);
}

class SearchRequest extends $pb.GeneratedMessage {
  factory SearchRequest({
    $core.String? query,
    $core.int? page,
  }) {
    final result = create();
    if (query != null) result.query = query;
    if (page != null) result.page = page;
    return result;
  }

  SearchRequest._();

  factory SearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aI(2, _omitFieldNames ? '' : 'page')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest copyWith(void Function(SearchRequest) updates) =>
      super.copyWith((message) => updates(message as SearchRequest))
          as SearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchRequest create() => SearchRequest._();
  @$core.override
  SearchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchRequest>(create);
  static SearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get page => $_getIZ(1);
  @$pb.TagNumber(2)
  set page($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);
}

class SearchResponse extends $pb.GeneratedMessage {
  factory SearchResponse({
    $core.Iterable<TrackMetadata>? tracks,
  }) {
    final result = create();
    if (tracks != null) result.tracks.addAll(tracks);
    return result;
  }

  SearchResponse._();

  factory SearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..pPM<TrackMetadata>(1, _omitFieldNames ? '' : 'tracks',
        subBuilder: TrackMetadata.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse copyWith(void Function(SearchResponse) updates) =>
      super.copyWith((message) => updates(message as SearchResponse))
          as SearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchResponse create() => SearchResponse._();
  @$core.override
  SearchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchResponse>(create);
  static SearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TrackMetadata> get tracks => $_getList(0);
}

class StreamRequest extends $pb.GeneratedMessage {
  factory StreamRequest({
    $core.String? trackId,
    $core.String? originalYoutubeId,
  }) {
    final result = create();
    if (trackId != null) result.trackId = trackId;
    if (originalYoutubeId != null) result.originalYoutubeId = originalYoutubeId;
    return result;
  }

  StreamRequest._();

  factory StreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackId')
    ..aOS(2, _omitFieldNames ? '' : 'originalYoutubeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamRequest copyWith(void Function(StreamRequest) updates) =>
      super.copyWith((message) => updates(message as StreamRequest))
          as StreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamRequest create() => StreamRequest._();
  @$core.override
  StreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamRequest>(create);
  static StreamRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get originalYoutubeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set originalYoutubeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOriginalYoutubeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOriginalYoutubeId() => $_clearField(2);
}

class StreamResponse extends $pb.GeneratedMessage {
  factory StreamResponse({
    $core.String? streamUrl,
    $fixnum.Int64? linkExpiresAt,
  }) {
    final result = create();
    if (streamUrl != null) result.streamUrl = streamUrl;
    if (linkExpiresAt != null) result.linkExpiresAt = linkExpiresAt;
    return result;
  }

  StreamResponse._();

  factory StreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'streamUrl')
    ..aInt64(2, _omitFieldNames ? '' : 'linkExpiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamResponse copyWith(void Function(StreamResponse) updates) =>
      super.copyWith((message) => updates(message as StreamResponse))
          as StreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamResponse create() => StreamResponse._();
  @$core.override
  StreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamResponse>(create);
  static StreamResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get streamUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set streamUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStreamUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearStreamUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get linkExpiresAt => $_getI64(1);
  @$pb.TagNumber(2)
  set linkExpiresAt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLinkExpiresAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearLinkExpiresAt() => $_clearField(2);
}

class TrendingRequest extends $pb.GeneratedMessage {
  factory TrendingRequest({
    $core.int? limit,
  }) {
    final result = create();
    if (limit != null) result.limit = limit;
    return result;
  }

  TrendingRequest._();

  factory TrendingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrendingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendingRequest copyWith(void Function(TrendingRequest) updates) =>
      super.copyWith((message) => updates(message as TrendingRequest))
          as TrendingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrendingRequest create() => TrendingRequest._();
  @$core.override
  TrendingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrendingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendingRequest>(create);
  static TrendingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class TrendingResponse extends $pb.GeneratedMessage {
  factory TrendingResponse({
    $core.Iterable<TrackMetadata>? tracks,
  }) {
    final result = create();
    if (tracks != null) result.tracks.addAll(tracks);
    return result;
  }

  TrendingResponse._();

  factory TrendingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrendingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrendingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..pPM<TrackMetadata>(1, _omitFieldNames ? '' : 'tracks',
        subBuilder: TrackMetadata.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrendingResponse copyWith(void Function(TrendingResponse) updates) =>
      super.copyWith((message) => updates(message as TrendingResponse))
          as TrendingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrendingResponse create() => TrendingResponse._();
  @$core.override
  TrendingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrendingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrendingResponse>(create);
  static TrendingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TrackMetadata> get tracks => $_getList(0);
}

class PlaybackTelemetryRequest extends $pb.GeneratedMessage {
  factory PlaybackTelemetryRequest({
    $core.String? userId,
    $core.String? trackId,
    $core.int? lastPositionSeconds,
    $core.bool? isCompleted,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (trackId != null) result.trackId = trackId;
    if (lastPositionSeconds != null)
      result.lastPositionSeconds = lastPositionSeconds;
    if (isCompleted != null) result.isCompleted = isCompleted;
    return result;
  }

  PlaybackTelemetryRequest._();

  factory PlaybackTelemetryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackTelemetryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackTelemetryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'trackId')
    ..aI(3, _omitFieldNames ? '' : 'lastPositionSeconds')
    ..aOB(4, _omitFieldNames ? '' : 'isCompleted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackTelemetryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackTelemetryRequest copyWith(
          void Function(PlaybackTelemetryRequest) updates) =>
      super.copyWith((message) => updates(message as PlaybackTelemetryRequest))
          as PlaybackTelemetryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackTelemetryRequest create() => PlaybackTelemetryRequest._();
  @$core.override
  PlaybackTelemetryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackTelemetryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackTelemetryRequest>(create);
  static PlaybackTelemetryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get trackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set trackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get lastPositionSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set lastPositionSeconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastPositionSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastPositionSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isCompleted => $_getBF(3);
  @$pb.TagNumber(4)
  set isCompleted($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsCompleted() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsCompleted() => $_clearField(4);
}

class PlaybackTelemetryResponse extends $pb.GeneratedMessage {
  factory PlaybackTelemetryResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  PlaybackTelemetryResponse._();

  factory PlaybackTelemetryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackTelemetryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackTelemetryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackTelemetryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackTelemetryResponse copyWith(
          void Function(PlaybackTelemetryResponse) updates) =>
      super.copyWith((message) => updates(message as PlaybackTelemetryResponse))
          as PlaybackTelemetryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackTelemetryResponse create() => PlaybackTelemetryResponse._();
  @$core.override
  PlaybackTelemetryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackTelemetryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackTelemetryResponse>(create);
  static PlaybackTelemetryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class RecentlyPlayedRequest extends $pb.GeneratedMessage {
  factory RecentlyPlayedRequest({
    $core.String? userId,
    $core.int? limit,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (limit != null) result.limit = limit;
    return result;
  }

  RecentlyPlayedRequest._();

  factory RecentlyPlayedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecentlyPlayedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecentlyPlayedRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecentlyPlayedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecentlyPlayedRequest copyWith(
          void Function(RecentlyPlayedRequest) updates) =>
      super.copyWith((message) => updates(message as RecentlyPlayedRequest))
          as RecentlyPlayedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecentlyPlayedRequest create() => RecentlyPlayedRequest._();
  @$core.override
  RecentlyPlayedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecentlyPlayedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecentlyPlayedRequest>(create);
  static RecentlyPlayedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class RecentlyPlayedResponse extends $pb.GeneratedMessage {
  factory RecentlyPlayedResponse({
    $core.Iterable<TrackMetadata>? tracks,
  }) {
    final result = create();
    if (tracks != null) result.tracks.addAll(tracks);
    return result;
  }

  RecentlyPlayedResponse._();

  factory RecentlyPlayedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecentlyPlayedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecentlyPlayedResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..pPM<TrackMetadata>(1, _omitFieldNames ? '' : 'tracks',
        subBuilder: TrackMetadata.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecentlyPlayedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecentlyPlayedResponse copyWith(
          void Function(RecentlyPlayedResponse) updates) =>
      super.copyWith((message) => updates(message as RecentlyPlayedResponse))
          as RecentlyPlayedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecentlyPlayedResponse create() => RecentlyPlayedResponse._();
  @$core.override
  RecentlyPlayedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecentlyPlayedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecentlyPlayedResponse>(create);
  static RecentlyPlayedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TrackMetadata> get tracks => $_getList(0);
}

class InteractionRequest extends $pb.GeneratedMessage {
  factory InteractionRequest({
    $core.String? userId,
    $core.String? trackId,
    $core.bool? isLiked,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (trackId != null) result.trackId = trackId;
    if (isLiked != null) result.isLiked = isLiked;
    return result;
  }

  InteractionRequest._();

  factory InteractionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InteractionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InteractionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'trackId')
    ..aOB(3, _omitFieldNames ? '' : 'isLiked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InteractionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InteractionRequest copyWith(void Function(InteractionRequest) updates) =>
      super.copyWith((message) => updates(message as InteractionRequest))
          as InteractionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InteractionRequest create() => InteractionRequest._();
  @$core.override
  InteractionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InteractionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InteractionRequest>(create);
  static InteractionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get trackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set trackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isLiked => $_getBF(2);
  @$pb.TagNumber(3)
  set isLiked($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsLiked() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsLiked() => $_clearField(3);
}

class InteractionResponse extends $pb.GeneratedMessage {
  factory InteractionResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  InteractionResponse._();

  factory InteractionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InteractionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InteractionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InteractionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InteractionResponse copyWith(void Function(InteractionResponse) updates) =>
      super.copyWith((message) => updates(message as InteractionResponse))
          as InteractionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InteractionResponse create() => InteractionResponse._();
  @$core.override
  InteractionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InteractionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InteractionResponse>(create);
  static InteractionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class CreatePlaylistRequest extends $pb.GeneratedMessage {
  factory CreatePlaylistRequest({
    $core.String? userId,
    $core.String? name,
    $core.String? coverImageUrl,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (name != null) result.name = name;
    if (coverImageUrl != null) result.coverImageUrl = coverImageUrl;
    return result;
  }

  CreatePlaylistRequest._();

  factory CreatePlaylistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatePlaylistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePlaylistRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'coverImageUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePlaylistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePlaylistRequest copyWith(
          void Function(CreatePlaylistRequest) updates) =>
      super.copyWith((message) => updates(message as CreatePlaylistRequest))
          as CreatePlaylistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePlaylistRequest create() => CreatePlaylistRequest._();
  @$core.override
  CreatePlaylistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreatePlaylistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePlaylistRequest>(create);
  static CreatePlaylistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get coverImageUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set coverImageUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverImageUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverImageUrl() => $_clearField(3);
}

class PlaylistResponse extends $pb.GeneratedMessage {
  factory PlaylistResponse({
    $core.String? playlistId,
    $core.String? name,
    $core.String? userId,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    if (name != null) result.name = name;
    if (userId != null) result.userId = userId;
    return result;
  }

  PlaylistResponse._();

  factory PlaylistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistResponse copyWith(void Function(PlaylistResponse) updates) =>
      super.copyWith((message) => updates(message as PlaylistResponse))
          as PlaylistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistResponse create() => PlaylistResponse._();
  @$core.override
  PlaylistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistResponse>(create);
  static PlaylistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);
}

class PlaylistTrackRequest extends $pb.GeneratedMessage {
  factory PlaylistTrackRequest({
    $core.String? playlistId,
    $core.String? trackId,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    if (trackId != null) result.trackId = trackId;
    return result;
  }

  PlaylistTrackRequest._();

  factory PlaylistTrackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistTrackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistTrackRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..aOS(2, _omitFieldNames ? '' : 'trackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistTrackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistTrackRequest copyWith(void Function(PlaylistTrackRequest) updates) =>
      super.copyWith((message) => updates(message as PlaylistTrackRequest))
          as PlaylistTrackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistTrackRequest create() => PlaylistTrackRequest._();
  @$core.override
  PlaylistTrackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistTrackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistTrackRequest>(create);
  static PlaylistTrackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get trackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set trackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackId() => $_clearField(2);
}

class PlaylistActionResponse extends $pb.GeneratedMessage {
  factory PlaylistActionResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  PlaylistActionResponse._();

  factory PlaylistActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistActionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'track'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistActionResponse copyWith(
          void Function(PlaylistActionResponse) updates) =>
      super.copyWith((message) => updates(message as PlaylistActionResponse))
          as PlaylistActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistActionResponse create() => PlaylistActionResponse._();
  @$core.override
  PlaylistActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistActionResponse>(create);
  static PlaylistActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
