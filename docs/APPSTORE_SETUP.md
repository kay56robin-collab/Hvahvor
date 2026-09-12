# Sette opp automatisk App Store-utsending

Denne workflowen (`.github/workflows/release.yml`) arkiverer, signerer og laster opp HvaHvor til App Store Connect automatisk — helt uten Mac. Den kjører kun når du trigger den manuelt (fanen **Actions → Release to App Store → Run workflow** på GitHub), aldri på vanlige pushes.

Alt under er ting **du** må gjøre (krever din Apple-konto/betaling). Følg rekkefølgen.

## 1. Meld deg inn i Apple Developer Program

[developer.apple.com/programs](https://developer.apple.com/programs/) — $99/år. Etter innmelding, finn din **Team ID** (10 tegn, under Membership-detaljer). Noter den.

## 2. Registrer App ID

[developer.apple.com/account/resources/identifiers](https://developer.apple.com/account/resources/identifiers/list) → **+** → App IDs → App → Bundle ID: `no.hoff.HvaHvor` (Explicit, ikke wildcard).

## 3. Last opp sertifikatforespørselen (CSR)

Jeg har allerede generert en privatnøkkel + CSR lokalt (ingen Mac trengtes). Filene ligger her på maskinen:

- `distribution.csr` — sendes til deg som fil, last opp til Apple i steget under
- `distribution.key` — **privatnøkkelen. Ikke del denne, ikke last den opp noe sted.** Den trengs igjen i steg 5.

Gå til [developer.apple.com/account/resources/certificates](https://developer.apple.com/account/resources/certificates/list) → **+** → **Apple Distribution** → last opp `distribution.csr` → last ned det ferdige sertifikatet som `distribution.cer`.

## 4. Opprett provisioning-profil

[developer.apple.com/account/resources/profiles](https://developer.apple.com/account/resources/profiles/list) → **+** → **App Store Connect** (distribution) → velg App ID fra steg 2 → velg sertifikatet fra steg 3 → **gi profilen et navn du husker** (f.eks. `HvaHvor App Store`) → last ned `.mobileprovision`-filen.

## 5. Pakk sertifikat + nøkkel til .p12

Send meg `distribution.cer`-filen du lastet ned (si ifra når du har den), så pakker jeg den sammen med privatnøkkelen til en `.p12`-fil og en tilfeldig passordfrase for deg — det siste steget som trenger begge halvdelene sammen.

## 6. Opprett App Store Connect API-nøkkel

[appstoreconnect.apple.com](https://appstoreconnect.apple.com) → **Users and Access** → **Integrations** → **App Store Connect API** → **+** → rolle **App Manager** → last ned `.p8`-filen (**kun mulig én gang** — ta vare på den). Noter **Key ID** og **Issuer ID** som vises på siden.

## 7. Opprett app-oppføringen i App Store Connect

**My Apps** → **+** → New App → Bundle ID: `no.hoff.HvaHvor`, navn: `HvaHvor`, SKU: valgfri (f.eks. `hvahvor-001`).

## 8. Legg til GitHub-hemmeligheter

Repo → **Settings → Secrets and variables → Actions → New repository secret**. Legg til disse åtte (jeg hjelper deg regne ut/kode de fleste når du har filene fra Apple):

| Navn | Verdi |
|---|---|
| `BUILD_CERTIFICATE_BASE64` | base64 av `.p12`-filen (steg 5) |
| `P12_PASSWORD` | passordet til `.p12`-filen (steg 5) |
| `BUILD_PROVISION_PROFILE_BASE64` | base64 av `.mobileprovision`-filen (steg 4) |
| `KEYCHAIN_PASSWORD` | et hvilket som helst nytt, tilfeldig passord (kun brukt internt i CI) |
| `APPLE_TEAM_ID` | Team ID fra steg 1 |
| `PROVISIONING_PROFILE_NAME` | navnet du ga profilen i steg 4 |
| `APPSTORE_API_KEY_BASE64` | base64 av `.p8`-filen (steg 6) |
| `APPSTORE_API_KEY_ID` | Key ID fra steg 6 |
| `APPSTORE_API_ISSUER_ID` | Issuer ID fra steg 6 |

## 9. Kjør releasen

**Actions**-fanen → **Release to App Store** (venstre meny) → **Run workflow**. Etter noen minutter dukker builden opp under **TestFlight** i App Store Connect, klar til intern testing eller innsending til gjennomgang.

## Ekte skjermbilder til butikk-oppføringen

Apple krever skjermbilder fra en faktisk kjørende build (README-bildene er fra design-prototypen). Enkleste vei: last builden fra TestFlight på en iPhone via TestFlight-appen, ta skjermbilder derfra.

---

**Hva jeg kan hjelpe med herfra:** pakke `.p12` når du har `distribution.cer` (steg 5), base64-kode filene dine når du har dem, feilsøke workflow-loggen hvis noe feiler. **Det jeg ikke kan gjøre:** opprette Apple-kontoen, betale $99-avgiften, eller klikke "Submit for Review" — det er kontoen din og siste ord er ditt.
