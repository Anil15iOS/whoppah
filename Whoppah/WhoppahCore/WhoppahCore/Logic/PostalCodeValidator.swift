// Copyright 2019 Mattt (https://mat.tt)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

/// A validator for postal codes.
public final class PostalCodeValidator {
    /**
     * A set of available region codes.
     *
     * Each element of the returned set is an two-letter
     * ISO 3166-2 region code
     * (for example, "US" for the United States of America).
     */
    public class var isoRegionCodes: Set<String> {
        Set(patternsByRegion.keys)
    }

    // swiftlint:disable line_length
    private static let patternsByRegion: [String: String] = [
        "AC": #"ASCN 1ZZ"#,
        "AD": #"AD[1-7]0\d"#,
        "AE": #"AD[1-7]0\d"#,
        "AF": #"\d{4}"#,
        "AG": #"\d{4}"#,
        "AI": #"(?:AI-)?2640"#,
        "AL": #"\d{4}"#,
        "AM": #"(?:37)?\d{4}"#,
        "AO": #"(?:37)?\d{4}"#,
        "AQ": #"(?:37)?\d{4}"#,
        "AR": #"((?:[A-HJ-NP-Z])?\d{4})([A-Z]{3})?"#,
        "AS": #"(96799)(?:[ \-](\d{4}))?"#,
        "AT": #"\d{4}"#,
        "AU": #"\d{4}"#,
        "AW": #"\d{4}"#,
        "AX": #"22\d{3}"#,
        "AZ": #"\d{4}"#,
        "BA": #"\d{5}"#,
        "BB": #"BB\d{5}"#,
        "BD": #"\d{4}"#,
        "BE": #"\d{4}"#,
        "BF": #"\d{4}"#,
        "BG": #"\d{4}"#,
        "BH": #"(?:\d|1[0-2])\d{2}"#,
        "BI": #"(?:\d|1[0-2])\d{2}"#,
        "BJ": #"(?:\d|1[0-2])\d{2}"#,
        "BL": #"9[78][01]\d{2}"#,
        "BM": #"[A-Z]{2} ?[A-Z0-9]{2}"#,
        "BN": #"[A-Z]{2} ?\d{4}"#,
        "BO": #"[A-Z]{2} ?\d{4}"#,
        "BQ": #"[A-Z]{2} ?\d{4}"#,
        "BR": #"\d{5}-?\d{3}"#,
        "BS": #"\d{5}-?\d{3}"#,
        "BT": #"\d{5}"#,
        "BV": #"\d{5}"#,
        "BW": #"\d{5}"#,
        "BY": #"\d{6}"#,
        "BZ": #"\d{6}"#,
        "CA": #"[ABCEGHJKLMNPRSTVXY]\d[ABCEGHJ-NPRSTV-Z] ?\d[ABCEGHJ-NPRSTV-Z]\d"#,
        "CC": #"6799"#,
        "CD": #"6799"#,
        "CF": #"6799"#,
        "CG": #"6799"#,
        "CH": #"\d{4}"#,
        "CI": #"\d{4}"#,
        "CK": #"\d{4}"#,
        "CL": #"\d{7}"#,
        "CM": #"\d{7}"#,
        "CN": #"\d{6}"#,
        "CO": #"\d{6}"#,
        "CR": #"\d{4,5}|\d{3}-\d{4}"#,
        "CV": #"\d{4}"#,
        "CW": #"\d{4}"#,
        "CX": #"6798"#,
        "CY": #"\d{4}"#,
        "CZ": #"\d{3} ?\d{2}"#,
        "DE": #"\d{5}"#,
        "DJ": #"\d{5}"#,
        "DK": #"\d{4}"#,
        "DM": #"\d{4}"#,
        "DO": #"\d{5}"#,
        "DZ": #"\d{5}"#,
        "EC": #"\d{6}"#,
        "EE": #"\d{5}"#,
        "EG": #"\d{5}"#,
        "EH": #"\d{5}"#,
        "ER": #"\d{5}"#,
        "ES": #"\d{5}"#,
        "ET": #"\d{4}"#,
        "FI": #"\d{5}"#,
        "FJ": #"\d{5}"#,
        "FK": #"FIQQ 1ZZ"#,
        "FM": #"(9694[1-4])(?:[ \-](\d{4}))?"#,
        "FO": #"\d{3}"#,
        "FR": #"\d{2} ?\d{3}"#,
        "GA": #"\d{2} ?\d{3}"#,
        "GB": #"GIR ?0AA|(?:(?:AB|AL|B|BA|BB|BD|BH|BL|BN|BR|BS|BT|BX|CA|CB|CF|CH|CM|CO|CR|CT|CV|CW|DA|DD|DE|DG|DH|DL|DN|DT|DY|E|EC|EH|EN|EX|FK|FY|G|GL|GY|GU|HA|HD|HG|HP|HR|HS|HU|HX|IG|IM|IP|IV|JE|KA|KT|KW|KY|L|LA|LD|LE|LL|LN|LS|LU|M|ME|MK|ML|N|NE|NG|NN|NP|NR|NW|OL|OX|PA|PE|PH|PL|PO|PR|RG|RH|RM|S|SA|SE|SG|SK|SL|SM|SN|SO|SP|SR|SS|ST|SW|SY|TA|TD|TF|TN|TQ|TR|TS|TW|UB|W|WA|WC|WD|WF|WN|WR|WS|WV|YO|ZE)(?:\d[\dA-Z]? ?\d[ABD-HJLN-UW-Z]{2}))|BFPO ?\d{1,4}"#,
        "GD": #"GIR ?0AA|(?:(?:AB|AL|B|BA|BB|BD|BH|BL|BN|BR|BS|BT|BX|CA|CB|CF|CH|CM|CO|CR|CT|CV|CW|DA|DD|DE|DG|DH|DL|DN|DT|DY|E|EC|EH|EN|EX|FK|FY|G|GL|GY|GU|HA|HD|HG|HP|HR|HS|HU|HX|IG|IM|IP|IV|JE|KA|KT|KW|KY|L|LA|LD|LE|LL|LN|LS|LU|M|ME|MK|ML|N|NE|NG|NN|NP|NR|NW|OL|OX|PA|PE|PH|PL|PO|PR|RG|RH|RM|S|SA|SE|SG|SK|SL|SM|SN|SO|SP|SR|SS|ST|SW|SY|TA|TD|TF|TN|TQ|TR|TS|TW|UB|W|WA|WC|WD|WF|WN|WR|WS|WV|YO|ZE)(?:\d[\dA-Z]? ?\d[ABD-HJLN-UW-Z]{2}))|BFPO ?\d{1,4}"#,
        "GE": #"\d{4}"#,
        "GF": #"9[78]3\d{2}"#,
        "GG": #"GY\d[\dA-Z]? ?\d[ABD-HJLN-UW-Z]{2}"#,
        "GH": #"GY\d[\dA-Z]? ?\d[ABD-HJLN-UW-Z]{2}"#,
        "GI": #"GX11 1AA"#,
        "GL": #"39\d{2}"#,
        "GM": #"39\d{2}"#,
        "GN": #"\d{3}"#,
        "GP": #"9[78][01]\d{2}"#,
        "GQ": #"9[78][01]\d{2}"#,
        "GR": #"\d{3} ?\d{2}"#,
        "GS": #"SIQQ 1ZZ"#,
        "GT": #"\d{5}"#,
        "GU": #"(969(?:[12]\d|3[12]))(?:[ \-](\d{4}))?"#,
        "GW": #"\d{4}"#,
        "GY": #"\d{4}"#,
        "HK": #"\d{4}"#,
        "HM": #"\d{4}"#,
        "HN": #"\d{5}"#,
        "HR": #"\d{5}"#,
        "HT": #"\d{4}"#,
        "HU": #"\d{4}"#,
        "ID": #"\d{5}"#,
        "IE": #"[\dA-Z]{3} ?[\dA-Z]{4}"#,
        "IL": #"\d{5}(?:\d{2})?"#,
        "IM": #"IM\d[\dA-Z]? ?\d[ABD-HJLN-UW-Z]{2}"#,
        "IN": #"\d{6}"#,
        "IO": #"BBND 1ZZ"#,
        "IQ": #"\d{5}"#,
        "IR": #"\d{5}-?\d{5}"#,
        "IS": #"\d{3}"#,
        "IT": #"\d{5}"#,
        "JE": #"JE\d[\dA-Z]? ?\d[ABD-HJLN-UW-Z]{2}"#,
        "JM": #"JE\d[\dA-Z]? ?\d[ABD-HJLN-UW-Z]{2}"#,
        "JO": #"\d{5}"#,
        "JP": #"\d{3}-?\d{4}"#,
        "KE": #"\d{5}"#,
        "KG": #"\d{6}"#,
        "KH": #"\d{5}"#,
        "KI": #"\d{5}"#,
        "KM": #"\d{5}"#,
        "KN": #"\d{5}"#,
        "KR": #"\d{5}"#,
        "KW": #"\d{5}"#,
        "KY": #"KY\d-\d{4}"#,
        "KZ": #"\d{6}"#,
        "LA": #"\d{5}"#,
        "LB": #"(?:\d{4})(?: ?(?:\d{4}))?"#,
        "LC": #"(?:\d{4})(?: ?(?:\d{4}))?"#,
        "LI": #"948[5-9]|949[0-7]"#,
        "LK": #"\d{5}"#,
        "LR": #"\d{4}"#,
        "LS": #"\d{3}"#,
        "LT": #"\d{5}"#,
        "LU": #"\d{4}"#,
        "LV": #"LV-\d{4}"#,
        "LY": #"LV-\d{4}"#,
        "MA": #"\d{5}"#,
        "MC": #"980\d{2}"#,
        "MD": #"\d{4}"#,
        "ME": #"8\d{4}"#,
        "MF": #"9[78][01]\d{2}"#,
        "MG": #"\d{3}"#,
        "MH": #"(969[67]\d)(?:[ \-](\d{4}))?"#,
        "MK": #"\d{4}"#,
        "ML": #"\d{4}"#,
        "MM": #"\d{5}"#,
        "MN": #"\d{5}"#,
        "MO": #"\d{5}"#,
        "MP": #"(9695[012])(?:[ \-](\d{4}))?"#,
        "MQ": #"9[78]2\d{2}"#,
        "MR": #"9[78]2\d{2}"#,
        "MS": #"9[78]2\d{2}"#,
        "MT": #"[A-Z]{3} ?\d{2,4}"#,
        "MU": #"\d{3}(?:\d{2}|[A-Z]{2}\d{3})"#,
        "MV": #"\d{5}"#,
        "MW": #"\d{5}"#,
        "MX": #"\d{5}"#,
        "MY": #"\d{5}"#,
        "MZ": #"\d{4}"#,
        "NA": #"\d{4}"#,
        "NC": #"988\d{2}"#,
        "NE": #"\d{4}"#,
        "NF": #"2899"#,
        "NG": #"\d{6}"#,
        "NI": #"\d{5}"#,
        "NL": #"\d{4} ?[A-Z]{2}"#,
        "NO": #"\d{4}"#,
        "NP": #"\d{5}"#,
        "NR": #"\d{5}"#,
        "NU": #"\d{5}"#,
        "NZ": #"\d{4}"#,
        "OM": #"(?:PC )?\d{3}"#,
        "PA": #"(?:PC )?\d{3}"#,
        "PE": #"(?:LIMA \d{1,2}|CALLAO 0?\d)|[0-2]\d{4}"#,
        "PF": #"987\d{2}"#,
        "PG": #"\d{3}"#,
        "PH": #"\d{4}"#,
        "PK": #"\d{5}"#,
        "PL": #"\d{2}-\d{3}"#,
        "PM": #"9[78]5\d{2}"#,
        "PN": #"PCRN 1ZZ"#,
        "PR": #"(00[679]\d{2})(?:[ \-](\d{4}))?"#,
        "PS": #"(00[679]\d{2})(?:[ \-](\d{4}))?"#,
        "PT": #"\d{4}-\d{3}"#,
        "PW": #"(969(?:39|40))(?:[ \-](\d{4}))?"#,
        "PY": #"\d{4}"#,
        "QA": #"\d{4}"#,
        "RE": #"9[78]4\d{2}"#,
        "RO": #"\d{6}"#,
        "RS": #"\d{5,6}"#,
        "RU": #"\d{6}"#,
        "RW": #"\d{6}"#,
        "SA": #"\d{5}"#,
        "SB": #"\d{5}"#,
        "SC": #"\d{5}"#,
        "SE": #"\d{3} ?\d{2}"#,
        "SG": #"\d{6}"#,
        "SH": #"(?:ASCN|STHL) 1ZZ"#,
        "SI": #"\d{4}"#,
        "SJ": #"\d{4}"#,
        "SK": #"\d{3} ?\d{2}"#,
        "SL": #"\d{3} ?\d{2}"#,
        "SM": #"4789\d"#,
        "SN": #"\d{5}"#,
        "SO": #"[A-Z]{2} ?\d{5}"#,
        "SR": #"[A-Z]{2} ?\d{5}"#,
        "SS": #"[A-Z]{2} ?\d{5}"#,
        "ST": #"[A-Z]{2} ?\d{5}"#,
        "SV": #"CP [1-3][1-7][0-2]\d"#,
        "SX": #"CP [1-3][1-7][0-2]\d"#,
        "SZ": #"[HLMS]\d{3}"#,
        "TA": #"TDCU 1ZZ"#,
        "TC": #"TKCA 1ZZ"#,
        "TD": #"TKCA 1ZZ"#,
        "TF": #"TKCA 1ZZ"#,
        "TG": #"TKCA 1ZZ"#,
        "TH": #"\d{5}"#,
        "TJ": #"\d{6}"#,
        "TK": #"\d{6}"#,
        "TL": #"\d{6}"#,
        "TM": #"\d{6}"#,
        "TN": #"\d{4}"#,
        "TO": #"\d{4}"#,
        "TR": #"\d{5}"#,
        "TT": #"\d{5}"#,
        "TV": #"\d{5}"#,
        "TW": #"\d{3}(?:\d{2})?"#,
        "TZ": #"\d{4,5}"#,
        "UA": #"\d{5}"#,
        "UG": #"\d{5}"#,
        "UM": #"96898"#,
        "US": #"(\d{5})(?:[ \-](\d{4}))?"#,
        "UY": #"\d{5}"#,
        "UZ": #"\d{6}"#,
        "VA": #"00120"#,
        "VC": #"VC\d{4}"#,
        "VE": #"\d{4}"#,
        "VG": #"VG\d{4}"#,
        "VI": #"(008(?:(?:[0-4]\d)|(?:5[01])))(?:[ \-](\d{4}))?"#,
        "VN": #"\d{6}"#,
        "VU": #"\d{6}"#,
        "WF": #"986\d{2}"#,
        "WS": #"986\d{2}"#,
        "XK": #"[1-7]\d{4}"#,
        "YE": #"[1-7]\d{4}"#,
        "YT": #"976\d{2}"#,
        "ZA": #"\d{4}"#,
        "ZM": #"\d{5}"#,
        "ZW": #"\d{5}"#
    ]
    // swiftlint:enable line_length
    /**
     *  The two-letter ISO 3166-2 region code
     *  (for example, "US" for the United States of America).
     */
    var regionCode: String

