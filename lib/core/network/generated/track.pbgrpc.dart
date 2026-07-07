// This is a generated file - do not edit.
//
// Generated from track.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'track.pb.dart' as $0;

export 'track.pb.dart';

@$pb.GrpcServiceName('track.TrackService')
class TrackServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TrackServiceClient(super.channel, {super.options, super.interceptors});

  /// TRACK DISCOVERY LAYER
  $grpc.ResponseFuture<$0.SearchResponse> searchTrack(
    $0.SearchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$searchTrack, request, options: options);
  }

  $grpc.ResponseFuture<$0.StreamResponse> getStreamURL(
    $0.StreamRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStreamURL, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrendingResponse> getTrendingTracks(
    $0.TrendingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTrendingTracks, request, options: options);
  }

  $grpc.ResponseFuture<$0.ForYouResponse> getForYou(
    $0.ForYouRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getForYou, request, options: options);
  }

  /// TELEMETRY & PLAYBACK SYNC LAYER
  $grpc.ResponseFuture<$0.PlaybackTelemetryResponse> syncPlaybackTelemetry(
    $0.PlaybackTelemetryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$syncPlaybackTelemetry, request, options: options);
  }

  $grpc.ResponseFuture<$0.RecentlyPlayedResponse> getRecentlyPlayed(
    $0.RecentlyPlayedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRecentlyPlayed, request, options: options);
  }

  /// USER LIBRARY & PLAYLIST LAYER
  $grpc.ResponseFuture<$0.InteractionResponse> setTrackInteraction(
    $0.InteractionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setTrackInteraction, request, options: options);
  }

  $grpc.ResponseFuture<$0.PlaylistResponse> createPlaylist(
    $0.CreatePlaylistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPlaylist, request, options: options);
  }

  $grpc.ResponseFuture<$0.PlaylistActionResponse> addToPlaylist(
    $0.PlaylistTrackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addToPlaylist, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPlaylistResponse> getPlaylist(
    $0.GetPlaylistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPlaylist, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserPlaylistsResponse> getUserPlaylists(
    $0.GetUserPlaylistsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserPlaylists, request, options: options);
  }

  /// — Admin operations
  $grpc.ResponseFuture<$0.SeedTrackResponse> seedTrack(
    $0.SeedTrackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$seedTrack, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListTracksAdminResponse> listTracksAdmin(
    $0.ListTracksAdminRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTracksAdmin, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrackActionResponse> approveTrack(
    $0.TrackActionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approveTrack, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrackActionResponse> rejectTrack(
    $0.TrackActionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rejectTrack, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrackActionResponse> featureTrack(
    $0.FeatureTrackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$featureTrack, request, options: options);
  }

  $grpc.ResponseFuture<$0.TrackActionResponse> deleteTrack(
    $0.TrackActionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteTrack, request, options: options);
  }

  $grpc.ResponseFuture<$0.AdminStatsResponse> getAdminStats(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAdminStats, request, options: options);
  }

  /// — User liked tracks
  $grpc.ResponseFuture<$0.GetLikedTracksResponse> getLikedTracks(
    $0.GetLikedTracksRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLikedTracks, request, options: options);
  }

  // method descriptors

  static final _$searchTrack =
      $grpc.ClientMethod<$0.SearchRequest, $0.SearchResponse>(
          '/track.TrackService/SearchTrack',
          ($0.SearchRequest value) => value.writeToBuffer(),
          $0.SearchResponse.fromBuffer);
  static final _$getStreamURL =
      $grpc.ClientMethod<$0.StreamRequest, $0.StreamResponse>(
          '/track.TrackService/GetStreamURL',
          ($0.StreamRequest value) => value.writeToBuffer(),
          $0.StreamResponse.fromBuffer);
  static final _$getTrendingTracks =
      $grpc.ClientMethod<$0.TrendingRequest, $0.TrendingResponse>(
          '/track.TrackService/GetTrendingTracks',
          ($0.TrendingRequest value) => value.writeToBuffer(),
          $0.TrendingResponse.fromBuffer);
  static final _$getForYou =
      $grpc.ClientMethod<$0.ForYouRequest, $0.ForYouResponse>(
          '/track.TrackService/GetForYou',
          ($0.ForYouRequest value) => value.writeToBuffer(),
          $0.ForYouResponse.fromBuffer);
  static final _$syncPlaybackTelemetry = $grpc.ClientMethod<
          $0.PlaybackTelemetryRequest, $0.PlaybackTelemetryResponse>(
      '/track.TrackService/SyncPlaybackTelemetry',
      ($0.PlaybackTelemetryRequest value) => value.writeToBuffer(),
      $0.PlaybackTelemetryResponse.fromBuffer);
  static final _$getRecentlyPlayed =
      $grpc.ClientMethod<$0.RecentlyPlayedRequest, $0.RecentlyPlayedResponse>(
          '/track.TrackService/GetRecentlyPlayed',
          ($0.RecentlyPlayedRequest value) => value.writeToBuffer(),
          $0.RecentlyPlayedResponse.fromBuffer);
  static final _$setTrackInteraction =
      $grpc.ClientMethod<$0.InteractionRequest, $0.InteractionResponse>(
          '/track.TrackService/SetTrackInteraction',
          ($0.InteractionRequest value) => value.writeToBuffer(),
          $0.InteractionResponse.fromBuffer);
  static final _$createPlaylist =
      $grpc.ClientMethod<$0.CreatePlaylistRequest, $0.PlaylistResponse>(
          '/track.TrackService/CreatePlaylist',
          ($0.CreatePlaylistRequest value) => value.writeToBuffer(),
          $0.PlaylistResponse.fromBuffer);
  static final _$addToPlaylist =
      $grpc.ClientMethod<$0.PlaylistTrackRequest, $0.PlaylistActionResponse>(
          '/track.TrackService/AddToPlaylist',
          ($0.PlaylistTrackRequest value) => value.writeToBuffer(),
          $0.PlaylistActionResponse.fromBuffer);
  static final _$getPlaylist =
      $grpc.ClientMethod<$0.GetPlaylistRequest, $0.GetPlaylistResponse>(
          '/track.TrackService/GetPlaylist',
          ($0.GetPlaylistRequest value) => value.writeToBuffer(),
          $0.GetPlaylistResponse.fromBuffer);
  static final _$getUserPlaylists = $grpc.ClientMethod<
          $0.GetUserPlaylistsRequest, $0.GetUserPlaylistsResponse>(
      '/track.TrackService/GetUserPlaylists',
      ($0.GetUserPlaylistsRequest value) => value.writeToBuffer(),
      $0.GetUserPlaylistsResponse.fromBuffer);
  static final _$seedTrack =
      $grpc.ClientMethod<$0.SeedTrackRequest, $0.SeedTrackResponse>(
          '/track.TrackService/SeedTrack',
          ($0.SeedTrackRequest value) => value.writeToBuffer(),
          $0.SeedTrackResponse.fromBuffer);
  static final _$listTracksAdmin =
      $grpc.ClientMethod<$0.ListTracksAdminRequest, $0.ListTracksAdminResponse>(
          '/track.TrackService/ListTracksAdmin',
          ($0.ListTracksAdminRequest value) => value.writeToBuffer(),
          $0.ListTracksAdminResponse.fromBuffer);
  static final _$approveTrack =
      $grpc.ClientMethod<$0.TrackActionRequest, $0.TrackActionResponse>(
          '/track.TrackService/ApproveTrack',
          ($0.TrackActionRequest value) => value.writeToBuffer(),
          $0.TrackActionResponse.fromBuffer);
  static final _$rejectTrack =
      $grpc.ClientMethod<$0.TrackActionRequest, $0.TrackActionResponse>(
          '/track.TrackService/RejectTrack',
          ($0.TrackActionRequest value) => value.writeToBuffer(),
          $0.TrackActionResponse.fromBuffer);
  static final _$featureTrack =
      $grpc.ClientMethod<$0.FeatureTrackRequest, $0.TrackActionResponse>(
          '/track.TrackService/FeatureTrack',
          ($0.FeatureTrackRequest value) => value.writeToBuffer(),
          $0.TrackActionResponse.fromBuffer);
  static final _$deleteTrack =
      $grpc.ClientMethod<$0.TrackActionRequest, $0.TrackActionResponse>(
          '/track.TrackService/DeleteTrack',
          ($0.TrackActionRequest value) => value.writeToBuffer(),
          $0.TrackActionResponse.fromBuffer);
  static final _$getAdminStats =
      $grpc.ClientMethod<$0.Empty, $0.AdminStatsResponse>(
          '/track.TrackService/GetAdminStats',
          ($0.Empty value) => value.writeToBuffer(),
          $0.AdminStatsResponse.fromBuffer);
  static final _$getLikedTracks =
      $grpc.ClientMethod<$0.GetLikedTracksRequest, $0.GetLikedTracksResponse>(
          '/track.TrackService/GetLikedTracks',
          ($0.GetLikedTracksRequest value) => value.writeToBuffer(),
          $0.GetLikedTracksResponse.fromBuffer);
}

