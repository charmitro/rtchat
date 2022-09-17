import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rtchat/components/chat_history/twitch/message.dart';
import 'package:rtchat/components/style_model_theme.dart';
import 'package:rtchat/models/messages/twitch/emote.dart';
import 'package:rtchat/models/messages/twitch/message.dart';
import 'package:rtchat/models/messages/twitch/message_configuration.dart';
import 'package:rtchat/models/messages/twitch/user.dart';
import 'package:rtchat/models/style.dart';

final message1 = TwitchMessageModel(
    messageId: "placeholder1",
    author: const TwitchUserModel(userId: 'muxfd', login: 'muxfd'),
    tags: {
      "color": "#800000",
      "badges-raw": "premium/1",
      "emotes-raw": "25:36-40",
      "room-id": "158394109",
    },
    annotations: const TwitchMessageAnnotationsModel(
        isAction: false, isFirstTimeChatter: false, announcement: null),
    thirdPartyEmotes: [],
    timestamp: DateTime.now(),
    message: "have you followed @muxfd on twitch? Kappa",
    deleted: false,
    channelId: 'placeholder');
final message2 = TwitchMessageModel(
    messageId: "placeholder2",
    author: const TwitchUserModel(userId: 'muxfd', login: 'muxfd'),
    tags: {
      "color": "#DAA520",
      "badges-raw": "moderator/1",
      "room-id": "158394109",
    },
    annotations: const TwitchMessageAnnotationsModel(
        isAction: true, isFirstTimeChatter: false, announcement: null),
    thirdPartyEmotes: [],
    timestamp: DateTime.now(),
    message: "likes cows and stuff",
    deleted: true,
    channelId: 'placeholder');
final message3 = TwitchMessageModel(
    messageId: "placeholder3",
    author: const TwitchUserModel(userId: 'muxfd', login: 'muxfd'),
    tags: {
      "color": "#00FF7F",
      "badges-raw": "broadcaster/1,moderator/1",
      "room-id": "158394109",
    },
    annotations: const TwitchMessageAnnotationsModel(
        isAction: false, isFirstTimeChatter: false, announcement: null),
    thirdPartyEmotes: [
      Emote(
        provider: "twitch",
        category: null,
        id: 'catJAM',
        code: 'catJAM',
        imageUrl: 'https://cdn.betterttv.net/emote/5f1abd75fe85fb4472d132b4/1x',
      ),
    ],
    timestamp: DateTime.now(),
    message: "catJAM catJAM catJAM catJAM catJAM catJAM",
    deleted: false,
    channelId: 'placeholder');
final message4 = TwitchMessageModel(
    messageId: "placeholder4",
    author: const TwitchUserModel(userId: 'muxfd', login: 'muxfd'),
    tags: {
      "color": "#00FF7F",
      "badges-raw": "broadcaster/1,moderator/1",
      "room-id": "158394109",
    },
    annotations: const TwitchMessageAnnotationsModel(
        isAction: false, isFirstTimeChatter: false, announcement: null),
    thirdPartyEmotes: [],
    timestamp: DateTime.now(),
    message: "hoy es dia de lavanderia",
    deleted: false,
    channelId: 'placeholder');

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat history")),
      body: Consumer<StyleModel>(builder: (context, model, child) {
        final settings = ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Font size",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      )),
                  Slider.adaptive(
                    value: model.fontSize,
                    min: 12,
                    max: 36,
                    divisions: 12,
                    label: "${model.fontSize}px",
                    onChanged: (value) {
                      model.fontSize = value;
                    },
                  ),
                  Text("Username contrast boost",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      )),
                  Slider.adaptive(
                    value: model.lightnessBoost,
                    min: 0.179,
                    max: 1.0,
                    label: "${model.lightnessBoost}",
                    onChanged: (value) {
                      model.lightnessBoost = value;
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Twitch badge settings'),
              subtitle: const Text("Control which badges are visible"),
              onTap: () {
                Navigator.pushNamed(context, "/settings/badges");
              },
            ),
            SwitchListTile.adaptive(
              title: const Text('Show deleted messages'),
              subtitle: model.isDeletedMessagesVisible
                  ? const Text("Deleted messages will be greyed out")
                  : const Text("Deleted messages will be removed"),
              value: model.isDeletedMessagesVisible,
              onChanged: (value) {
                model.isDeletedMessagesVisible = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Compact messages",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            RadioListTile(
              title: const Text('Don\'t compact messages'),
              subtitle: const Text("Messages are shown unchanged"),
              value: CompactMessages.none,
              groupValue: model.compactMessages,
              onChanged: (CompactMessages? value) {
                if (value != null) {
                  model.compactMessages = value;
                }
              },
            ),
            RadioListTile(
              title: const Text('Compact individual messages'),
              subtitle: const Text("Repetitive text in messages is shortened"),
              value: CompactMessages.withinMessage,
              groupValue: model.compactMessages,
              onChanged: (CompactMessages? value) {
                if (value != null) {
                  model.compactMessages = value;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Automatic translation",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            ListTile(
              title: const Text('Language'),
              subtitle: const Text("Translate messages to this language"),
              trailing: DropdownButton<String>(
                value: model.translateLanguage,
                onChanged: (String? value) {
                  if (value != null) {
                    model.translateLanguage = value;
                  }
                },
                items: ["EN", "ES", "DE", "JA", "ZH"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            RadioListTile(
              title: const Text('Don\'t translate messages'),
              value: TranslateMessages.none,
              groupValue: model.translateMessages,
              onChanged: (TranslateMessages? value) {
                if (value != null) {
                  model.translateMessages = value;
                }
              },
            ),
            RadioListTile(
              title: const Text('Show translation under messages'),
              value: TranslateMessages.translateAndShowOriginal,
              groupValue: model.translateMessages,
              onChanged: (TranslateMessages? value) {
                if (value != null) {
                  model.translateMessages = value;
                }
              },
            ),
            Consumer<TwitchMessageConfig>(builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Announcement pin duration",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        )),
                    Slider.adaptive(
                      value: model.announcementPinDuration.inSeconds.toDouble(),
                      min: 0,
                      max: 30,
                      divisions: 15,
                      label:
                          "${model.announcementPinDuration.inSeconds.toDouble()} seconds",
                      onChanged: (value) {
                        model.setAnnouncementPinDuration(
                            Duration(seconds: value.toInt()));
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        );
        return Column(
          children: [
            SizedBox(
              height: 180,
              child: StyleModelTheme(
                  child: ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                    TwitchMessageWidget(message1),
                    TwitchMessageWidget(message2),
                    TwitchMessageWidget(message3),
                    TwitchMessageWidget(message4),
                  ])),
            ),
            Expanded(child: settings)
          ],
        );
      }),
    );
  }
}
