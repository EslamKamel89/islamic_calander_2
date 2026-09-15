import Foundation

struct ScheduledPrayer {
    let name: String
    let date: Date
}

struct WidgetPrayerDay {
    let date: Date
    let times: [String: Date]
}

struct PrayerSchedule {
    static let names = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"]
    let days: [WidgetPrayerDay]
    let calendar: Calendar

    init(json: String?, calendar: Calendar = Calendar(identifier: .gregorian)) {
        self.calendar = calendar
        guard let data = json?.data(using: .utf8),
              let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              object["version"] as? Int == 1,
              let records = object["prayers"] as? [[String: Any]] else {
            days = []
            return
        }
        var parsed: [Date: WidgetPrayerDay] = [:]
        for record in records {
            guard let text = record["date"] as? String,
                  let day = Self.parse(date: text, time: "00:00", calendar: calendar) else { continue }
            var times: [String: Date] = [:]
            for name in Self.names {
                if let time = record[name] as? String,
                   let date = Self.parse(date: text, time: time, calendar: calendar) {
                    times[name] = date
                }
            }
            parsed[day] = WidgetPrayerDay(date: day, times: times)
        }
        days = parsed.values.sorted { $0.date < $1.date }
    }

    static func parse(date: String, time: String, calendar: Calendar) -> Date? {
        let clean = time.trimmingCharacters(in: .whitespacesAndNewlines)
        guard date.range(of: #"^\d{2}-\d{2}-\d{4}$"#, options: .regularExpression) != nil,
              clean.range(of: #"^\d{1,2}:\d{2}(?:\s+\([^)]*\))?$"#, options: .regularExpression) != nil else { return nil }
        let d = date.split(separator: "-").compactMap { Int($0) }
        let t = clean.split(whereSeparator: { $0.isWhitespace })[0].split(separator: ":").compactMap { Int($0) }
        guard d.count == 3, t.count == 2, t[0] < 24, t[1] < 60 else { return nil }
        let components = DateComponents(year: d[2], month: d[1], day: d[0], hour: t[0], minute: t[1], second: 0)
        guard let result = calendar.date(from: components) else { return nil }
        let actual = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: result)
        guard actual.year == d[2], actual.month == d[1], actual.day == d[0],
              actual.hour == t[0], actual.minute == t[1] else { return nil }
        return result
    }

    var events: [ScheduledPrayer] {
        days.flatMap { day in
            Self.names.filter { $0 != "Sunrise" }.compactMap { name in
                day.times[name].map { ScheduledPrayer(name: name, date: $0) }
            }
        }.sorted { $0.date < $1.date }
    }

    func next(at date: Date) -> ScheduledPrayer? { events.first { $0.date > date } }
    func day(at date: Date) -> WidgetPrayerDay? {
        days.first { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func timelineDates(now: Date) -> [Date] {
        var dates = Set([now])
        for event in events where event.date > now { dates.insert(event.date) }
        if let last = days.last,
           let end = calendar.date(byAdding: .day, value: 1, to: last.date) {
            var midnight = calendar.startOfDay(for: now)
            while let next = calendar.date(byAdding: .day, value: 1, to: midnight), next <= end {
                dates.insert(next)
                midnight = next
            }
        }
        return dates.sorted()
    }
}
