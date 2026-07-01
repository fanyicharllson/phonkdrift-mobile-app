// This is a generated file - do not edit.
//
// Generated from track.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor =
    $convert.base64Decode('CgVFbXB0eQ==');

@$core.Deprecated('Use trackMetadataDescriptor instead')
const TrackMetadata$json = {
  '1': 'TrackMetadata',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'artist_id', '3': 3, '4': 1, '5': 9, '10': 'artistId'},
    {'1': 'artist_name', '3': 4, '4': 1, '5': 9, '10': 'artistName'},
    {'1': 'duration', '3': 5, '4': 1, '5': 9, '10': 'duration'},
    {'1': 'thumbnail_url', '3': 6, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    {
      '1': 'original_youtube_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'originalYoutubeId'
    },
    {'1': 'play_count', '3': 8, '4': 1, '5': 5, '10': 'playCount'},
    {'1': 'likes_count', '3': 9, '4': 1, '5': 5, '10': 'likesCount'},
    {'1': 'storage_url', '3': 10, '4': 1, '5': 9, '10': 'storageUrl'},
    {'1': 'genre', '3': 11, '4': 1, '5': 9, '10': 'genre'},
    {'1': 'is_featured', '3': 12, '4': 1, '5': 8, '10': 'isFeatured'},
    {'1': 'is_approved', '3': 13, '4': 1, '5': 8, '10': 'isApproved'},
    {'1': 'source', '3': 14, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `TrackMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackMetadataDescriptor = $convert.base64Decode(
    'Cg1UcmFja01ldGFkYXRhEhkKCHRyYWNrX2lkGAEgASgJUgd0cmFja0lkEhQKBXRpdGxlGAIgAS'
    'gJUgV0aXRsZRIbCglhcnRpc3RfaWQYAyABKAlSCGFydGlzdElkEh8KC2FydGlzdF9uYW1lGAQg'
    'ASgJUgphcnRpc3ROYW1lEhoKCGR1cmF0aW9uGAUgASgJUghkdXJhdGlvbhIjCg10aHVtYm5haW'
    'xfdXJsGAYgASgJUgx0aHVtYm5haWxVcmwSLgoTb3JpZ2luYWxfeW91dHViZV9pZBgHIAEoCVIR'
    'b3JpZ2luYWxZb3V0dWJlSWQSHQoKcGxheV9jb3VudBgIIAEoBVIJcGxheUNvdW50Eh8KC2xpa2'
    'VzX2NvdW50GAkgASgFUgpsaWtlc0NvdW50Eh8KC3N0b3JhZ2VfdXJsGAogASgJUgpzdG9yYWdl'
    'VXJsEhQKBWdlbnJlGAsgASgJUgVnZW5yZRIfCgtpc19mZWF0dXJlZBgMIAEoCFIKaXNGZWF0dX'
    'JlZBIfCgtpc19hcHByb3ZlZBgNIAEoCFIKaXNBcHByb3ZlZBIWCgZzb3VyY2UYDiABKAlSBnNv'
    'dXJjZQ==');

@$core.Deprecated('Use searchRequestDescriptor instead')
const SearchRequest$json = {
  '1': 'SearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
  ],
};

/// Descriptor for `SearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchRequestDescriptor = $convert.base64Decode(
    'Cg1TZWFyY2hSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRISCgRwYWdlGAIgASgFUgRwYW'
    'dl');

@$core.Deprecated('Use searchResponseDescriptor instead')
const SearchResponse$json = {
  '1': 'SearchResponse',
  '2': [
    {
      '1': 'tracks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.track.TrackMetadata',
      '10': 'tracks'
    },
  ],
};

/// Descriptor for `SearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResponseDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hSZXNwb25zZRIsCgZ0cmFja3MYASADKAsyFC50cmFjay5UcmFja01ldGFkYXRhUg'
    'Z0cmFja3M=');

@$core.Deprecated('Use streamRequestDescriptor instead')
const StreamRequest$json = {
  '1': 'StreamRequest',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
    {
      '1': 'original_youtube_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'originalYoutubeId'
    },
  ],
};

/// Descriptor for `StreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamRequestDescriptor = $convert.base64Decode(
    'Cg1TdHJlYW1SZXF1ZXN0EhkKCHRyYWNrX2lkGAEgASgJUgd0cmFja0lkEi4KE29yaWdpbmFsX3'
    'lvdXR1YmVfaWQYAiABKAlSEW9yaWdpbmFsWW91dHViZUlk');

