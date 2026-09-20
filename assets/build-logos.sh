#!/usr/bin/env bash
# Rebuild raster assets without changing the original artwork.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
command -v magick >/dev/null || { printf 'ImageMagick (magick) is required.\n' >&2; exit 1; }
# Single source of truth for branded backgrounds.
source ./brand-colors.env
source_logo=commonfire-logo-source.png
mkdir -p png webp avatars monochrome favicon banners

# Keep the source canvas and aspect ratio; never upscale the original.
for size in 1024 512 256 128 64 32; do
  magick "$source_logo" -colorspace sRGB -resize "${size}x${size}" -strip "png/commonfire-logo-${size}.png"
  magick "png/commonfire-logo-${size}.png" -define webp:lossless=true "webp/commonfire-logo-${size}.webp"
done

# Extra breathing room for square/circular avatar crops.
for variant in light dark; do
  if [[ $variant == light ]]; then background="$COMMONFIRE_BG_LIGHT"; else background="$COMMONFIRE_BG_DARK"; fi
  magick "$source_logo" -resize 800x800 -background "$background" \
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

# Luminance-based monochromes retain the internal ribbons and gradients.
# Apply tonal ranges to RGB only so the original transparency is unchanged.
for variant in graphite silver; do
  if [[ $variant == graphite ]]; then tones='10%,60%'; else tones='45%,95%'; fi
  magick png/commonfire-logo-1024.png -colorspace Gray -colorspace sRGB \
    -channel RGB +level "$tones" +channel -strip \
    "monochrome/commonfire-logo-${variant}.png"
  magick "monochrome/commonfire-logo-${variant}.png" -define webp:lossless=true \
    "monochrome/commonfire-logo-${variant}.webp"
done

magick png/commonfire-logo-256.png -define icon:auto-resize=64,48,32,16 favicon/favicon.ico
magick "$source_logo" -resize 144x144 -background "$COMMONFIRE_BG_LIGHT" -alpha remove -alpha off \
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
  magick -size 1600x480 "xc:$background" \
    \( "$source_logo" -resize 360x360 \) -geometry +60+60 -composite \
    -fill "$foreground" -font "$font_bold" -pointsize 112 \
    -annotate +470+250 'CommonFIRE' \
    -font "$font_regular" -pointsize 30 \
    -annotate +476+316 'Free Intelligence, Research and Evolution' \
    -strip "banners/commonfire-banner-${variant}.png"
  magick "banners/commonfire-banner-${variant}.png" -define webp:lossless=true \
    "banners/commonfire-banner-${variant}.webp"
done
printf 'Rebuilt CommonFIRE logo exports.\n'
