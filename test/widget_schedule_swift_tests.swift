import Foundation

@main
struct ScheduleTests {
    static func main() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let json = try String(contentsOfFile: "test/fixtures/widget_schedule.json", encoding: .utf8)
        let schedule = PrayerSchedule(json: json, calendar: calendar)
        func date(_ day: String, _ time: String) -> Date {
            PrayerSchedule.parse(date: day, time: time, calendar: calendar)!
        }
        assert(schedule.next(at: date("31-12-2026", "04:00"))?.name == "Fajr")
        assert(schedule.next(at: date("31-12-2026", "05:00"))?.name == "Dhuhr")
        assert(schedule.next(at: date("31-12-2026", "19:00"))?.date == date("01-01-2027", "05:01"))
        assert(schedule.next(at: date("01-01-2027", "19:01")) == nil)
        assert(schedule.day(at: date("01-01-2027", "00:00"))?.times["Sunrise"] == date("01-01-2027", "06:31"))
        assert(schedule.day(at: date("02-01-2027", "00:00")) == nil)
        let dates = schedule.timelineDates(now: date("31-12-2026", "04:00"))
        assert(dates.contains(date("01-01-2027", "00:00")))
        assert(dates.contains(date("01-01-2027", "19:01")))
        assert(!dates.contains(date("31-12-2026", "06:30")))
        assert(dates == Array(Set(dates)).sorted())
        assert(PrayerSchedule(json: nil).days.isEmpty)
        assert(PrayerSchedule(json: "bad").days.isEmpty)
        assert(PrayerSchedule(json: json.replacingOccurrences(of: "\"version\":1", with: "\"version\":2")).days.isEmpty)
        assert(PrayerSchedule.parse(date: "31-02-2026", time: "05:00", calendar: calendar) == nil)
        assert(PrayerSchedule.parse(date: "01-01-2027", time: "24:00", calendar: calendar) == nil)
        assert(PrayerSchedule.parse(date: "01-01-2027", time: "12:60", calendar: calendar) == nil)
        assert(PrayerSchedule.parse(date: "01-01-2027", time: "05:01 (EET)", calendar: calendar) == date("01-01-2027", "05:01"))
        let partial = PrayerSchedule(json: json.replacingOccurrences(of: "\"Fajr\":\"05:00\"", with: "\"Fajr\":\"bad\""), calendar: calendar)
        assert(partial.next(at: date("31-12-2026", "04:00"))?.name == "Dhuhr")
        print("Swift prayer schedule checks passed")
    }
}