@$pb.GrpcServiceName('track.TrackService')
abstract class TrackServiceBase extends $grpc.Service {
  $core.String get $name => 'track.TrackService';

  TrackServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SearchRequest, $0.SearchResponse>(
        'SearchTrack',
        searchTrack_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SearchRequest.fromBuffer(value),
        ($0.SearchResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StreamRequest, $0.StreamResponse>(
        'GetStreamURL',
        getStreamURL_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StreamRequest.fromBuffer(value),
        ($0.StreamResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrendingRequest, $0.TrendingResponse>(
        'GetTrendingTracks',
        getTrendingTracks_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TrendingRequest.fromBuffer(value),
        ($0.TrendingResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ForYouRequest, $0.ForYouResponse>(
        'GetForYou',
        getForYou_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ForYouRequest.fromBuffer(value),
        ($0.ForYouResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PlaybackTelemetryRequest,
            $0.PlaybackTelemetryResponse>(
        'SyncPlaybackTelemetry',
        syncPlaybackTelemetry_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PlaybackTelemetryRequest.fromBuffer(value),
        ($0.PlaybackTelemetryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RecentlyPlayedRequest,
            $0.RecentlyPlayedResponse>(
        'GetRecentlyPlayed',
        getRecentlyPlayed_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RecentlyPlayedRequest.fromBuffer(value),
        ($0.RecentlyPlayedResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.InteractionRequest, $0.InteractionResponse>(
            'SetTrackInteraction',
            setTrackInteraction_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.InteractionRequest.fromBuffer(value),
            ($0.InteractionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CreatePlaylistRequest, $0.PlaylistResponse>(
            'CreatePlaylist',
            createPlaylist_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CreatePlaylistRequest.fromBuffer(value),
            ($0.PlaylistResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PlaylistTrackRequest, $0.PlaylistActionResponse>(
            'AddToPlaylist',
            addToPlaylist_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PlaylistTrackRequest.fromBuffer(value),
            ($0.PlaylistActionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetPlaylistRequest, $0.GetPlaylistResponse>(
            'GetPlaylist',
            getPlaylist_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPlaylistRequest.fromBuffer(value),
            ($0.GetPlaylistResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUserPlaylistsRequest,
            $0.GetUserPlaylistsResponse>(
        'GetUserPlaylists',
        getUserPlaylists_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetUserPlaylistsRequest.fromBuffer(value),
        ($0.GetUserPlaylistsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SeedTrackRequest, $0.SeedTrackResponse>(
        'SeedTrack',
        seedTrack_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SeedTrackRequest.fromBuffer(value),
        ($0.SeedTrackResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListTracksAdminRequest,
            $0.ListTracksAdminResponse>(
        'ListTracksAdmin',
        listTracksAdmin_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListTracksAdminRequest.fromBuffer(value),
        ($0.ListTracksAdminResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.TrackActionRequest, $0.TrackActionResponse>(
            'ApproveTrack',
            approveTrack_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.TrackActionRequest.fromBuffer(value),
            ($0.TrackActionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.TrackActionRequest, $0.TrackActionResponse>(
            'RejectTrack',
            rejectTrack_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.TrackActionRequest.fromBuffer(value),
            ($0.TrackActionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.FeatureTrackRequest, $0.TrackActionResponse>(
            'FeatureTrack',
            featureTrack_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.FeatureTrackRequest.fromBuffer(value),
            ($0.TrackActionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.TrackActionRequest, $0.TrackActionResponse>(
            'DeleteTrack',
            deleteTrack_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.TrackActionRequest.fromBuffer(value),
            ($0.TrackActionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.AdminStatsResponse>(
        'GetAdminStats',
        getAdminStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.AdminStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLikedTracksRequest,
            $0.GetLikedTracksResponse>(
        'GetLikedTracks',
        getLikedTracks_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLikedTracksRequest.fromBuffer(value),
        ($0.GetLikedTracksResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SearchResponse> searchTrack_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SearchRequest> $request) async {
    return searchTrack($call, await $request);
  }

  $async.Future<$0.SearchResponse> searchTrack(
      $grpc.ServiceCall call, $0.SearchRequest request);

  $async.Future<$0.StreamResponse> getStreamURL_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.StreamRequest> $request) async {
    return getStreamURL($call, await $request);
  }

  $async.Future<$0.StreamResponse> getStreamURL(
      $grpc.ServiceCall call, $0.StreamRequest request);

  $async.Future<$0.TrendingResponse> getTrendingTracks_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrendingRequest> $request) async {
    return getTrendingTracks($call, await $request);
  }

  $async.Future<$0.TrendingResponse> getTrendingTracks(
      $grpc.ServiceCall call, $0.TrendingRequest request);

  $async.Future<$0.ForYouResponse> getForYou_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ForYouRequest> $request) async {
    return getForYou($call, await $request);
  }

  $async.Future<$0.ForYouResponse> getForYou(
      $grpc.ServiceCall call, $0.ForYouRequest request);

  $async.Future<$0.PlaybackTelemetryResponse> syncPlaybackTelemetry_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PlaybackTelemetryRequest> $request) async {
    return syncPlaybackTelemetry($call, await $request);
  }

  $async.Future<$0.PlaybackTelemetryResponse> syncPlaybackTelemetry(
      $grpc.ServiceCall call, $0.PlaybackTelemetryRequest request);

  $async.Future<$0.RecentlyPlayedResponse> getRecentlyPlayed_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RecentlyPlayedRequest> $request) async {
    return getRecentlyPlayed($call, await $request);
  }

  $async.Future<$0.RecentlyPlayedResponse> getRecentlyPlayed(
      $grpc.ServiceCall call, $0.RecentlyPlayedRequest request);

  $async.Future<$0.InteractionResponse> setTrackInteraction_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.InteractionRequest> $request) async {
    return setTrackInteraction($call, await $request);
  }

  $async.Future<$0.InteractionResponse> setTrackInteraction(
      $grpc.ServiceCall call, $0.InteractionRequest request);

  $async.Future<$0.PlaylistResponse> createPlaylist_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreatePlaylistRequest> $request) async {
    return createPlaylist($call, await $request);
  }

  $async.Future<$0.PlaylistResponse> createPlaylist(
      $grpc.ServiceCall call, $0.CreatePlaylistRequest request);

  $async.Future<$0.PlaylistActionResponse> addToPlaylist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PlaylistTrackRequest> $request) async {
    return addToPlaylist($call, await $request);
  }

  $async.Future<$0.PlaylistActionResponse> addToPlaylist(
      $grpc.ServiceCall call, $0.PlaylistTrackRequest request);

  $async.Future<$0.GetPlaylistResponse> getPlaylist_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPlaylistRequest> $request) async {
    return getPlaylist($call, await $request);
  }

  $async.Future<$0.GetPlaylistResponse> getPlaylist(
      $grpc.ServiceCall call, $0.GetPlaylistRequest request);

  $async.Future<$0.GetUserPlaylistsResponse> getUserPlaylists_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUserPlaylistsRequest> $request) async {
    return getUserPlaylists($call, await $request);
  }

  $async.Future<$0.GetUserPlaylistsResponse> getUserPlaylists(
      $grpc.ServiceCall call, $0.GetUserPlaylistsRequest request);

  $async.Future<$0.SeedTrackResponse> seedTrack_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SeedTrackRequest> $request) async {
    return seedTrack($call, await $request);
  }

  $async.Future<$0.SeedTrackResponse> seedTrack(
      $grpc.ServiceCall call, $0.SeedTrackRequest request);

  $async.Future<$0.ListTracksAdminResponse> listTracksAdmin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListTracksAdminRequest> $request) async {
    return listTracksAdmin($call, await $request);
  }

  $async.Future<$0.ListTracksAdminResponse> listTracksAdmin(
      $grpc.ServiceCall call, $0.ListTracksAdminRequest request);

  $async.Future<$0.TrackActionResponse> approveTrack_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TrackActionRequest> $request) async {
    return approveTrack($call, await $request);
  }

  $async.Future<$0.TrackActionResponse> approveTrack(
      $grpc.ServiceCall call, $0.TrackActionRequest request);

  $async.Future<$0.TrackActionResponse> rejectTrack_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TrackActionRequest> $request) async {
    return rejectTrack($call, await $request);
  }

  $async.Future<$0.TrackActionResponse> rejectTrack(
      $grpc.ServiceCall call, $0.TrackActionRequest request);

  $async.Future<$0.TrackActionResponse> featureTrack_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FeatureTrackRequest> $request) async {
    return featureTrack($call, await $request);
  }

  $async.Future<$0.TrackActionResponse> featureTrack(
      $grpc.ServiceCall call, $0.FeatureTrackRequest request);

  $async.Future<$0.TrackActionResponse> deleteTrack_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TrackActionRequest> $request) async {
    return deleteTrack($call, await $request);
  }

  $async.Future<$0.TrackActionResponse> deleteTrack(
      $grpc.ServiceCall call, $0.TrackActionRequest request);

  $async.Future<$0.AdminStatsResponse> getAdminStats_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getAdminStats($call, await $request);
  }

  $async.Future<$0.AdminStatsResponse> getAdminStats(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.GetLikedTracksResponse> getLikedTracks_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetLikedTracksRequest> $request) async {
    return getLikedTracks($call, await $request);
  }

  $async.Future<$0.GetLikedTracksResponse> getLikedTracks(
      $grpc.ServiceCall call, $0.GetLikedTracksRequest request);
}
