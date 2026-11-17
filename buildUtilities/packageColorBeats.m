function outputFile = packageColorBeats
%packageColorBeats - Build the Color Beats installable toolbox file
%   outputFile = packageColorBeats builds the distributable toolbox folder
%   into release/ColorBeatsChallenge.mltbx using its package metadata.
%
%   See also toolboxSpecification, matlab.addons.toolbox.packageToolbox

%   Copyright 2026 The MathWorks, Inc.

root = fileparts(fileparts(mfilename("fullpath")));
toolboxFolder = fullfile(root, "toolbox");
spec = toolboxSpecification;
opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder, spec.toolbox.id);
opts.ToolboxName = spec.toolbox.displayName;
opts.ToolboxVersion = spec.toolbox.version;
opts.Summary = spec.toolbox.summary;
opts.AuthorCompany = spec.toolbox.provider.organization;
opts.MinimumMatlabRelease = "R2026a";
opts.ToolboxMatlabPath = {toolboxFolder};
opts.ToolboxGettingStartedGuide = fullfile(toolboxFolder, "doc", "GettingStarted.m");
% Use properties shared with R2026a. Preserve the shipped license verbatim.
releaseFolder = fullfile(root, "release");
if ~isfolder(releaseFolder)
    mkdir(releaseFolder);
end
outputFile = fullfile(releaseFolder, "ColorBeatsChallenge.mltbx");
opts.OutputFile = outputFile;
matlab.addons.toolbox.packageToolbox(opts);
end
