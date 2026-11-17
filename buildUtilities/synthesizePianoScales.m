function [audioData, sampleRate, score] = synthesizePianoScales
%synthesizePianoScales - Synthesize ascending and descending piano scales
%   audioData = synthesizePianoScales generates a mono C-major scale from
%   C3 to C5 and back to C3 using decaying harmonics with a smooth attack
%   and release. The sound is synthesized, rather than a piano recording.
%
%   [audioData,sampleRate] = synthesizePianoScales also returns the sample
%   rate in hertz.
%
%   [audioData,sampleRate,SCORE] = synthesizePianoScales also returns note
%   frequencies, start times, and durations for checking the audio.
%
%   See also audiowrite, generateSampleAudio

%   Copyright 2026 The MathWorks, Inc.

sampleRate = 44100;
ascending = [48 50 52 53 55 57 59 60 62 64 65 67 69 71 72];
midiNotes = [ascending fliplr(ascending(1:end-1))];
frequencies = 440 * 2.^((midiNotes - 69) / 12);
noteSeconds = 0.55;
gapSeconds = 0.08;
leadSeconds = 0.25;
noteSamples = round(noteSeconds * sampleRate);
gapSamples = round(gapSeconds * sampleRate);
leadSamples = round(leadSeconds * sampleRate);
starts = leadSamples + (0:numel(midiNotes)-1)*(noteSamples + gapSamples);
audioData = zeros(starts(end) + noteSamples + leadSamples, 1);
t = (0:noteSamples-1)' / sampleRate;
attack = 1 - exp(-t / 0.003);
release = ones(size(t));
releaseSamples = round(0.09 * sampleRate);
release(end-releaseSamples+1:end) = ...
    0.5 * (1 + cos(linspace(0, pi, releaseSamples)'));

for noteIndex = 1:numel(frequencies)
    note = zeros(size(t));
    for partial = 1:10
        % Upper partials fade faster, like a struck piano string.
        partialFrequency = partial * frequencies(noteIndex);
        decay = exp(-t * (2.0 + 0.55*(partial-1)));
        note = note + partial^(-1.5) * decay .* ...
            sin(2*pi*partialFrequency*t);
    end
    indices = starts(noteIndex) + (1:noteSamples);
    audioData(indices) = note .* attack .* release;
end
audioData = 0.85 * audioData / max(abs(audioData));
score.frequencies = frequencies;
score.startTimes = starts / sampleRate;
score.noteSeconds = noteSeconds;
end
