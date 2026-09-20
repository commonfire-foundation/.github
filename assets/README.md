# CommonFIRE logo assets

`commonfire-logo-source.svg` is the canonical vector master used to generate every logo export. Each required size is rendered directly from its 1254 × 1254 viewBox, without upscaling a raster image.

`commonfire-logo-source.png` is the original 1254 × 1254 transparent image, preserved unchanged as a reference.

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
| `favicon/favicon.ico` | Multi-resolution icon: 16, 32, 48, and 64 px |
| `favicon/apple-touch-icon.png` | 180 px Hearth Linen touch icon |

Banners follow the supplied concept's 3:1 composition: a large flame at left, neutral “Common” and orange “FIRE,” with the expanded name beneath. They use clean vector-derived artwork and reproducible typography rather than the concept image's baked-in texture. Light and dark variants retain the canonical backgrounds.

Avatars and the touch icon include extra padding. Transparent exports retain the original canvas. Use PNG or WebP for transparent backgrounds; JPEG cannot retain transparency.

## Rebuild

Requires librsvg (`rsvg-convert`), ImageMagick 7 with PNG, WebP, JPEG, and ICO support, plus DejaVu Sans regular and bold for banners. Font names can be overridden with `COMMONFIRE_FONT_REGULAR` and `COMMONFIRE_FONT_BOLD`. From this `.github` repository root:

```sh
bash assets/build-logos.sh
```

The script replaces generated exports, never either source file. Avatars, touch icons, and banners use vector renders at their exact embedded logo sizes; each favicon frame is also rendered independently.

## Artwork limitations

The SVG has been checked for valid XML, closed paths, external resources, clipping, and visual agreement with the original. It uses three flat colors rather than the PNG's subtle gradients, with cleaner edges. Shaded monochromes retain those internal tonal regions; they are not flat silhouettes. The detailed mark may still need a simplified design for best legibility at 16–32 px.

This public `.github` repository is the canonical home for CommonFIRE brand assets. The organization profile uses the light/dark banners from `banners/`. Generating assets does not publish changes by itself or change the GitHub organization avatar; avatar uploads are managed separately in organization settings.
