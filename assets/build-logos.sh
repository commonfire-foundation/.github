#!/usr/bin/env bash
# Rebuild raster assets without changing the original artwork.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
command -v magick >/dev/null || { printf 'ImageMagick (magick) is required.\n' >&2; exit 1; }
command -v rsvg-convert >/dev/null || { printf 'librsvg (rsvg-convert) is required.\n' >&2; exit 1; }
# Single source of truth for branded backgrounds.
source ./brand-colors.env
source_logo=commonfire-logo-source.svg
mkdir -p png webp avatars monochrome favicon banners
# Keep scratch renders inside the repository and remove them even on failure.
build_dir=$(mktemp -d .logo-build.XXXXXX)
trap 'rm -rf -- "$build_dir"' EXIT

# Rasterize the vector at each target size, never resize a raster master.
for size in 2048 1024 512 256 128 64 48 32 16; do
  rsvg-convert --width "$size" --height "$size" "$source_logo" \
    --output "$build_dir/render.png"
  magick "$build_dir/render.png" -strip "png/commonfire-logo-${size}.png"
  magick "png/commonfire-logo-${size}.png" -define webp:lossless=true "webp/commonfire-logo-${size}.webp"
done

# Native-size renders for composed exports.
for size in 800 144 420; do
  rsvg-convert --width "$size" --height "$size" "$source_logo" \
    --output "$build_dir/logo-${size}.png"
done

# Extra breathing room for square/circular avatar crops.
for variant in light dark; do
  if [[ $variant == light ]]; then background="$COMMONFIRE_BG_LIGHT"; else background="$COMMONFIRE_BG_DARK"; fi
  magick "$build_dir/logo-800.png" -background "$background" \
    -alpha remove -alpha off -gravity center -extent 1024x1024 -strip \
    "avatars/commonfire-avatar-${variant}.png"
  magick "avatars/commonfire-avatar-${variant}.png" -quality 92 \
    "avatars/commonfire-avatar-${variant}.jpg"
done

magick montage avatars/commonfire-avatar-light.png avatars/commonfire-avatar-dark.png \
  -thumbnail 384x384 -tile 2x1 -geometry +0+0 avatars/preview.png

# Preserve the source alpha, replacing only RGB values.
for variant in black white; do
  magick png/commonfire-logo-1024.png -channel RGB -fill "$variant" \
    -colorize 100 +channel -strip "monochrome/commonfire-logo-${variant}.png"
done

# Luminance-based monochromes retain the vector's internal ribbon shading.
# Apply tonal ranges to RGB only so the original transparency is unchanged.
for variant in graphite silver; do
  if [[ $variant == graphite ]]; then tones='10%,60%'; else tones='45%,95%'; fi
  magick png/commonfire-logo-1024.png -colorspace Gray -colorspace sRGB \
    -channel RGB +level "$tones" +channel -strip \
    "monochrome/commonfire-logo-${variant}.png"
  magick "monochrome/commonfire-logo-${variant}.png" -define webp:lossless=true \
    "monochrome/commonfire-logo-${variant}.webp"
done

magick png/commonfire-logo-64.png png/commonfire-logo-48.png \
  png/commonfire-logo-32.png png/commonfire-logo-16.png favicon/favicon.ico
magick "$build_dir/logo-144.png" -background "$COMMONFIRE_BG_LIGHT" -alpha remove -alpha off \
  -gravity center -extent 180x180 -strip favicon/apple-touch-icon.png
# Horizontal lockups: flame, wordmark, and expanded name.
# Override these names when using a different local font installation.
font_bold=${COMMONFIRE_FONT_BOLD:-DejaVu-Sans-Bold}
font_regular=${COMMONFIRE_FONT_REGULAR:-DejaVu-Sans}
for variant in light dark; do
  if [[ $variant == light ]]; then
    background="$COMMONFIRE_BG_LIGHT"; foreground="$COMMONFIRE_BG_DARK"
  else
    background="$COMMONFIRE_BG_DARK"; foreground="$COMMONFIRE_BG_LIGHT"
  fi
  # Shared font metrics keep the two wordmark segments on one baseline.
  # Trim only after joining, then scale proportionally to the concept's width.
  magick -background none -font "$font_bold" -pointsize 180 \
    \( -fill "$foreground" label:Common \) \
    \( -fill "$COMMONFIRE_ACCENT_FIRE" label:FIRE \) \
    +append -trim +repage -resize 1060x160 "$build_dir/wordmark.png"
  magick -background none -fill "$foreground" -font "$font_regular" -pointsize 60 \
    label:'Free Intelligence, Research and Evolution' \
    -trim +repage -resize 1030x50 "$build_dir/tagline.png"
  magick -size 1800x600 "xc:$background" \
    \( "$build_dir/logo-420.png" \) -geometry +95+80 -composite \
    \( "$build_dir/wordmark.png" \) -geometry +520+225 -composite \
    \( "$build_dir/tagline.png" \) -geometry +527+377 -composite \
    -depth 8 -strip "banners/commonfire-banner-${variant}.png"
  magick "banners/commonfire-banner-${variant}.png" -define webp:lossless=true \
    "banners/commonfire-banner-${variant}.webp"
done
printf 'Rebuilt CommonFIRE logo exports.\n'
