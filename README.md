# Is It Tofu?

This is a tool for figuring out if a given piece of text contains characters
that will become "tofu" on mobile platforms (specifically iOS and Android).

"Tofu" refers to the blank white square (□) sometimes shown in place of an
unsupported character.

## Methodology

The input text is split up into UTF-16 Unicode code units, and is compared
against data compiled by the
[CodePointCoverage](https://github.com/amake/CodePointCoverage) project.

Coverage is determined by inspecting the font files that are bundled with the
OS. If there is at least one font providing a glyph (more specifically, with an
entry in the `cmap` table) for a given codepoint, that codepoint is considered
"covered".

For iOS, the fonts are taken from the iOS Simulator runtimes bundled with
various versions of Xcode. For Android, the fonts are taken from the Android
Emulator system images downloadable with the Android SDK.

Note that this methodology is not completely accurate. Known issues:

- Codepoints need not have their own glyphs to be considered "supported"; see
  e.g. [variation
  selectors](https://en.wikipedia.org/wiki/Variation_Selectors_(Unicode_block))
- Codepoint-level analysis cannot account for support for multi-codepoint
  grapheme clusters like [emoji ZWJ
  sequences](https://www.unicode.org/emoji/charts/emoji-zwj-sequences.html)
- Especially on Android, vendors may bundle different fonts. Even "vanilla"
  Android may have different fonts from the SDK
  ([example](https://github.com/amake/isittofu/issues/1))

If you find any inaccuracies, please feel free to [open an
issue](https://github.com/amake/isittofu/issues).
