"""Cooldown Manager Profiles project icon: saved layouts of the cooldown bar.

400x400 PNG. Three stacked cards - the saved profiles - with the front one
turned into a single cooldown icon mid-sweep. Both halves of the addon in one
shape: what it stores, and what it stores it of.

The first attempt put a row of three small cooldown slots on the front card.
At 48px, the size this is actually seen at in a browse list, a 76px slot
becomes 9px and the sweep inside it becomes a smudge - the icon read as a grey
card with teal specks while its three neighbours each carried one big block of
colour. One large sweep survives the same reduction, because a dark wedge
eating into a light square is the shape the game draws on every button.

The sweep runs the way Blizzard's does: the lit part grows clockwise from 12
o'clock, so the dark remainder ends at 12. Drawing it mirrored is the easy
mistake - Pillow measures from 3 o'clock, clockwise.

400 exactly, because CurseForge's logo cropper opens on a fixed 400x400
selection pinned to the top left: a larger image comes out cropped unless the
author drags the handles.
"""
from PIL import Image, ImageDraw, ImageFilter

S = 512      # drawn large, downsampled at the end so the curves stay smooth
OUT_SIZE = 400
BG = (24, 27, 34)
BG_EDGE = (44, 49, 60)
CARD_BACK = (62, 72, 90)
CARD_MID = (104, 118, 140)
TEAL = (56, 214, 195)
SWEEP = (16, 40, 44)

# Three cards of the same size, stepped up and to the right. Equal size is what
# makes them read as the same thing repeated - the earlier version gave each
# card different dimensions and they looked like unrelated rectangles.
CARD = 276
STEP = 28
RADIUS = 51
BACK = [146, 90, 146 + CARD, 90 + CARD]
MID = [118, 118, 118 + CARD, 118 + CARD]
FRONT = [90, 146, 90 + CARD, 146 + CARD]

img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
d = ImageDraw.Draw(img)

# Rounded slate tile with a hairline edge, so the icon has a shape of its own
# against both light and dark list backgrounds.
d.rounded_rectangle([0, 0, S - 1, S - 1], radius=96, fill=BG, outline=BG_EDGE, width=4)

# The profiles waiting behind. Outlined in the tile colour so the steps stay
# separate at 32px instead of merging into one grey slab.
d.rounded_rectangle(BACK, radius=RADIUS, fill=CARD_BACK, outline=BG, width=8)
d.rounded_rectangle(MID, radius=RADIUS, fill=CARD_MID, outline=BG, width=8)

# Glow under the active card, on its own layer so the blur cannot eat the edge.
glow = Image.new("RGBA", (S, S), (0, 0, 0, 0))
ImageDraw.Draw(glow).rounded_rectangle(FRONT, radius=RADIUS, fill=TEAL + (70,))
img.alpha_composite(glow.filter(ImageFilter.GaussianBlur(20)))

# The profile in use, as one lit cooldown icon.
d.rounded_rectangle(FRONT, radius=RADIUS, fill=TEAL, outline=BG, width=8)

# The sweep, inset so a lit rim survives all the way round: without it the dark
# wedge touches the card edge and the square stops reading as an icon.
inset = 18
d.pieslice([FRONT[0] + inset, FRONT[1] + inset, FRONT[2] - inset, FRONT[3] - inset],
           start=40, end=270, fill=SWEEP)

out = "icon.png"
# Flattened onto the same slate as the tile: the upload widget refuses
# transparent corners, and black corners would read as a hard square on a light
# list row.
small = img.resize((OUT_SIZE, OUT_SIZE), Image.LANCZOS)
ground = Image.new("RGB", (OUT_SIZE, OUT_SIZE), BG)
ground.paste(small, (0, 0), small)
ground.save(out)
print(out)