@$core.Deprecated('Use streamResponseDescriptor instead')
const StreamResponse$json = {
  '1': 'StreamResponse',
  '2': [
    {'1': 'stream_url', '3': 1, '4': 1, '5': 9, '10': 'streamUrl'},
    {'1': 'link_expires_at', '3': 2, '4': 1, '5': 3, '10': 'linkExpiresAt'},
  ],
};

/// Descriptor for `StreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamResponseDescriptor = $convert.base64Decode(
    'Cg5TdHJlYW1SZXNwb25zZRIdCgpzdHJlYW1fdXJsGAEgASgJUglzdHJlYW1VcmwSJgoPbGlua1'
    '9leHBpcmVzX2F0GAIgASgDUg1saW5rRXhwaXJlc0F0');

@$core.Deprecated('Use trendingRequestDescriptor instead')
const TrendingRequest$json = {
  '1': 'TrendingRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `TrendingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendingRequestDescriptor = $convert
    .base64Decode('Cg9UcmVuZGluZ1JlcXVlc3QSFAoFbGltaXQYASABKAVSBWxpbWl0');

@$core.Deprecated('Use trendingResponseDescriptor instead')
const TrendingResponse$json = {
  '1': 'TrendingResponse',
  '2': [
    {
      '1': 'tracks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.track.TrackMetadata',
      '10': 'tracks'
    },
  ],
};

/// Descriptor for `TrendingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendingResponseDescriptor = $convert.base64Decode(
    'ChBUcmVuZGluZ1Jlc3BvbnNlEiwKBnRyYWNrcxgBIAMoCzIULnRyYWNrLlRyYWNrTWV0YWRhdG'
    'FSBnRyYWNrcw==');

@$core.Deprecated('Use playbackTelemetryRequestDescriptor instead')
const PlaybackTelemetryRequest$json = {
  '1': 'PlaybackTelemetryRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'track_id', '3': 2, '4': 1, '5': 9, '10': 'trackId'},
    {
      '1': 'last_position_seconds',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'lastPositionSeconds'
    },
    {'1': 'is_completed', '3': 4, '4': 1, '5': 8, '10': 'isCompleted'},
  ],
};

/// Descriptor for `PlaybackTelemetryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackTelemetryRequestDescriptor = $convert.base64Decode(
    'ChhQbGF5YmFja1RlbGVtZXRyeVJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhkKCH'
    'RyYWNrX2lkGAIgASgJUgd0cmFja0lkEjIKFWxhc3RfcG9zaXRpb25fc2Vjb25kcxgDIAEoBVIT'
    'bGFzdFBvc2l0aW9uU2Vjb25kcxIhCgxpc19jb21wbGV0ZWQYBCABKAhSC2lzQ29tcGxldGVk');

@$core.Deprecated('Use playbackTelemetryResponseDescriptor instead')
const PlaybackTelemetryResponse$json = {
  '1': 'PlaybackTelemetryResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `PlaybackTelemetryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackTelemetryResponseDescriptor =
    $convert.base64Decode(
        'ChlQbGF5YmFja1RlbGVtZXRyeVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use recentlyPlayedRequestDescriptor instead')
const RecentlyPlayedRequest$json = {
  '1': 'RecentlyPlayedRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `RecentlyPlayedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recentlyPlayedRequestDescriptor = $convert.base64Decode(
    'ChVSZWNlbnRseVBsYXllZFJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhQKBWxpbW'
    'l0GAIgASgFUgVsaW1pdA==');

@$core.Deprecated('Use recentlyPlayedResponseDescriptor instead')
const RecentlyPlayedResponse$json = {
  '1': 'RecentlyPlayedResponse',
  '2': [
    {
      '1': 'tracks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.track.TrackMetadata',
      '10': 'tracks'
    },
  ],
};

/// Descriptor for `RecentlyPlayedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recentlyPlayedResponseDescriptor =
    $convert.base64Decode(
        'ChZSZWNlbnRseVBsYXllZFJlc3BvbnNlEiwKBnRyYWNrcxgBIAMoCzIULnRyYWNrLlRyYWNrTW'
        'V0YWRhdGFSBnRyYWNrcw==');

@$core.Deprecated('Use interactionRequestDescriptor instead')
const InteractionRequest$json = {
  '1': 'InteractionRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'track_id', '3': 2, '4': 1, '5': 9, '10': 'trackId'},
    {'1': 'is_liked', '3': 3, '4': 1, '5': 8, '10': 'isLiked'},
  ],
};

/// Descriptor for `InteractionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interactionRequestDescriptor = $convert.base64Decode(
    'ChJJbnRlcmFjdGlvblJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhkKCHRyYWNrX2'
    'lkGAIgASgJUgd0cmFja0lkEhkKCGlzX2xpa2VkGAMgASgIUgdpc0xpa2Vk');

