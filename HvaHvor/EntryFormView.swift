import SwiftUI
import SwiftData

struct EntryFormView: View {
    var entry: Entry?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var sted: String = ""
    @State private var plassering: String = ""
    @State private var type: String = ""
    @State private var info: String = ""
    @State private var kommentar: String = ""
    @State private var farge: String?

    private var isValid: Bool {
        !sted.trimmingCharacters(in: .whitespaces).isEmpty &&
        !type.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                HH.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        field("Sted", text: $sted)
                        field("Plassering", text: $plassering)
                        field("Type", text: $type)
                        field("Info", text: $info)
                        textAreaField("Kommentar", text: $kommentar)
                        colorField
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Avbryt") { dismiss() }
                        .font(HH.body(14))
                        .foregroundStyle(HH.textSecondary1)
                }
                ToolbarItem(placement: .principal) {
                    Text(entry == nil ? "Ny oppføring" : "Rediger oppføring")
                        .font(HH.kicker(11))
                        .tracking(1.1)
                        .foregroundStyle(HH.textSecondary1)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Lagre") { save() }
                        .font(HH.body(14, weight: .bold))
                        .foregroundStyle(isValid ? HH.goldLight : HH.goldLight.opacity(0.35))
                        .disabled(!isValid)
                }
            }
            .toolbarBackground(HH.navyDark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear(perform: loadDraft)
    }

    private func loadDraft() {
        guard let entry else { return }
        sted = entry.sted
        plassering = entry.plassering
        type = entry.type
        info = entry.info
        kommentar = entry.kommentar
        farge = entry.farge
    }

    private func save() {
        if let entry {
            entry.sted = sted
            entry.plassering = plassering
            entry.type = type
            entry.info = info
            entry.kommentar = kommentar
            entry.farge = farge
            entry.sistEndret = .now
        } else {
            let newEntry = Entry(
                sted: sted,
                plassering: plassering,
                type: type,
                info: info,
                kommentar: kommentar,
                farge: farge,
                sistEndret: .now
            )
            modelContext.insert(newEntry)
        }
        dismiss()
    }

    @ViewBuilder
    private func field(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(HH.body(12, weight: .semibold))
                .foregroundStyle(HH.textSecondary1)
            TextField("", text: text)
                .font(HH.body(15))
                .foregroundStyle(.white)
                .tint(HH.goldLight)
                .padding(.horizontal, 16)
                .frame(minHeight: 48)
                .background(RoundedRectangle(cornerRadius: 14).fill(HH.surfaceFill))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(HH.borderSubtle, lineWidth: 1))
        }
    }

    @ViewBuilder
    private func textAreaField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(HH.body(12, weight: .semibold))
                .foregroundStyle(HH.textSecondary1)
            TextEditor(text: text)
                .font(HH.body(15))
                .foregroundStyle(.white)
                .scrollContentBackground(.hidden)
                .padding(10)
                .frame(minHeight: 90)
                .background(RoundedRectangle(cornerRadius: 14).fill(HH.surfaceFill))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(HH.borderSubtle, lineWidth: 1))
        }
    }

    private var colorField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Farge")
                .font(HH.body(12, weight: .semibold))
                .foregroundStyle(HH.textSecondary1)
            HStack(spacing: 12) {
                ForEach(HH.swatches, id: \.self) { swatch in
                    Button {
                        farge = swatch
                    } label: {
                        ColorDot(hex: swatch, size: 32)
                            .overlay(
                                Circle()
                                    .stroke(HH.goldLight, lineWidth: farge == swatch ? 2 : 0)
                                    .padding(-3)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    EntryFormView(entry: nil)
        .modelContainer(for: Entry.self, inMemory: true)
}
