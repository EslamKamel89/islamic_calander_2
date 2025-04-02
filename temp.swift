struct HomeWidgetView: View {
    let entry: HomeEntry   // Contains your date strings (e.g. greogrianDate, currentHijri, newHijri)
    let prayers: [Prayer]  // Your list of prayer models

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 4) {
                // Header section with date information
                VStack(spacing: 2) {
                    Text("Today")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.8)
                    Text(entry.greogrianDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.8)
                }
                // Hijri section
                VStack(spacing: 2) {
                    Text("Current Hijri")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.8)
                    Text(entry.currentHijri)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.8)
                }
                VStack(spacing: 2) {
                    Text("Real Hijri")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.8)
                    Text(entry.newHijri)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.8)
                }
                // Prayer grid section with two columns
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 8
                ) {
                    ForEach(prayers) { prayer in
                        PrayerView(
                            prayer: prayer,
                            imageSize: CGSize(width: geometry.size.width * 0.2, height: geometry.size.width * 0.18)
                        )
                    }
                }
                .padding([.leading, .trailing, .bottom], 4)
            }
            .padding(4)
        }
    }
}
