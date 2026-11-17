function tests = testColorBeats
%testColorBeats - Verify sample audio and the hardware-free student activity
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename("fullpath")));
testCase.TestData.Root = root;
testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
    fullfile(root, "buildUtilities")));
testCase.applyFixture(matlab.unittest.fixtures.PathFixture(fullfile(root, "toolbox")));
end

function testSampleFormatAndHeadroom(testCase)
sampleFile = fullfile(testCase.TestData.Root, "toolbox", "data", ...
    "majorPianoScales.wav");
info = audioinfo(sampleFile);
[audio, fs] = audioread(sampleFile);
verifyEqual(testCase, fs, 44100);
verifyEqual(testCase, info.NumChannels, 1);
verifyEqual(testCase, info.BitsPerSample, 16);
verifyGreaterThan(testCase, info.Duration, 18);
verifyLessThan(testCase, info.Duration, 20);
verifyGreaterThan(testCase, max(abs(audio)), 0.8);
verifyLessThan(testCase, max(abs(audio)), 0.9);
verifyTrue(testCase, all(isfinite(audio)));
end

function testBundledAudioMatchesReproducibleSynthesis(testCase)
[expected, fs] = synthesizePianoScales;
again = synthesizePianoScales;
verifyEqual(testCase, again, expected);
sampleFile = fullfile(testCase.TestData.Root, "toolbox", "data", ...
    "majorPianoScales.wav");
[actual, actualFs] = audioread(sampleFile);
verifyEqual(testCase, actualFs, fs);
verifyEqual(testCase, actual, expected, "AbsTol", 1/32768);
end

function testAudioContainsAscendingAndDescendingMajorScale(testCase)
[~, fs, score] = synthesizePianoScales;
sampleFile = fullfile(testCase.TestData.Root, "toolbox", "data", ...
    "majorPianoScales.wav");
