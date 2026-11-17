# Sample piano scales

`majorPianoScales.wav` is a synthesized piano-like C-major scale ascending
from C3 to C5, then descending to C3. It contains 29 notes with short silent
gaps, lasts about 19 seconds, and uses mono, 44.1 kHz, 16-bit PCM audio.

The sound was generated entirely in MATLAB using decaying harmonics, a
smooth attack and release, and `audiowrite`. It is not a recording of an
acoustic piano and contains no third-party audio samples. It is covered by
the activity's BSD 3-Clause license.

Students do not need to regenerate it. Maintainers can run this from the
repository root:

```matlab
addpath("buildUtilities")
generateSampleAudio
```