@$core.Deprecated('Use interactionResponseDescriptor instead')
const InteractionResponse$json = {
  '1': 'InteractionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `InteractionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interactionResponseDescriptor =
    $convert.base64Decode(
        'ChNJbnRlcmFjdGlvblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use createPlaylistRequestDescriptor instead')
const CreatePlaylistRequest$json = {
  '1': 'CreatePlaylistRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'cover_image_url', '3': 3, '4': 1, '5': 9, '10': 'coverImageUrl'},
  ],
};

/// Descriptor for `CreatePlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPlaylistRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVQbGF5bGlzdFJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhIKBG5hbW'
    'UYAiABKAlSBG5hbWUSJgoPY292ZXJfaW1hZ2VfdXJsGAMgASgJUg1jb3ZlckltYWdlVXJs');

@$core.Deprecated('Use playlistResponseDescriptor instead')
const PlaylistResponse$json = {
  '1': 'PlaylistResponse',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '10': 'playlistId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `PlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistResponseDescriptor = $convert.base64Decode(
    'ChBQbGF5bGlzdFJlc3BvbnNlEh8KC3BsYXlsaXN0X2lkGAEgASgJUgpwbGF5bGlzdElkEhIKBG'
    '5hbWUYAiABKAlSBG5hbWUSFwoHdXNlcl9pZBgDIAEoCVIGdXNlcklk');

@$core.Deprecated('Use playlistTrackRequestDescriptor instead')
const PlaylistTrackRequest$json = {
  '1': 'PlaylistTrackRequest',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '10': 'playlistId'},
    {'1': 'track_id', '3': 2, '4': 1, '5': 9, '10': 'trackId'},
  ],
};

/// Descriptor for `PlaylistTrackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistTrackRequestDescriptor = $convert.base64Decode(
    'ChRQbGF5bGlzdFRyYWNrUmVxdWVzdBIfCgtwbGF5bGlzdF9pZBgBIAEoCVIKcGxheWxpc3RJZB'
    'IZCgh0cmFja19pZBgCIAEoCVIHdHJhY2tJZA==');

@$core.Deprecated('Use playlistActionResponseDescriptor instead')
const PlaylistActionResponse$json = {
  '1': 'PlaylistActionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `PlaylistActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistActionResponseDescriptor =
    $convert.base64Decode(
        'ChZQbGF5bGlzdEFjdGlvblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbW'
        'Vzc2FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use forYouRequestDescriptor instead')
const ForYouRequest$json = {
  '1': 'ForYouRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ForYouRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forYouRequestDescriptor = $convert.base64Decode(
    'Cg1Gb3JZb3VSZXF1ZXN0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIUCgVsaW1pdBgCIAEoBV'
    'IFbGltaXQ=');

@$core.Deprecated('Use forYouResponseDescriptor instead')
const ForYouResponse$json = {
  '1': 'ForYouResponse',
  '2': [
    {
      '1': 'tracks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.track.TrackMetadata',
      '10': 'tracks'
    },
  ],
};

/// Descriptor for `ForYouResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forYouResponseDescriptor = $convert.base64Decode(
    'Cg5Gb3JZb3VSZXNwb25zZRIsCgZ0cmFja3MYASADKAsyFC50cmFjay5UcmFja01ldGFkYXRhUg'
    'Z0cmFja3M=');

@$core.Deprecated('Use seedTrackRequestDescriptor instead')
const SeedTrackRequest$json = {
  '1': 'SeedTrackRequest',
  '2': [
    {'1': 'youtube_id', '3': 1, '4': 1, '5': 9, '10': 'youtubeId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'artist_name', '3': 3, '4': 1, '5': 9, '10': 'artistName'},
    {'1': 'genre', '3': 4, '4': 1, '5': 9, '10': 'genre'},
    {'1': 'thumbnail_url', '3': 5, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    {'1': 'storage_url', '3': 6, '4': 1, '5': 9, '10': 'storageUrl'},
  ],
};

/// Descriptor for `SeedTrackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedTrackRequestDescriptor = $convert.base64Decode(
    'ChBTZWVkVHJhY2tSZXF1ZXN0Eh0KCnlvdXR1YmVfaWQYASABKAlSCXlvdXR1YmVJZBIUCgV0aX'
    'RsZRgCIAEoCVIFdGl0bGUSHwoLYXJ0aXN0X25hbWUYAyABKAlSCmFydGlzdE5hbWUSFAoFZ2Vu'
    'cmUYBCABKAlSBWdlbnJlEiMKDXRodW1ibmFpbF91cmwYBSABKAlSDHRodW1ibmFpbFVybBIfCg'
    'tzdG9yYWdlX3VybBgGIAEoCVIKc3RvcmFnZVVybA==');

@$core.Deprecated('Use seedTrackResponseDescriptor instead')
const SeedTrackResponse$json = {
  '1': 'SeedTrackResponse',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
    {'1': 'storage_url', '3': 2, '4': 1, '5': 9, '10': 'storageUrl'},
  ],
};

