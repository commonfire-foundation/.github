#!/usr/bin/env python3
"""Build a light/dark optical-size proof using ImageMagick and librsvg."""
from pathlib import Path
import os
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent


def run(*args):
    subprocess.run([str(arg) for arg in args], check=True, cwd=ROOT)


def main():
    tokens = dict(re.findall(r"^(COMMONFIRE_\w+)='(#[0-9A-Fa-f]{6})'", (ROOT / 'brand-colors.env').read_text(), re.M))
    light, dark = tokens['COMMONFIRE_BG_LIGHT'], tokens['COMMONFIRE_BG_DARK']
    font = os.environ.get('COMMONFIRE_FONT_REGULAR', 'DejaVu-Sans')
    bold = os.environ.get('COMMONFIRE_FONT_BOLD', 'DejaVu-Sans-Bold')
    output = ROOT / 'proofs/commonfire-optical-sizes.png'
    output.parent.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.icon-proof.', dir=ROOT) as scratch:
        scratch = Path(scratch)
        command = ['magick', '-size', '1600x1500', f'xc:{light}',
                   '-fill', dark, '-draw', 'rectangle 800,150 1599,1439']

        def text(x, y, value, color=dark, size=18, heavy=False):
            command.extend(['-fill', color, '-font', bold if heavy else font,
                            '-pointsize', str(size), '-annotate', f'+{x}+{y}', value])

        text(40, 60, 'CommonFIRE / Optical-size proof', size=34, heavy=True)
        text(40, 103, 'Compare silhouette, central separation, and curl clarity. View at 100% for actual-size rows.', size=19)
        masters = [('Original / reference', 'source'), ('Canonical / all sizes', 'canonical'), ('Solid / optional', 'solid')]
        for side, (background, foreground, label) in enumerate([
            (light, dark, 'HEARTH LINEN / LIGHT'), (dark, light, 'BLUE ASH / DARK')
        ]):
            offset = side * 800
            text(offset + 40, 190, label, foreground, 17, True)
            for column, (label, _) in enumerate(masters):
                text(offset + 42 + column * 255, 234, label, foreground, 18, True)

        for row, size in enumerate((64, 48, 32, 16)):
            top = 265 + row * 285
            zoom = 3 if size == 48 else 128 // size
            for side, foreground in enumerate((dark, light)):
                offset = side * 800
                text(offset + 40, top + 18, f'{size} px', foreground, 19, True)
                for column, (_, name) in enumerate(masters):
                    center = offset + 145 + column * 255
                    native = scratch / f'{name}-{size}-{side}.png'
                    enlarged = scratch / f'{name}-{size}-{side}-zoom.png'
                    scale = 1 if name == 'source' else 4
                    master_file = 'commonfire-logo-source.svg' if name == 'source' else 'commonfire-logo.svg'
                    raw = scratch / 'render.png'
                    run('rsvg-convert', '-w', size * scale, '-h', size * scale,
                        ROOT / master_file, '-o', raw)
                    if scale == 1:
                        run('magick', raw, '-strip', native)
                    else:
                        run('magick', raw, '-filter', 'Lanczos',
                            '-resize', f'{size}x{size}', '-strip', native)
                    if name == 'solid':
                        run('magick', native, '-channel', 'RGB', '-fill',
                            'black' if side == 0 else 'white', '-colorize', '100',
                            '+channel', '-strip', native)
                    run('magick', native, '-filter', 'point', '-resize', f'{zoom * 100}%', enlarged)
                    command.extend([str(native), '-geometry', f'+{center - size // 2}+{top + 72 - size // 2}', '-composite'])
                    command.extend([str(enlarged), '-geometry', f'+{center - size * zoom // 2}+{top + 108}', '-composite'])
                    chosen = name == 'canonical'
                    text(center - 96, top + 266,
                         f'1:1 above / {zoom}x pixels' + (' / USE' if chosen else ''), foreground, 13, chosen)
        text(40, 1480, 'Original: archived reference only. USE marks the export choice. Enlargements reveal pixels, not extra detail.', size=17)
        command.extend(['-depth', '8', '-strip', str(output)])
        run(*command)
    print(output)


if __name__ == '__main__':
    main()
