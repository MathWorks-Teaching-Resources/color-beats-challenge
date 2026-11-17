function openColorBeatsChallenge
%openColorBeatsChallenge - Open the Color Beats student activity
%   openColorBeatsChallenge opens the plain-text live script in MATLAB.
%
%   See also ColorBeatsApp, open

%   Copyright 2026 The MathWorks, Inc.

activityFile = fullfile(fileparts(mfilename("fullpath")), ...
    "ColorBeatsChallenge_Student_Activity.m");
open(activityFile)
end
