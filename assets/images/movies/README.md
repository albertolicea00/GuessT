# Movie poster images

Drop image files here (`.png`, `.jpg`, `.jpeg`, `.webp`) to populate the
**Images** game mode. No manifest to edit — they're picked up
automatically at runtime via Flutter's asset manifest.

The filename (minus extension) becomes the answer players are guessing:
use underscores or dashes for spaces, they're converted back.

```
the_matrix.jpg     → "the matrix"
Jurassic-Park.png  → "Jurassic Park"
```

After adding files, run `flutter pub get` (or a full restart, not just
hot reload, if the app is already running) so the new assets are
bundled.

This README doesn't count as a game entry — only image files do.
