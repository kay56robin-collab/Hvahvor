import Foundation
import SwiftData

/// Én oppføring i registeret: hva som er hvor.
@Model
final class Entry {
    var sted: String
    var plassering: String
    var type: String
    var info: String
    var kommentar: String
    /// Hex-streng ("#rrggbb") eller nil for ingen farge.
    var farge: String?
    var sistEndret: Date
    /// JPEG-data for et valgfritt bilde, lagret utenfor selve databasefilen.
    @Attribute(.externalStorage) var bilde: Data?

    init(
        sted: String = "",
        plassering: String = "",
        type: String = "",
        info: String = "",
        kommentar: String = "",
        farge: String? = nil,
        sistEndret: Date = .now,
        bilde: Data? = nil
    ) {
        self.sted = sted
        self.plassering = plassering
        self.type = type
        self.info = info
        self.kommentar = kommentar
        self.farge = farge
        self.sistEndret = sistEndret
        self.bilde = bilde
    }
}
