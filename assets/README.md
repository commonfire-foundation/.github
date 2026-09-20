# CommonFIRE logo assets

`commonfire-logo-source.png` is the original 1254 × 1254 transparent image, renamed without modifying its contents.

## Canonical brand backgrounds

`brand-colors.env` is the source of truth for CommonFIRE's background colors. The builder reads it directly; future brand surfaces should reuse these tokens.

| Token | Name | sRGB hex | Role |
| --- | --- | --- | --- |
| `COMMONFIRE_BG_LIGHT` | Hearth Linen | `#F2E8D9` | Warm, softly lit neutral for light avatars and surfaces |
| `COMMONFIRE_BG_DARK` | Blue Ash | `#242B33` | Cool blue-charcoal for dark avatars and surfaces |

Hearth Linen complements the flame without stark white; Blue Ash gives the warm reds and golds a cool counterpoint without pure black. These are the default branded backdrops, not replacements for the logo's original flame colors. Use graphite monochrome on light and silver monochrome on dark. Solid black/white logo exports remain available for single-ink use.

PNG avatars preserve exact background values; JPEG compression may shift them slightly.

## Exports

| Path | Use |
| --- | --- |
| `png/commonfire-logo-{size}.png` | Transparent general-purpose logo, at 1024, 512, 256, 128, 64, and 32 pixels square |
| `webp/commonfire-logo-{size}.webp` | Lossless transparent web versions at the same sizes |
| `avatars/commonfire-avatar-light.png` | 1024 px Hearth Linen organization avatar |
| `avatars/commonfire-avatar-dark.png` | 1024 px Blue Ash avatar |
| `banners/commonfire-banner-{light,dark}.{png,webp}` | 1600 × 480 horizontal logo and wordmark on canonical backgrounds |
| `avatars/preview.png` | Side-by-side light/dark avatar preview |
| `avatars/*.jpg` | Opaque JPEG alternatives for services that require JPEG |
| `monochrome/commonfire-logo-black.png` | 1024 px transparent black silhouette for light backgrounds |
| `monochrome/commonfire-logo-white.png` | 1024 px transparent white silhouette for dark backgrounds |
| `monochrome/commonfire-logo-graphite.{png,webp}` | 1024 px shaded grayscale for light backgrounds; preserves internal ribbons and gradients |
| `monochrome/commonfire-logo-silver.{png,webp}` | 1024 px lighter shaded grayscale for dark backgrounds; preserves internal ribbons and gradients |
| `favicon/favicon.ico` | Multi-resolution icon: 16, 32, 48, and 64 px |
| `favicon/apple-touch-icon.png` | 180 px Hearth Linen touch icon |

Avatars and the touch icon include extra padding. Transparent exports retain the original canvas. Use PNG or WebP for transparent backgrounds; JPEG cannot retain transparency.

## Rebuild

Requires ImageMagick 7 with PNG, WebP, JPEG, and ICO support, plus DejaVu Sans regular and bold for banners. Font names can be overridden with `COMMONFIRE_FONT_REGULAR` and `COMMONFIRE_FONT_BOLD`. From this `.github` repository root:

```sh
bash assets/build-logos.sh
```

The script replaces generated exports, never the source image. No upscaling is performed.

## Artwork limitations

These are raster derivatives, not a vector master. The original includes stray pixels and rough edges, which these exports preserve. Monochrome variants inherit the same alpha silhouette. A clean SVG would require tracing or redrawing and visual approval, not simply wrapping the PNG in an SVG file. The detailed mark may need a simplified design for best legibility at 16–32 px.

This public `.github` repository is the canonical home for CommonFIRE brand assets. The organization profile uses the light/dark banners from `banners/`. Generating assets does not publish changes by itself or change the GitHub organization avatar; avatar uploads are managed separately in organization settings.
