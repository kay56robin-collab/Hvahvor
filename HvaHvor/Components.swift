import SwiftUI

/// Enkel flerlinjet "flow"-layout, brukt til stedsfilter-chipsene som skal
/// bryte til nye rader i stedet for å scrolle horisontalt.
struct WrapLayout: Layout {
    var horizontalSpacing: CGFloat = 8
    var verticalSpacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var rowWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        var rowHeight: CGFloat = 0
        var isFirstInRow = true

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if !isFirstInRow, rowWidth + horizontalSpacing + size.width > maxWidth {
                totalHeight += rowHeight + verticalSpacing
                rowWidth = 0
                rowHeight = 0
                isFirstInRow = true
            }
            rowWidth += (isFirstInRow ? 0 : horizontalSpacing) + size.width
            rowHeight = max(rowHeight, size.height)
            isFirstInRow = false
        }
        totalHeight += rowHeight
        return CGSize(width: maxWidth.isFinite ? maxWidth : rowWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0
        var isFirstInRow = true

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if !isFirstInRow, x + size.width > bounds.minX + maxWidth {
                y += rowHeight + verticalSpacing
                x = bounds.minX
                rowHeight = 0
                isFirstInRow = true
            }
            subview.place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: ProposedViewSize(size))
            x += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
            isFirstInRow = false
        }
    }
}

struct FilterChip: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(HH.body(13, weight: .semibold))
                .foregroundStyle(isActive ? HH.navyDark : HH.textSecondary3)
                .padding(.horizontal, 15)
                .frame(minHeight: 36)
                .background(
                    Capsule().fill(isActive ? HH.gold : Color.clear)
                )
                .overlay(
                    Capsule().stroke(isActive ? Color.clear : HH.borderMedium, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

struct ColorDot: View {
    let hex: String?
    var size: CGFloat = 10

    var body: some View {
        Circle()
            .fill(hex.map { Color(hex: $0) } ?? Color.clear)
            .overlay(Circle().stroke(HH.borderMedium, lineWidth: hex == nil ? 1 : 0))
            .frame(width: size, height: size)
    }
}

struct EntryCard: View {
    let entry: Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text("\(entry.sted) · \(entry.plassering)")
                    .font(HH.kicker(10))
                    .kickerStyle()
                    .foregroundStyle(HH.goldLight)
                    .lineLimit(1)
                Rectangle().fill(HH.divider).frame(height: 1)
                ColorDot(hex: entry.farge)
            }
            Text(entry.type)
                .font(HH.heading(18, weight: .bold))
                .foregroundStyle(.white)
            if !entry.info.isEmpty {
                Text(entry.info)
                    .font(HH.body(15, weight: .semibold))
                    .foregroundStyle(HH.goldLightest)
            }
            if !entry.kommentar.isEmpty {
                Text(entry.kommentar)
                    .font(HH.body(13))
                    .foregroundStyle(HH.textSecondary2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(HH.surfaceFill))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(HH.surfaceBorder, lineWidth: 1))
    }
}

struct FirstRunEmptyState: View {
    var onAdd: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle().stroke(HH.goldLight, lineWidth: 2).frame(width: 56, height: 56)
                Text("?")
                    .font(HH.heading(26, weight: .black))
                    .foregroundStyle(HH.goldLight)
            }
            VStack(spacing: 8) {
                Text("Registeret er tomt")
                    .font(HH.heading(21, weight: .black))
                    .foregroundStyle(.white)
                Text("Legg til hva som er hvor — maling, verktøy, deler. Neste gang du lurer, søk her først.")
                    .font(HH.body(14))
                    .foregroundStyle(HH.textSecondary2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 220)
            }
            Button(action: onAdd) {
                Text("+ Legg til første oppføring")
                    .font(HH.body(14, weight: .bold))
                    .foregroundStyle(HH.navyDark)
                    .padding(.horizontal, 20)
                    .frame(minHeight: 48)
                    .background(Capsule().fill(HH.gold))
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 60)
        .frame(maxWidth: .infinity)
    }
}

struct NoResultsState: View {
    var body: some View {
        Text("Ingen treff. Prøv et annet ord.")
            .font(HH.heading(18, weight: .bold))
            .foregroundStyle(HH.textSecondary1)
            .multilineTextAlignment(.center)
            .padding(.top, 60)
            .frame(maxWidth: .infinity)
    }
}
