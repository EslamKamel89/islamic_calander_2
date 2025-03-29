//? original code without any change
//
//  IslamicWidget.swift
//  IslamicWidget
//
//  Created by eslam kamel on 29/03/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct IslamicWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Emoji:")
            Text(entry.emoji)
        }
    }
}

struct IslamicWidget: Widget {
    let kind: String = "IslamicWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                IslamicWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                IslamicWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
   IslamicWidget()
} timeline: {
   SimpleEntry(date: .now, emoji: "😀")
   SimpleEntry(date: .now, emoji: "🤩")
}
//!----------------------------------------------------------------------------
//!----------------------------------------------------------------------------
//!----------------------------------------------------------------------------

//? verson one
import WidgetKit
import SwiftUI

// MARK: - Prayer Model and JSON Parsing

struct Prayer: Decodable, Identifiable {
    // Conform to Identifiable to use ForEach directly.
    var id = UUID()
    let prayerName: String
    let prayerTime: String
    let prayerImg: String
}

func parsePrayers(from jsonString: String) -> [Prayer]? {
    guard
        let jsonData = jsonString.data(using: .utf8)
    else {
        print("Failed to convert string to Data")
        return nil
    }
    do {
        let prayers = try JSONDecoder().decode([Prayer].self, from: jsonData)
        return prayers
    } catch {
        print("Failed to decode JSON: \(error.localizedDescription)")
        return nil
    }
}
// MARK: - Data Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        // Provide a simple placeholder JSON string
        let placeholderJSON = "00:00,00:00,00:00,00:00,00:00,00:00"
        return SimpleEntry(date: Date(), data: placeholderJSON  )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.gaztec4widget")
        let data = userDefaults?.string(forKey: "data") ?? ""
        let entry = SimpleEntry(date: Date(), data: data)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { entry in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: String
}

// MARK: - Reusable PrayerView

struct PrayerView: View {
    let prayer: Prayer
    let imageSize: CGSize
    
    var body: some View {
        VStack(spacing: 5) {
            Text(prayer.prayerName)
                .font(.system(size: imageSize.height * 0.3, weight: .semibold))
//                .foregroundColor(.black)
            
            Image(prayer.prayerImg)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize.width, height: imageSize.height)
                .clipped()
                .cornerRadius(8)
            
            Text(prayer.prayerTime)
                .font(.system(size: imageSize.height * 0.25))
                .multilineTextAlignment(.center)
//                .foregroundColor(.black)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

// MARK: - Main Widget View

struct HomeWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    // Decode the JSON string from entry.data into an array of Prayer objects.
    // If decoding fails, use a fallback default array.
    var prayers: [Prayer] {
//        parsePrayers(from: entry.data) ??
        [
            Prayer(
                prayerName: "Fajr",
                prayerTime: convertToTimeList(timeString: entry.data)[0],
                prayerImg: "fajr"
            ),
            Prayer(prayerName: "Sunrise", prayerTime: convertToTimeList(timeString: entry.data)[1], prayerImg: "three"),
            Prayer(
                prayerName: "Dhuhr",
                prayerTime: convertToTimeList(timeString: entry.data)[2],
                prayerImg: "two"
            ),
            Prayer(prayerName: "Asr", prayerTime: convertToTimeList(timeString: entry.data)[3], prayerImg: "one"),
            Prayer(prayerName: "Maghrib", prayerTime: convertToTimeList(timeString: entry.data)[4], prayerImg: "four"),
            Prayer(prayerName: "Isha", prayerTime:convertToTimeList(timeString: entry.data)[5], prayerImg: "five")
        ]
    }
    
    var body: some View {
        ZStack {
            // Background with a generic subtle gradient
//            Text(convertToTimeList(timeString:  entry.data)[0])
//            Text(entry.dhuhr)
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.green.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
//             Layout based on widget family
            switch family {
            case .systemSmall, .systemMedium:
                // For small and medium sizes, wrap the HStack in a ScrollView for pagination.
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(prayers) { prayer in
                            PrayerView(
                                prayer: prayer,
                                imageSize: family == .systemSmall ?
                                    CGSize(width: 40, height: 50) : CGSize(width: 50, height: 60)
                            )
                        }
                    }
                    .padding()
                }
            case .systemLarge:
                // For large size, display all prayers in a grid layout.
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(prayers) { prayer in
                        PrayerView(
                            prayer: prayer,
                            imageSize: CGSize(width: 50, height: 45)
                        )
                    }
                }
                .padding()
            default:
                // Fallback: a horizontal scroll view.
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(prayers) { prayer in
                            PrayerView(
                                prayer: prayer,
                                imageSize: CGSize(width: 40, height: 40)
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// MARK: - Widget Declaration

struct HomeWidget: Widget {
    let kind: String = "HomeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HomeWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HomeWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Prayer Times")
        .description("Displays Islamic prayer times with a modern, responsive design.")
    }
}
func convertToTimeList(timeString: String) -> [String] {
    return timeString.components(separatedBy: ",")
}
//!----------------------------------------------------------------------------
//!----------------------------------------------------------------------------
//!----------------------------------------------------------------------------