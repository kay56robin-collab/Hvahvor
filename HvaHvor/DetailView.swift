import SwiftUI
import SwiftData
import UIKit

struct DetailView: View {
    @Bindable var entry: Entry

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showingEdit = false
    @State private var showingDeleteConfirm = false

    var body: some View {
        ZStack {
            HH.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        titleBlock

                        if let bilde = entry.bilde, let uiImage = UIImage(data: bilde) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .clipped()
                        }

                        Rectangle().fill(HH.divider).frame(height: 1)

                        stedPlasseringGrid

                        if !entry.kommentar.isEmpty {
                            Rectangle().fill(HH.divider).frame(height: 1)
                            kommentarBlock
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 22)
                    .padding(.bottom, 24)
                }

                actionBar
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showingEdit) {
            EntryFormView(entry: entry)
        }
        .alert("Slette denne oppføringen?", isPresented: $showingDeleteConfirm) {
            Button("Avbryt", role: .cancel) {}
            Button("Slett", role: .destructive) {
                modelContext.delete(entry)
                dismiss()
            }
        } message: {
            Text("Dette kan ikke angres.")
        }
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("OPPFØRING")
                        .font(HH.kicker(11))
                        .tracking(1.1)
                }
                .foregroundStyle(HH.textSecondary1)
            }
            .buttonStyle(.plain)

            Spacer()

            Button("Rediger") {
                showingEdit = true
            }
            .font(HH.body(14, weight: .bold))
            .foregroundStyle(HH.goldLight)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle().fill(HH.divider).frame(height: 1)
        }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                ColorDot(hex: entry.farge, size: 14)
                Text("\(entry.sted) · \(entry.plassering)")
                    .font(HH.kicker(11))
                    .tracking(1.1)
                    .foregroundStyle(HH.goldLight)
            }
            Text(entry.type)
                .font(HH.heading(28, weight: .black))
                .foregroundStyle(.white)
            if !entry.info.isEmpty {
                Text(entry.info)
                    .font(HH.body(17, weight: .semibold))
                    .foregroundStyle(HH.goldLightest)
            }
        }
    }

    private var stedPlasseringGrid: some View {
        HStack(alignment: .top, spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text("STED")
                    .font(HH.kicker(10))
                    .tracking(1.1)
                    .foregroundStyle(HH.textSecondary1)
                Text(entry.sted)
                    .font(HH.body(15))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text("PLASSERING")
                    .font(HH.kicker(10))
                    .tracking(1.1)
                    .foregroundStyle(HH.textSecondary1)
                Text(entry.plassering)
                    .font(HH.body(15))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var kommentarBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("KOMMENTAR")
                .font(HH.kicker(10))
                .tracking(1.1)
                .foregroundStyle(HH.textSecondary1)
            Text(entry.kommentar)
                .font(HH.body(15))
                .lineSpacing(6)
                .foregroundStyle(HH.bodyCopy)
        }
    }

    private var actionBar: some View {
        HStack(spacing: 12) {
            Button {
                showingEdit = true
            } label: {
                Text("Rediger")
                    .font(HH.body(14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .overlay(Capsule().stroke(HH.borderStrong, lineWidth: 1))
            }
            .buttonStyle(.plain)

            Button {
                showingDeleteConfirm = true
            } label: {
                Text("Slett")
                    .font(HH.body(14, weight: .bold))
                    .foregroundStyle(HH.goldLight)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .overlay(Capsule().stroke(HH.goldBorderFaint, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
    }
}
