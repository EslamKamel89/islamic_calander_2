////
////  LockScreenWidget.swift
////  LockScreenWidget
////
////  Created by eslam kamel on 12/07/2025.
////
//
//import WidgetKit
//import SwiftUI
//
//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), emoji: "😀")
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), emoji: "😀")
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, emoji: "😀")
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//
////    func relevances() async -> WidgetRelevances<Void> {
////        // Generate a list containing the contexts this widget is relevant in.
////    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let emoji: String
//}
//
//struct LockScreenWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Islamic Calander: Lock Screen Widget")
////            Text(entry.date, style: .time)
////
////            Text("Emoji:")
////            Text(entry.emoji)
//        }
//    }
//}
//
//struct LockScreenWidget: Widget {
//    let kind: String = "LockScreenWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
//                LockScreenWidgetEntryView(entry: entry)
//                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                LockScreenWidgetEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//        .supportedFamilies([
//            .accessoryCircular,
//            .accessoryRectangular,
//            .accessoryInline
//        ])
//    }
//}
//
//#Preview(as: .systemSmall) {
//    LockScreenWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
//
//  LockScreenWidget.swift
//  LockScreenWidget
//
//  Minimal widget to display Fajr time from shared UserDefaults
//

//----------------------------------------------------------------------------------------------

// this is the i code i used for testing
//import WidgetKit
//import SwiftUI
//
//// MARK: - Model
//struct PrayerDay: Codable {
//    let date: String
//    let Fajr: String
//}
//
//// MARK: - Entry
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let fajrTime: String
//}
//
//// MARK: - Timeline Provider
//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), fajrTime: "04:00")
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = loadFajrEntry()
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        let entry = loadFajrEntry()
//        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
//        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
//        completion(timeline)
//    }
//
//    private func loadFajrEntry() -> SimpleEntry {
//        let defaultEntry = SimpleEntry(date: Date(), fajrTime: "No Data")
//
//        guard let userDefaults = UserDefaults(suiteName: "group.com.gaztec.lockwidget"),
//              let jsonString = userDefaults.string(forKey: "prayer_json"),
//              let data = jsonString.data(using: .utf8) else {
//            return defaultEntry
//        }
//
//        do {
//            let decoded = try JSONDecoder().decode([String: [PrayerDay]].self, from: data)
//            if let first = decoded["prayers"]?.first {
//                return SimpleEntry(date: Date(), fajrTime: first.Fajr.trimmingCharacters(in: .whitespaces))
//            } else {
//                return SimpleEntry(date: Date(), fajrTime: "No Prayers")
//            }
//        } catch {
//            return SimpleEntry(date: Date(), fajrTime: "Invalid JSON")
//        }
//    }
//}
//
//// MARK: - Widget View
//struct LockScreenWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Fajr")
//                .font(.caption)
//            Text(entry.fajrTime)
//                .font(.title3)
//                .bold()
//        }
//    }
//}
//
//// MARK: - Widget Configuration
//struct LockScreenWidget: Widget {
//    let kind: String = "LockScreenWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            if #available(iOS 17.0, *) {
//                LockScreenWidgetEntryView(entry: entry)
//                    .containerBackground(.fill.tertiary, for: .widget)
//            } else {
//                LockScreenWidgetEntryView(entry: entry)
//                    .padding()
//                    .background()
//            }
//        }
//        .configurationDisplayName("Prayer Preview")
//        .description("Shows today's Fajr time.")
//        .supportedFamilies([.accessoryRectangular])
//    }
//}
//
//// MARK: - Preview
//#Preview(as: .accessoryRectangular) {
//    LockScreenWidget()
//} timeline: {
//    SimpleEntry(date: .now, fajrTime: "04:10")
//}

//
//  LockScreenWidget.swift
//  LockScreenWidget
//
//  Displays the next prayer name and time remaining.

import WidgetKit
import SwiftUI

// MARK: - Model
struct PrayerDay: Codable {
    let date: String
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let prayerName: String
    let timeRemaining: String
    let warning: Bool
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), prayerName: "--", timeRemaining: "--", warning: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = buildEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let now = Date()
        let refreshRateMinutes = 2
        var entries: [SimpleEntry] = []

        // Build entries every 2 minutes for the next 5 hours (configurable)
        for offset in 0..<150 { // 150 x 2min = 5 hours
            let nextDate = Calendar.current.date(byAdding: .minute, value: offset * refreshRateMinutes, to: now)!
            let entry = buildEntry(at: nextDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func buildEntry(at refDate: Date = Date()) -> SimpleEntry {
        guard let userDefaults = UserDefaults(suiteName: "group.com.gaztec.lockwidget"),
              let jsonString = userDefaults.string(forKey: "prayer_json"),
              let data = jsonString.data(using: .utf8) else {
            return SimpleEntry(date: refDate, prayerName: "No Data", timeRemaining: "Open app", warning: true)
        }

        do {
            let decoded = try JSONDecoder().decode([String: [PrayerDay]].self, from: data)
            let prayers = decoded["prayers"] ?? []
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            formatter.locale = Locale(identifier: "en_US_POSIX")

            for day in prayers {
                let datePrefix = day.date
                for (name, time) in [
                    ("Fajr", day.Fajr),
                    ("Sunrise", day.Sunrise),
                    ("Dhuhr", day.Dhuhr),
                    ("Asr", day.Asr),
                    ("Maghrib", day.Maghrib),
                    ("Isha", day.Isha)
                ] {
                    let cleaned = time.trimmingCharacters(in: .whitespaces)
                    let combined = "\(datePrefix) \(cleaned)"
                    if let prayerDate = formatter.date(from: combined), prayerDate > refDate {
                        let remaining = Int(prayerDate.timeIntervalSince(refDate) / 60)
                        let formattedRemaining = "in \(remaining) min"
                        return SimpleEntry(date: refDate, prayerName: name, timeRemaining: formattedRemaining, warning: false)
                    }
                }
            }
            return SimpleEntry(date: refDate, prayerName: "Outdated", timeRemaining: "Open app", warning: true)
        } catch {
            return SimpleEntry(date: refDate, prayerName: "Invalid JSON", timeRemaining: "Fix data", warning: true)
        }
    }
}

// MARK: - Widget View
struct LockScreenWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if entry.warning {
            Text("🔄 Open app to refresh")
                .font(.caption2)
                .multilineTextAlignment(.center)
        } else {
            VStack(spacing: 2) {
                Text(entry.prayerName)
                    .font(.caption)
                    .bold()
                Text(entry.timeRemaining)
                    .font(.footnote)
            }
        }
    }
}

// MARK: - Widget Configuration
struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                LockScreenWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                LockScreenWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Next Prayer")
        .description("Shows next prayer and countdown")
        .supportedFamilies([.accessoryRectangular])
    }
}

// MARK: - Preview
#Preview(as: .accessoryRectangular) {
    LockScreenWidget()
} timeline: {
    SimpleEntry(date: .now, prayerName: "Asr", timeRemaining: "in 38 min", warning: false)
}
