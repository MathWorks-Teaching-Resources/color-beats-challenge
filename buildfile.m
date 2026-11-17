function plan = buildfile
%buildfile - Check, test, and package Color Beats Challenge
%   PLAN = buildfile defines the repeatable build. BUILDTool runs checks
%   and tests by default. BUILDTool PACKAGE also creates the toolbox file.

%   Copyright 2026 The MathWorks, Inc.

import matlab.buildtool.tasks.CodeIssuesTask
import matlab.buildtool.tasks.TestTask

plan = buildplan(localfunctions);
% Report warnings without making pre-existing app style issues blockers.
% Code errors and failed tests always fail the build.
plan("check") = CodeIssuesTask(["toolbox", "buildUtilities", "tests", "buildfile.m"], ...
    Configuration="factory", Results="derived/code-issues.sarif");
plan("test") = TestTask("tests", SourceFiles=["toolbox", "buildUtilities"], ...
    Dependencies="check", TestResults="derived/test-results.xml");
plan("package").Dependencies = "test";
plan("package").DisableIncremental = true;
plan("package").Outputs = "release/ColorBeatsChallenge.mltbx";
plan.DefaultTasks = ["check", "test"];
end

function packageTask(context)
% Build only after checks and tests pass; derive identity from metadata.
utilitiesFolder = fullfile(context.Plan.RootFolder, "buildUtilities");
originalPath = path;
cleanup = onCleanup(@() path(originalPath));
addpath(utilitiesFolder);
outputFile = packageColorBeats;
context.assertTrue(isfile(outputFile), "The toolbox file was not created.");
context.log("Created " + outputFile);
end
