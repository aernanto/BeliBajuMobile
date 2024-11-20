// To parse this JSON data, do
//
//     final moodEntry = moodEntryFromJson(jsonString);

import 'dart:convert';

List<MoodEntry> moodEntryFromJson(String str) => List<MoodEntry>.from(json.decode(str).map((x) => MoodEntry.fromJson(x)));

String moodEntryToJson(List<MoodEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MoodEntry {
    String model;
    String pk;
    Fields fields;

    MoodEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String mood;
    DateTime time;
    String feelings;
    int moodIntensity;

    Fields({
        required this.user,
        required this.mood,
        required this.time,
        required this.feelings,
        required this.moodIntensity,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        mood: json["mood"],
        time: DateTime.parse(json["time"]),
        feelings: json["feelings"],
        moodIntensity: json["mood_intensity"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "mood": mood,
        "time": "${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}",
        "feelings": feelings,
        "mood_intensity": moodIntensity,
    };
}