    private var regularExpression: NSRegularExpression

    /**
     * Creates a postal code validator for the specified region.
     *
     * Returns `nil` if the region isn't supported.
     *
     * - Parameters:
     *   - region: A two-letter ISO 3166-2 region code
     *             (for example, "US" for the United States of America).
     */
    public init?(regionCode: String) {
        guard let pattern = PostalCodeValidator.patternsByRegion[regionCode],
            let regex = try? NSRegularExpression(pattern: #"\A\#(pattern)\Z"#, options: [])
        else { return nil }

        self.regionCode = regionCode
        regularExpression = regex
    }

    /**
     * Creates a postal code validator for the region of the specified locale.
     *
     * Returns `nil` if the locale doesn't have a valid region,
     * or the region isn't supported.
     *
     * - Parameters:
     *   - locale: The locale whose `regionCode` property is used to determine
     *             the appropriate postal code validation rules.
     */
    public convenience init?(locale: Locale) {
        guard let regionCode = locale.regionCode else { return nil }

        self.init(regionCode: regionCode)
    }

    /**
     * Returns whether a postal code is valid for the configured region.
     *
     * - Parameters:
     *   - postalCode: The postal code.
     * - Returns: `true` if valid, otherwise `false`.
     */
    public func validate(postalCode: String) -> Bool {
        regularExpression.rangeOfFirstMatch(in: postalCode, options: [], range: NSRange(postalCode.startIndex ..< postalCode.endIndex, in: postalCode)).location != NSNotFound
    }
}
