function outputFile = generateSampleAudio
%generateSampleAudio - Write the bundled Color Beats piano sample
%   outputFile = generateSampleAudio writes the reproducible mono,
%   44.1 kHz, 16-bit sample into toolbox/data and returns its full path.
%
%   See also synthesizePianoScales, audiowrite

%   Copyright 2026 The MathWorks, Inc.

projectRoot = fileparts(fileparts(mfilename("fullpath")));
outputFile = fullfile(projectRoot, "toolbox", "data", "majorPianoScales.wav");
[audioData, sampleRate] = synthesizePianoScales;
audiowrite(outputFile, audioData, sampleRate, "BitsPerSample", 16);
end
