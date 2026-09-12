import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Entry.sistEndret, order: .reverse) private var entries: [Entry]

    @State private var searchText = ""
    @State private var selectedPlace: String?
    @State private var showingNewEntry = false

    private var places: [String] {
        let unique = Set(entries.map(\.sted)).filter { !$0.isEmpty }
        return unique.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    private var filtered: [Entry] {
        entries.filter { entry in
            let matchesPlace = selectedPlace == nil || entry.sted == selectedPlace
            guard matchesPlace else { return false }
            guard !searchText.isEmpty else { return true }
            return [entry.sted, entry.plassering, entry.type, entry.info, entry.kommentar]
                .contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    private var resultCountLabel: String {
        let n = filtered.count
        return n == 1 ? "1 OPPFØRING" : "\(n) OPPFØRINGER"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                HH.background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    titleBlock

                    if entries.isEmpty {
                        FirstRunEmptyState { showingNewEntry = true }
                        Spacer()
                    } else {
                        searchField
                            .padding(.top, 20)
                        chips
                            .padding(.top, 14)
                        newEntryButton
                            .padding(.top, 14)
                        resultRow
                            .padding(.top, 20)

                        if filtered.isEmpty {
                            NoResultsState()
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(filtered) { entry in
                                        NavigationLink(value: entry) {
                                            EntryCard(entry: entry)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.top, 14)
                                .padding(.bottom, 24)
                            }
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 12)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Entry.self) { entry in
                DetailView(entry: entry)
            }
            .sheet(isPresented: $showingNewEntry) {
                EntryFormView(entry: nil)
            }
        }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("HVAHVOR")
                .font(HH.kicker(11))
                .kickerStyle()
                .foregroundStyle(HH.goldLight)
            Text("Hva finner jeg hvor")
                .font(HH.heading(30, weight: .black))
                .lineSpacing(2)
                .foregroundStyle(.white)
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17))
                .foregroundStyle(HH.textSecondary1)
            TextField("", text: $searchText, prompt: Text("Søk: beis, sikringsskap, Torx…").foregroundStyle(HH.textSecondary1))
                .foregroundStyle(.white)
                .tint(HH.goldLight)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14))
                        .foregroundStyle(HH.textSecondary1)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 18)
        .frame(minHeight: 50)
        .background(Capsule().fill(HH.surfaceFill))
        .overlay(Capsule().stroke(HH.borderSubtle, lineWidth: 1))
    }

    private var chips: some View {
        WrapLayout(horizontalSpacing: 8, verticalSpacing: 8) {
            FilterChip(title: "Alle", isActive: selectedPlace == nil) {
                selectedPlace = nil
            }
            ForEach(places, id: \.self) { place in
                FilterChip(title: place, isActive: selectedPlace == place) {
                    selectedPlace = place
                }
            }
        }
    }

    private var newEntryButton: some View {
        Button {
            showingNewEntry = true
        } label: {
            Text("+ Ny oppføring")
                .font(HH.body(14, weight: .bold))
                .foregroundStyle(HH.navyDark)
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Capsule().fill(HH.gold))
        }
        .buttonStyle(.plain)
    }

    private var resultRow: some View {
        VStack(spacing: 10) {
            Rectangle().fill(HH.divider).frame(height: 1)
            HStack {
                Text(resultCountLabel)
                    .font(HH.kicker(11))
                    .tracking(1.1)
                    .foregroundStyle(HH.textSecondary1)
                Spacer()
                Text("Sist endret ↓")
                    .font(HH.body(11))
                    .foregroundStyle(HH.textSecondary1)
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Entry.self, inMemory: true)
}
