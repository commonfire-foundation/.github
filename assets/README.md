# CommonFIRE logo assets

`commonfire-logo.svg` is the canonical vector master for **every size and treatment**: icons, avatars, banners, full color, and monochrome. The approved spacing moves the two sides slightly apart while preserving every original path and curve.

`commonfire-logo-source.svg` is the archived, unmodified vector source—not the current production spacing.

`commonfire-logo-source.png` is the original 1254 × 1254 transparent image, preserved unchanged as a reference.

## Canonical geometry and sizes

`build-logo-master.py` derives the canonical SVG from the archived source. It preserves the original 1254 × 1254 viewBox, all 12 path definitions, fills, opacity, and painter order, applying only horizontal translations: −26 units to the left side and +26 to the right. This adds about 2 px of separation at 48 px without changing either silhouette. No curves, curls, tips, or tails are redrawn. This spacing is now the brand standard at all sizes—not a small-icon exception.

Use `commonfire-logo.svg` wherever scalable artwork is supported. Raster files are provided at 16, 32, 48, 64, 128, 256, 512, 1024, and 2048 px. Optional solid black/white small exports use exactly the same geometry.

The builder uses the canonical master for every export. Icons up to 64 px render at 4× size and downsample once with alpha-aware Lanczos filtering; larger assets render at their required size. **Full color is the default at every size**, including 16 and 32 px. Optional black and white alternatives remain available in `monochrome/`. `favicon.ico` uses full color in all four frames; the optional `favicon-on-dark.ico` substitutes white for the 16/32 px frames. Banners, large avatars, touch icons, and 1024 px monochromes all use the same canonical spacing.

`proofs/commonfire-optical-sizes.png` compares the original, adjusted full-color mark, and background-appropriate solid silhouette on both canonical backgrounds. Each cell shows the true-size icon above a nearest-neighbor pixel enlargement; **USE** marks the selected variant. View the sheet at 100% to assess actual-size icons. Rebuild it with Python 3 and the same rendering dependencies:

```sh
python3 assets/build-icon-proof.py
```

## Canonical brand colors

`brand-colors.env` is the source of truth for CommonFIRE's background and wordmark accent colors. The builder reads it directly; future brand surfaces should reuse these tokens.

| Token | Name | sRGB hex | Role |
| --- | --- | --- | --- |
| `COMMONFIRE_BG_LIGHT` | Hearth Linen | `#F2E8D9` | Warm, softly lit neutral for light avatars and surfaces |
| `COMMONFIRE_BG_DARK` | Blue Ash | `#242B33` | Cool blue-charcoal for dark avatars and surfaces |
| `COMMONFIRE_ACCENT_FIRE` | Flame Orange | `#FE7009` | SVG-derived accent for the FIRE wordmark; not a body-text color |

Hearth Linen complements the flame without stark white; Blue Ash gives the warm reds and golds a cool counterpoint without pure black. These are the default branded backdrops, not replacements for the logo's original flame colors. Use graphite monochrome on light and silver monochrome on dark. Solid black/white logo exports remain available for single-ink use.

PNG avatars preserve exact background values; JPEG compression may shift them slightly.

## Exports

| Path | Use |
| --- | --- |
| `png/commonfire-logo-{size}.png` | Transparent general-purpose logo, at 2048, 1024, 512, 256, 128, 64, 48, 32, and 16 pixels square |
| `webp/commonfire-logo-{size}.webp` | Lossless transparent web versions at the same sizes |
| `avatars/commonfire-avatar-light.png` | 1024 px Hearth Linen organization avatar |
| `avatars/commonfire-avatar-dark.png` | 1024 px Blue Ash avatar |
| `banners/commonfire-banner-{light,dark}.{png,webp}` | 1800 × 600 concept-inspired banner with a large flame, two-tone CommonFIRE wordmark, and expanded-name subtitle |
| `avatars/preview.png` | Side-by-side light/dark avatar preview |
| `avatars/*.jpg` | Opaque JPEG alternatives for services that require JPEG |
| `monochrome/commonfire-logo-black.png` | 1024 px transparent black silhouette for light backgrounds |
| `monochrome/commonfire-logo-white.png` | 1024 px transparent white silhouette for dark backgrounds |
| `monochrome/commonfire-logo-graphite.{png,webp}` | 1024 px shaded grayscale for light backgrounds; preserves internal ribbon shading |
| `monochrome/commonfire-logo-silver.{png,webp}` | 1024 px lighter shaded grayscale for dark backgrounds; preserves internal ribbon shading |
| `monochrome/commonfire-logo-{black,white}-{16,32}.{png,webp}` | Solid small-size icons, black on light or white on dark |
| `favicon/favicon.ico` | Full-color 16/32/48/64 px frames |
| `favicon/favicon-on-dark.ico` | White 16/32 px frames; full-color 48/64 px frames |
| `favicon/apple-touch-icon.png` | 180 px Hearth Linen touch icon |

Banners follow the supplied concept's 3:1 composition: a large flame at left, neutral “Common” and orange “FIRE,” with the expanded name beneath. They use clean vector-derived artwork and reproducible typography rather than the concept image's baked-in texture. Light and dark variants retain the canonical backgrounds.

Avatars and the touch icon include extra padding. Transparent exports use square canvases with optical spacing appropriate to their master. Use PNG or WebP for transparent backgrounds; JPEG cannot retain transparency.

## Rebuild

Requires Python 3, librsvg (`rsvg-convert`), ImageMagick 7 with PNG, WebP, JPEG, and ICO support, plus DejaVu Sans regular and bold for banners. Font names can be overridden with `COMMONFIRE_FONT_REGULAR` and `COMMONFIRE_FONT_BOLD`. From this `.github` repository root:

```sh
bash assets/build-logos.sh
```

The script regenerates the canonical SVG derivative and raster exports, never the original source PNG or SVG. Avatars, touch icons, and banners use vector renders at their exact embedded logo sizes; each favicon frame is also rendered independently.

## Artwork limitations

The SVG has been checked for valid XML, closed paths, external resources, clipping, and visual agreement with the original. It uses three flat colors rather than the PNG's subtle gradients, with cleaner edges. Shaded monochromes retain those internal tonal regions; they are not flat silhouettes. The canonical derivative preserves all original detail and only increases separation; optional solid exports remove internal shading when a monochrome treatment is preferred. The proof sheet makes these differences visible. The silhouette still has limited detail at 16 px and should not be judged from an enlarged preview alone.

This public `.github` repository is the canonical home for CommonFIRE brand assets. The organization profile uses the light/dark banners from `banners/`. Generating assets does not publish changes by itself or change the GitHub organization avatar; avatar uploads are managed separately in organization settings.
