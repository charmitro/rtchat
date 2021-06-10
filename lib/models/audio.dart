import 'dart:async';
import 'dart:core';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioSource {
  final String? name;
  final Uri url;
  final bool muted;

  AudioSource(this.name, this.url, this.muted);

  AudioSource withMuted(bool muted) => AudioSource(name, url, muted);

  bool operator ==(that) => that is AudioSource && that.url == this.url;

  int get hashCode => url.hashCode;

  AudioSource.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = Uri.parse(json['url']),
        muted = json['muted'];

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url.toString(),
        "muted": muted,
      };

  @override
  String toString() => url.toString();
}

class AudioModel extends ChangeNotifier {
  List<AudioSource> _sources = [];
  Timer? _speakerDisconnectTimer;
  bool _isAutoMuteEnabled = true;
  final AudioCache _audioCache = AudioCache();

  bool get isSpeakerDisconnectPreventionEnabled {
    return _speakerDisconnectTimer != null;
  }

  set isSpeakerDisconnectPreventionEnabled(bool isEnabled) {
    if (isEnabled) {
      _startSpeakerDisconnectTimer();
    } else {
      _speakerDisconnectTimer?.cancel();
      _speakerDisconnectTimer = null;
    }
    notifyListeners();
  }

  void _startSpeakerDisconnectTimer() {
    _speakerDisconnectTimer = Timer.periodic(
      Duration(minutes: 5),
      (_) => _audioCache.play("silence.mp3"),
    );
  }

  bool get isAutoMuteEnabled {
    return _isAutoMuteEnabled;
  }

  set isAutoMuteEnabled(bool isEnabled) {
    _isAutoMuteEnabled = isEnabled;
    notifyListeners();
  }

  List<AudioSource> get sources {
    return _sources;
  }

  void addSource(AudioSource source) {
    _sources.add(source);
    notifyListeners();
  }

  void removeSource(AudioSource source) {
    _sources.remove(source);
    notifyListeners();
  }

  void toggleSource(AudioSource source) {
    final index = _sources.indexOf(source);
    if (index != -1) {
      _sources[index] = source.withMuted(!source.muted);
    }
    notifyListeners();
  }

  AudioModel.fromJson(Map<String, dynamic> json) {
    final sources = json['sources'];
    if (sources != null) {
      for (dynamic source in sources) {
        _sources.add(AudioSource.fromJson(source));
      }
    }
    if (json['isAutoMuteEnabled'] != null) {
      _isAutoMuteEnabled = json['isAutoMuteEnabled'];
    }
    if (json['isSpeakerDisconnectPreventionEnabled'] ?? false) {
      _startSpeakerDisconnectTimer();
    }
  }

  Map<String, dynamic> toJson() => {
        "sources": _sources.map((source) => source.toJson()).toList(),
        "isAutoMuteEnabled": _isAutoMuteEnabled,
        "isSpeakerDisconnectPreventionEnabled": _speakerDisconnectTimer != null,
      };
}
