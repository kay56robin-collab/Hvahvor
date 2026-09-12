import SwiftUI

extension Color {
    init(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        s.removeAll { $0 == "#" }
        var value: UInt64 = 0
        Scanner(string: s).scanHexInt64(&value)
        let r = Double((value >> 16) & 0xff) / 255
        let g = Double((value >> 8) & 0xff) / 255
        let b = Double(value & 0xff) / 255
        self.init(red: r, green: g, blue: b)
    }
}

/// Designtokens fra HvaHvor-spesifikasjonen (README.md i design-pakken).
enum HH {
    // MARK: Farger
    static let navyDark = Color(hex: "#0d2438")
    static let navyLight = Color(hex: "#20506e")
    static let gold = Color(hex: "#c8922f")
    static let goldLight = Color(hex: "#e0ac47")
    static let goldLightest = Color(hex: "#f0bf5e")
    static let textSecondary1 = Color(hex: "#9fb3c4")
    static let textSecondary2 = Color(hex: "#b9c9d6")
    static let textSecondary3 = Color(hex: "#dbe6ee")
    static let bodyCopy = Color(hex: "#e6edf2")

    static let surfaceFill = Color.white.opacity(0.06)
    static let surfaceBorder = Color.white.opacity(0.14)
    static let borderSubtle = Color.white.opacity(0.18)
    static let borderMedium = Color.white.opacity(0.22)
    static let borderStrong = Color.white.opacity(0.24)
    static let divider = Color.white.opacity(0.12)
    static let goldBorderFaint = goldLight.opacity(0.5)

    static let background = RadialGradient(
        colors: [navyLight, navyDark],
        center: .top,
        startRadius: 4,
        endRadius: 520
    )

    // Kosmetiske merke-farger for oppføringer ("Farge"-feltet). Første valg er "ingen farge".
    static let swatches: [String?] = [nil, "#e0793f", "#e0ac47", "#5fa878", "#4a90c4", "#9b7fc4"]

    // MARK: Typografi
    // Merriweather og Noto Sans er bundlet som variable fonter (Fonts/Merriweather.ttf,
    // Fonts/NotoSans.ttf) og registrert via Info.plist (UIAppFonts). De navngitte
    // instansene under dekker vektene spec'en bruker.
    static func heading(_ size: CGFloat, weight: Font.Weight = .black) -> Font {
        let name: String
        switch weight {
        case .black, .heavy: name = "Merriweather-Black"
        case .bold: name = "Merriweather-Bold"
        case .semibold: name = "Merriweather-SemiBold"
        case .medium: name = "Merriweather-Medium"
        default: name = "Merriweather-Regular"
        }
        return .custom(name, size: size)
    }

    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let name: String
        switch weight {
        case .black, .heavy, .bold: name = "NotoSans-Bold"
        case .semibold: name = "NotoSans-SemiBold"
        case .medium: name = "NotoSans-Medium"
        default: name = "NotoSans-Regular"
        }
        return .custom(name, size: size)
    }

    static func kicker(_ size: CGFloat = 11, weight: Font.Weight = .bold) -> Font {
        body(size, weight: weight)
    }
}

extension View {
    /// Store bokstaver + bred bokstavavstand, brukt på "kicker"-tekster i spec'en.
    func kickerStyle() -> some View {
        self.textCase(.uppercase).tracking(1.1)
    }
}
