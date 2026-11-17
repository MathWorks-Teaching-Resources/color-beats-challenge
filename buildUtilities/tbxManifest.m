function manifest = tbxManifest
%tbxManifest - Describe distributable Color Beats files and dependencies
%   MANIFEST = tbxManifest lists the complete toolbox payload and describes
%   required and optional products. Tests and build tools do not ship.

%   Copyright 2026 The MathWorks, Inc.

root = fileparts(fileparts(mfilename("fullpath")));
files = dir(fullfile(root, "toolbox", "**", "*"));
files = files(~[files.isdir]);
manifest.files = string(fullfile({files.folder}, {files.name}));
manifest.requiredProducts = "MATLAB";
manifest.optionalProducts = "Signal Processing Toolbox";
manifest.optionalRationale = ...
    "spectrogram is optional; a base-MATLAB FFT implementation is included.";
manifest.audio = "toolbox/data/majorPianoScales.wav";
manifest.externalFiles = strings(0, 1);
manifest.excluded = ["tests", "buildUtilities", "images", "release"];
end