/// Descriptor for `SeedTrackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedTrackResponseDescriptor = $convert.base64Decode(
    'ChFTZWVkVHJhY2tSZXNwb25zZRIZCgh0cmFja19pZBgBIAEoCVIHdHJhY2tJZBIfCgtzdG9yYW'
    'dlX3VybBgCIAEoCVIKc3RvcmFnZVVybA==');

@$core.Deprecated('Use listTracksAdminRequestDescriptor instead')
const ListTracksAdminRequest$json = {
  '1': 'ListTracksAdminRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListTracksAdminRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTracksAdminRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0VHJhY2tzQWRtaW5SZXF1ZXN0EhIKBHBhZ2UYASABKAVSBHBhZ2USFAoFbGltaXQYAi'
        'ABKAVSBWxpbWl0');

@$core.Deprecated('Use listTracksAdminResponseDescriptor instead')
const ListTracksAdminResponse$json = {
  '1': 'ListTracksAdminResponse',
  '2': [
    {
      '1': 'tracks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.track.TrackMetadata',
      '10': 'tracks'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListTracksAdminResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTracksAdminResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0VHJhY2tzQWRtaW5SZXNwb25zZRIsCgZ0cmFja3MYASADKAsyFC50cmFjay5UcmFja0'
        '1ldGFkYXRhUgZ0cmFja3MSFAoFdG90YWwYAiABKAVSBXRvdGFs');

@$core.Deprecated('Use trackActionRequestDescriptor instead')
const TrackActionRequest$json = {
  '1': 'TrackActionRequest',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
  ],
};

/// Descriptor for `TrackActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackActionRequestDescriptor =
    $convert.base64Decode(
        'ChJUcmFja0FjdGlvblJlcXVlc3QSGQoIdHJhY2tfaWQYASABKAlSB3RyYWNrSWQ=');

@$core.Deprecated('Use trackActionResponseDescriptor instead')
const TrackActionResponse$json = {
  '1': 'TrackActionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `TrackActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackActionResponseDescriptor = $convert.base64Decode(
    'ChNUcmFja0FjdGlvblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2'
    'FnZRgCIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use featureTrackRequestDescriptor instead')
const FeatureTrackRequest$json = {
  '1': 'FeatureTrackRequest',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
    {'1': 'is_featured', '3': 2, '4': 1, '5': 8, '10': 'isFeatured'},
  ],
};

/// Descriptor for `FeatureTrackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureTrackRequestDescriptor = $convert.base64Decode(
    'ChNGZWF0dXJlVHJhY2tSZXF1ZXN0EhkKCHRyYWNrX2lkGAEgASgJUgd0cmFja0lkEh8KC2lzX2'
    'ZlYXR1cmVkGAIgASgIUgppc0ZlYXR1cmVk');

@$core.Deprecated('Use adminStatsResponseDescriptor instead')
const AdminStatsResponse$json = {
  '1': 'AdminStatsResponse',
  '2': [
    {'1': 'total_tracks', '3': 1, '4': 1, '5': 5, '10': 'totalTracks'},
    {'1': 'total_plays', '3': 2, '4': 1, '5': 5, '10': 'totalPlays'},
    {'1': 'pending_tracks', '3': 3, '4': 1, '5': 5, '10': 'pendingTracks'},
    {'1': 'total_users', '3': 4, '4': 1, '5': 5, '10': 'totalUsers'},
  ],
};

/// Descriptor for `AdminStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adminStatsResponseDescriptor = $convert.base64Decode(
    'ChJBZG1pblN0YXRzUmVzcG9uc2USIQoMdG90YWxfdHJhY2tzGAEgASgFUgt0b3RhbFRyYWNrcx'
    'IfCgt0b3RhbF9wbGF5cxgCIAEoBVIKdG90YWxQbGF5cxIlCg5wZW5kaW5nX3RyYWNrcxgDIAEo'
    'BVINcGVuZGluZ1RyYWNrcxIfCgt0b3RhbF91c2VycxgEIAEoBVIKdG90YWxVc2Vycw==');
