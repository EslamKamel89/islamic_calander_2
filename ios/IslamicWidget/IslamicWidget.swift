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
        let placeholderJSON = "00:00,00:00,00:00,00:00,00:00,00:00"
        return SimpleEntry(
            date: Date(),
            data: placeholderJSON ,
            greogrianDate : "" ,
            currentHijri :"" ,
            newHijri: ""
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
          let userDefaults = UserDefaults(suiteName: "group.islamicwidget")
          let data = userDefaults?.string(forKey: "data") ?? ""
          let gerogrianDate = userDefaults?.string(forKey: "gerogrianDate") ?? ""
          let currentHijri = userDefaults?.string(forKey: "currentHijri") ?? ""
          let newHijri = userDefaults?.string(forKey: "newHijri") ?? ""
        let entry = SimpleEntry(date: Date(), data: data , greogrianDate: gerogrianDate , currentHijri: currentHijri , newHijri: newHijri) ;
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
    let greogrianDate:String
    let currentHijri : String
    let newHijri : String
}

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

struct IslamicWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
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
                let columns = [GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible())]
                VStack(spacing:4){
                    HStack(spacing: 5) {
                       Text("Today: ")
                           .font(.subheadline)
//                           .foregroundColor(.gray)
                           .minimumScaleFactor(0.8)
                       Text(entry.greogrianDate)
                           .font(.caption2)
//                           .foregroundColor(.gray)
                           .minimumScaleFactor(0.8)
                   }
                                   // Hijri section
                    HStack(spacing: 5) {
                        Text("Current Hijri: ")
                            .font(.subheadline)
 //                           .foregroundColor(.gray)
                            .minimumScaleFactor(0.8)
                        Text(entry.currentHijri)
                            .font(.caption2)
 //                           .foregroundColor(.gray)
                            .minimumScaleFactor(0.8)
                    }
                   HStack(spacing: 5) {
                       Text("Real Hijri: ")
                           .font(.subheadline)
//                           .foregroundColor(.gray)
                           .minimumScaleFactor(0.8)
                       Text(entry.newHijri)
                           .font(.caption2)
//                           .foregroundColor(.gray)
                           .minimumScaleFactor(0.8)
                   }
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(prayers) { prayer in
                            PrayerView(
                                prayer: prayer,
                                
                                imageSize: CGSize(width: 50, height: 40)
                            )
                        }
                    }
                    .padding()
                }
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
        .configurationDisplayName("Prayer Times")
        .description("Displays Islamic prayer times with a modern, responsive design.")
    }
}

struct Prayer: Decodable, Identifiable {
    // Conform to Identifiable to use ForEach directly.
    var id = UUID()
    let prayerName: String
    let prayerTime: String
    let prayerImg: String
}
func convertToTimeList(timeString: String) -> [String] {
    return timeString.components(separatedBy: ",")
}