audio = audioread(sampleFile);
measured = zeros(1, numel(score.startTimes));
for k = 1:numel(measured)
    % Measure the waveform, rather than trusting the generator's score.
    first = round((score.startTimes(k) + 0.04)*fs) + 1;
    count = round(0.30*fs);
    frame = audio(first:first+count-1);
    window = 0.5 - 0.5*cos(2*pi*(0:count-1)'/(count-1));
    spectrum = abs(fft(frame .* window));
    [~, bin] = max(spectrum(2:floor(count/2)));
    measured(k) = bin*fs/count;
end
midi = round(69 + 12*log2(measured/440));
verifyEqual(testCase, midi(1), 48);
verifyEqual(testCase, midi(15), 72);
verifyEqual(testCase, midi(end), 48);
verifyEqual(testCase, diff(midi(1:15)), repmat([2 2 1 2 2 2 1], 1, 2));
verifyEqual(testCase, midi(16:end), fliplr(midi(1:14)));
verifyEqual(testCase, measured, score.frequencies, "AbsTol", 4);
end

function testRecordingNormalizationAndDuration(testCase)
recording = prepareColorBeatsRecording([1 3; -2 -2; 0 0], 100);
verifyEqual(testCase, recording.y, [1; -1; 0], "AbsTol", 1e-12);
verifyEqual(testCase, recording.fs, 100);
verifyEqual(testCase, recording.duration, 0.03, "AbsTol", 1e-12);
verifyError(testCase, @() prepareColorBeatsRecording([], 44100), ...
    "ColorBeats:EmptyAudio");
verifyError(testCase, @() prepareColorBeatsRecording(zeros(10, 1), 44100), ...
    "ColorBeats:SilentAudio");
end

function testActivityRunsWithoutMicrophone(testCase)
root = testCase.TestData.Root;
testCase.applyFixture(matlab.unittest.fixtures.PathFixture(fullfile(root, "toolbox")));
previousFigures = findall(groot, "Type", "figure");
testCase.addTeardown(@() closeNewFigures(previousFigures));
testCase.applyFixture(matlab.unittest.fixtures.WorkingFolderFixture);
run(fullfile(root, "toolbox", "ColorBeatsChallenge_Student_Activity.m"));
verifyEqual(testCase, audioSource, "Sample audio");
verifyEqual(testCase, recording.fs, 44100);
verifyEqual(testCase, max(abs(recording.y)), 1, "AbsTol", 1e-12);
verifyTrue(testCase, all(isfinite(painting.rgbStrip(:))));
verifyTrue(testCase, any(painting.isQuiet));
verifyTrue(testCase, any(~painting.isQuiet));
verifyGreaterThan(testCase, numel(painting.pitch), 300);
verifyGreaterThan(testCase, max(painting.pitch), 500);
verifyLessThan(testCase, min(painting.pitch), 150);
end

function testLiveEditorSectionCanFindRecordingHelper(testCase)
% Live Editor sections run in the base workspace, outside private scope.
testCase.applyFixture(matlab.unittest.fixtures.WorkingFolderFixture);
recording = evalin("base", "prepareColorBeatsRecording([1;-1;0],44100)");
verifyEqual(testCase, recording.y, [1; -1; 0], "AbsTol", 1e-12);
verifyEqual(testCase, recording.fs, 44100);
verifyEqual(testCase, recording.duration, 3/44100, "AbsTol", 1e-12);
end

function testPackageDefinitionAndIncludedAssets(testCase)
root = testCase.TestData.Root;
pkg = matlab.mpm.Package(fullfile(root, "toolbox"));
verifyEqual(testCase, pkg.Name, "ColorBeatsChallenge");
verifyEqual(testCase, string(pkg.Version), "1.0.1");
verifyEqual(testCase, pkg.ID, "8a0b4376-91af-4a0e-aecc-629571fea95c");
required = ["ColorBeatsChallenge_Student_Activity.m", "ColorBeatsApp.m", ...
    "openColorBeatsChallenge.m", "data/majorPianoScales.wav", ...
    "doc/GettingStarted.m", "doc/Color Beats Challenge Activity Guide.pdf", ...
    "prepareColorBeatsRecording.m", "LICENSE"];
for file = required
    verifyTrue(testCase, isfile(fullfile(root, "toolbox", file)), file);
end
verifyFalse(testCase, isfolder(fullfile(root, "toolbox", "tests")));
verifyFalse(testCase, isfolder(fullfile(root, "toolbox", "buildUtilities")));
end

function testSpectrogramWorksWithoutSignalProcessingToolbox(testCase)
root = testCase.TestData.Root;
stubFixture = matlab.unittest.fixtures.TemporaryFolderFixture;
testCase.applyFixture(stubFixture);
stubFile = fullfile(stubFixture.Folder, "spectrogram.m");
fileID = fopen(stubFile, "w");
fileCleanup = onCleanup(@() fclose(fileID));
fprintf(fileID, "function varargout = spectrogram(varargin)\n" + ...
    "error('ColorBeatsTest:ToolboxUnavailable','Toolbox unavailable');\nend\n");
delete(fileCleanup);
testCase.applyFixture(matlab.unittest.fixtures.PathFixture(stubFixture.Folder));
testCase.applyFixture(matlab.unittest.fixtures.PathFixture(fullfile(root, "toolbox")));
previousFigures = findall(groot, "Type", "figure");
testCase.addTeardown(@() closeNewFigures(previousFigures));
run(fullfile(root, "toolbox", "ColorBeatsChallenge_Student_Activity.m"));
spectrogramImage = findobj(gcf, "Type", "image");
verifyNumElements(testCase, spectrogramImage, 1);
verifyGreaterThan(testCase, size(spectrogramImage.CData, 1), 100);
verifyTrue(testCase, all(isfinite(spectrogramImage.CData(:))));
axesHandle = gca;
verifyEqual(testCase, string(axesHandle.Title.String), "Your sound as a spectrogram");
end

function closeNewFigures(previousFigures)
figures = findall(groot, "Type", "figure");
delete(figures(~ismember(figures, previousFigures)));
end
