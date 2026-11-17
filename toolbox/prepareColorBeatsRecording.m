function recording = prepareColorBeatsRecording(audioData, sampleRate)
%prepareColorBeatsRecording - Normalize audio for the Color Beats activity
%   RECORDING = prepareColorBeatsRecording(audioData,sampleRate) averages
%   audio channels, normalizes the peak amplitude, and returns the audio,
%   sample rate, and duration used by the activity and app.

%   Copyright 2026 The MathWorks, Inc.

arguments
    audioData (:,:) double {mustBeReal, mustBeFinite}
    sampleRate (1,1) double {mustBePositive, mustBeFinite}
end

if isempty(audioData)
    error("ColorBeats:EmptyAudio", ...
        "No audio came through. Choose Sample audio or check your microphone.");
end
y = mean(audioData, 2);
peak = max(abs(y));
if peak == 0
    error("ColorBeats:SilentAudio", ...
        "The audio is silent. Choose Sample audio or record a louder sound.");
end
recording.y = y / peak;
recording.fs = sampleRate;
recording.duration = numel(y) / sampleRate;
end
