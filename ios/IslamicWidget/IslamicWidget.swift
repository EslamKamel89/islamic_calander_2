//
//  IslamicWidget.swift
//  IslamicWidget
//
//  Created by eslam kamel on 29/03/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private func entry(at date: Date, schedule: PrayerSchedule, defaults: UserDefaults?) -> SimpleEntry {
        let next = schedule.next(at: date)
        return SimpleEntry(date: date, times: schedule.day(at: date)?.times ?? [:],
            greogrianDate: defaults?.string(forKey: "gerogrianDate") ?? "",
            currentHijri: defaults?.string(forKey: "currentHijri") ?? "",
            newHijri: defaults?.string(forKey: "newHijri") ?? "",
            nextPrayer: next?.name ?? "Open app to refresh", nextPrayerTime: next?.date)
    }

    func placeholder(in context: Context) -> SimpleEntry {
        entry(at: Date(), schedule: PrayerSchedule(json: nil), defaults: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let defaults = UserDefaults(suiteName: "group.islamicwidget")
        let schedule = PrayerSchedule(json: defaults?.string(forKey: "prayer_schedule"))
        completion(entry(at: Date(), schedule: schedule, defaults: defaults))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let defaults = UserDefaults(suiteName: "group.islamicwidget")
        let schedule = PrayerSchedule(json: defaults?.string(forKey: "prayer_schedule"))
        let entries = schedule.timelineDates(now: Date()).map {
            entry(at: $0, schedule: schedule, defaults: defaults)
        }
        completion(Timeline(entries: entries, policy: .never))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let times: [String: Date]
    let greogrianDate: String
    let currentHijri: String
    let newHijri: String
    let nextPrayer: String
    let nextPrayerTime: Date?
}

struct PrayerCountdown: View {
    let entry: SimpleEntry
    var body: some View {
        if let target = entry.nextPrayerTime, target > entry.date {
            Text(timerInterval: entry.date...target, countsDown: true)
                .monospacedDigit()
        } else {
            Text("--:--")
        }
    }
}

private let widgetGradient = LinearGradient(
    colors: [.black, .blue],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

struct PrayerView: View {
    let prayer: Prayer
    let size: CGSize

    var body: some View {
        VStack(spacing: size.height * 0.055) {
            Text(prayer.prayerName)
                .font(.system(size: min(size.height * 0.20, size.width * 0.20), weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Image(prayer.prayerImg)
                .resizable()
                .scaledToFit()
                .frame(width: size.width * 0.60, height: size.height * 0.40)
                .cornerRadius(size.height * 0.06)

            Text(prayer.prayerTime)
                .font(.system(size: min(size.height * 0.19, size.width * 0.18), weight: .semibold))
                .monospacedDigit()
                .foregroundColor(.white.opacity(0.90))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(width: size.width, height: size.height)
    }
}

struct IslamicWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var prayers: [Prayer] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm a"
        let images = ["fajr", "three", "two", "one", "four", "five"]
        return zip(PrayerSchedule.names, images).map { name, image in
            Prayer(prayerName: name,
                prayerTime: entry.times[name].map { formatter.string(from: $0) } ?? "--",
                prayerImg: image)
        }
    }

    private func countdown(fontSize: CGFloat) -> some View {
        PrayerCountdown(entry: entry)
            .font(.system(size: fontSize, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.65)
    }

    private func nextPrayerDetails(size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Next Prayer")
                .font(.system(size: min(size.height * 0.15, size.width * 0.14), weight: .medium))
                .foregroundColor(.white.opacity(0.85))
            Spacer(minLength: 0)
            Text(entry.nextPrayer)
                .font(.system(size: min(size.height * 0.28, size.width * 0.25), weight: .bold))
                .foregroundColor(.cyan)
                .lineLimit(entry.nextPrayerTime == nil ? 2 : 1)
                .minimumScaleFactor(0.65)
            Spacer(minLength: 0)
            countdown(fontSize: min(size.height * 0.29, size.width * 0.215))
        }
        .frame(width: size.width, height: size.height, alignment: .leading)
    }

    private func largeHeader(size: CGSize) -> some View {
        let gap = size.width * 0.04
        let columnWidth = (size.width - gap) / 2
        return HStack(alignment: .center, spacing: gap) {
            VStack(alignment: .leading, spacing: size.height * 0.10) {
                Text("Next Prayer")
                    .font(.system(size: size.height * 0.22, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                Text(entry.nextPrayer)
                    .font(.system(size: size.height * 0.43, weight: .bold))
                    .foregroundColor(.cyan)
                    .lineLimit(entry.nextPrayerTime == nil ? 2 : 1)
                    .minimumScaleFactor(0.6)
            }
            .frame(width: columnWidth, alignment: .leading)

            VStack(alignment: .leading, spacing: size.height * 0.10) {
                Text("Time remaining")
                    .font(.system(size: size.height * 0.20, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                countdown(fontSize: min(size.height * 0.43, columnWidth * 0.23))
            }
            .frame(width: columnWidth, alignment: .leading)
        }
        .frame(height: size.height)
    }

    var body: some View {
        GeometryReader { geometry in
            // Inset content only; the widget's gradient still fills the entire container.
            let insetRatio: CGFloat = family == .systemSmall ? 0.11 : (family == .systemLarge ? 0.05 : 0.075)
            let inset = min(geometry.size.width, geometry.size.height) * insetRatio
            let width = max(1, geometry.size.width - inset * 2)
            let height = max(1, geometry.size.height - inset * 2)

            Group {
                switch family {
                case .systemSmall:
                    nextPrayerDetails(size: CGSize(width: width, height: height))
                case .systemLarge:
                    let gap = height * 0.035
                    let headerHeight = height * 0.29
                    let rowGap = height * 0.04
                    let columnGap = width * 0.035
                    let cellSize = CGSize(
                        width: (width - columnGap * 2) / 3,
                        height: (height - headerHeight - gap * 2 - 1 - rowGap) / 2
                    )
                    VStack(spacing: gap) {
                        largeHeader(size: CGSize(width: width, height: headerHeight))
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(height: 1)
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.fixed(cellSize.width), spacing: columnGap), count: 3),
                            spacing: rowGap
                        ) {
                            ForEach(prayers) { prayer in
                                PrayerView(prayer: prayer, size: cellSize)
                            }
                        }
                    }
                default:
                    let iconSize = min(height * 0.55, width * 0.23)
                    let gap = width * 0.06
                    HStack(spacing: gap) {
                        Image(systemName: "sun.max.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(.yellow)
                        nextPrayerDetails(size: CGSize(width: width - iconSize - gap, height: height))
                    }
                }
            }
            .frame(width: width, height: height)
            .padding(inset)
        }
    }
}

struct IslamicWidget: Widget {
    let kind: String = "IslamicWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            IslamicWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    widgetGradient
                }
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .configurationDisplayName("Prayer Times")
        .description("Displays Islamic prayer times with a modern, responsive design.")
    }
}

struct Prayer: Identifiable {
    var id: String { prayerName }
    let prayerName: String
    let prayerTime: String
    let prayerImg: String
}
