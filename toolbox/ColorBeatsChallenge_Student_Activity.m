%[text] # Color Beats Challenge - See Your Voice
%[text] In the Bright Beats Challenge, you turned **light into sound**. You built a micro:bit device that "read" a picture and sang it to you. This activity runs the challenge **backwards**: you will turn **sound into light**.
%[text] Here is the big idea. Every sound is a wiggle in the air. Fast wiggles sound high. Slow wiggles sound low. Light works the same way: fast light waves look violet, slow light waves look red. So we can give every sound the color of the light that wiggles at the same speed. Your voice becomes a painting.
%[text] By the end, you will have turned a sound into a picture. Start with the included piano scales, or record your own voice.
%[text:tableOfContents]{"heading":"Contents"}
%[text] **No microphone? No problem!** The activity starts with a sample of ascending and descending major piano scales made in MATLAB. You can also record with a computer microphone or a connected phone or tablet running MATLAB Mobile.
%[text] By default, the lines of code underlying these activities have been hidden. However, if you'd like to peek under the hood and understand how each of these activities have been enabled by programming, you can toggle between different views using these buttons on the right hand toolstrip:
%[text] ![](text:image:366a)
%%
%[text] ## Get Started: choose your sound
%[text] Start with **Sample audio** to use the included piano scales. You do not need a microphone. Press **Choose audio source** below before continuing.
%[text] To use your own voice instead, select **Computer** or **Mobile device** from the Audio source menu, then press **Choose audio source** again. MATLAB will ask you to choose a microphone when you select Computer.
%[text] If you are using MATLAB Mobile, follow the instructions below first:
%[text] 1. In MATLAB Mobile, tap the **menu**, then **Sensors**, then **More**.
%[text] 2. Turn on **Sensor Access**.
%[text] 3. Turn on **Microphone**.
%[text] 4. Come back here and run this section. \
  %[control:button:729f]{"position":[1,2]}
audioSource = "Sample audio"; %[control:dropdown:audio_source]{"position":[15,29]}
switch audioSource
    case "Sample audio"
        disp("Piano sample selected. No microphone needed!")
    case "Mobile device"
        m = mobiledev;
        if ~m.Connected
            error("Couldn't reach the device. Turn on Sensor Access: menu -> Sensors -> More.")
        end
        m.MicrophoneEnabled = 1;
        disp("Mobile microphone is awake. You're ready to go!")
    case "Computer"
        m = choose_computer_microphone;
        disp("Computer microphone is ready: " + m.Name)
    otherwise
        error('Choose "Sample audio", "Computer", or "Mobile device".')
end
%%
%[text] ## Part 1: Build your color key
%[text] Before you paint anything, you need a **decoder ring**: a chart that tells you which pitch makes which color. Low pitches get warm colors, high pitches get cool colors.
%[text] Two numbers control the whole key. `minPitch` is the lowest pitch that gets a color, and it comes out **red**. `maxPitch` is the highest pitch that gets a color, and it comes out **violet**. Everything in between gets a rainbow color.
%[text] The starting numbers cover about three octaves, which is roughly the range of a singing voice from a low bass up to a high soprano.
minPitch = 130; %[control:slider:2b17]{"position":[12,15]}
maxPitch = 1050; %[control:slider:1ed5]{"position":[12,16]}
%[text] Now build the rainbow.
  %[control:button:009c]{"position":[1,2]}
build_the_rainbow(minPitch, maxPitch)
%[text] **Try it.** Each label shows a musical note and its exact frequency, like C3 and 130.81 Hz. Those are two names for the same thing: the note is what a musician calls it, the frequency is how many times per second the air wiggles.
%[text] **Reflect.** Slide `minPitch` up and `maxPitch` down so the key covers a narrow range. What happens to the rainbow? Now stretch them far apart. When would a narrow key be more useful than a wide one?
%%
%[text] ## Part 2: load or record a sound
%[text] Press **Load or record my sound!** below. With Sample audio selected, MATLAB reads the whole piano sample using `audioread`. The notes climb a C-major scale from C3 to C5, then come back down. Predict how the colors will change as the notes go up and down!
%[text] With Computer or Mobile device selected, choose a recording duration. You get a countdown, then MATLAB listens for that many seconds. Speak, sing, whistle, or hum. The duration setting applies only to a microphone recording.
recordSeconds = 10; %[control:editfield:30cf]{"position":[17,19]}
  %[control:button:255f]{"position":[1,2]}
if audioSource == "Sample audio"
    sampleFile = fullfile(fileparts(which("openColorBeatsChallenge")), ...
        "data", "majorPianoScales.wav");
    [audioData, sampleRate] = audioread(sampleFile);
    recording = prepareColorBeatsRecording(audioData, sampleRate);
    show_waveform(recording)
else
    recording = record_your_voice(m, recordSeconds);
end
%[text] **Reflect.** This sound is a list of numbers. Where the wiggle is tall, the sound was loud. Where it is flat, the sound was quiet. In the piano sample, can you find the spaces between notes?
%[text] **Listen (optional).** If you have speakers or headphones, click, 'Listen' below to hear the audio you just recorded or loaded. You can complete the activity without listening.
%%
  %[control:button:6370]{"position":[1,2]}
sound(recording.y, recording.fs)
%%
%[text] ## Part 3: Loud, quiet, clean, and messy
%[text] Now we chop your sound into short slices. Each slice becomes one colored stripe in your painting. A slice of sound is called a **frame**, the same way a tiny piece of a picture is called a pixel.
%[text] For every frame, MATLAB asks three questions, and each answer becomes one ingredient of the color:
%[text] - **How loud is it?** Loud makes the color **bright**, quiet makes it **dark**, and silence makes it **black**.
%[text] - **What pitch is it?** This picks the **color** off your key from Part 1.
%[text] - **Is it a clean note or messy noise?** A whistle puts all its energy into one pitch, so it comes out **vivid**. A "shhhh" spreads energy over every pitch at once, so it comes out **washed-out white**. \
%[text] `frameTime` sets how much sound goes into each stripe. `silenceLevel` sets how quiet counts as silence.
frameTime    = 0.05; % how much sound goes into each stripe %[control:slider:923e]{"position":[16,20]}
silenceLevel = 0.05; % how quiet counts as silence %[control:slider:7682]{"position":[16,20]}
  %[control:button:1f3b]{"position":[1,2]}
painting = paint_the_sound(recording, minPitch, maxPitch, frameTime, silenceLevel);
%[text] **There it is: your sound as a picture.** Read it left to right, like a sentence.
%[text] **Try it.** Turn `frameTime` all the way down, then all the way up. Small frames give you thin stripes and lots of detail. Big frames give you wide stripes and a blurry summary. Is there such a thing as too much detail?
%[text] **Try it.** Turn `silenceLevel` up until parts of your painting go black. You just told MATLAB "anything quieter than this is nothing." Where should that line be?
%[text] **Using Sample audio?** The recording challenges below are optional. Instead, compare the colors on the way up the piano scale with the colors on the way down. Can you find matching notes? You can also change the sliders to make a new picture from the same sample.
%[text] **Challenge.** Switch to a microphone in Get Started and record again in Part 2, but this time make one long low hum, then one long high whistle. Predict the two colors **before** you look. Were you right?
%[text] **Challenge**. Record again in Part 2, but this time try to make a rainbow. Slide your voice from your lowest hum to your highest whistle. Can you get red to violet in one breath?
%[text] **Challenge**. Record again in Part 2, but this time paint it black. Can you create a black strip in the **middle** of your recording?
%[text] **Challenge**. Record again in Part 2, but this challenge a friend to hit a target color. Someone picks a color. You find the pitch that paints it. Closest match wins!
%%
%[text] ## Part 4: What did you make?
%[text] The painting tells you the story of your sound, but every stripe is hiding a number. This last plot shows the **pitch** behind each color, so you can see exactly which notes your voice hit. Then MATLAB prints a short summary of what you recorded.
  %[control:button:71be]{"position":[1,2]}
show_pitch_scatter(painting)
summarize_your_sound(painting)
%[text] **Challenge.** Record two very different sounds (like a hum and a whistle) and compare their scatter plots. Do the dots cluster where you expect? What does that tell you about your voice?
%%
%[text] ## Part 5: A different kind of painting
%[text] In Part 3, MATLAB gave each moment **one** color based on the strongest pitch. But most real sounds have several pitches happening at the same time. When you say "ahhh," your voice makes a low pitch **and** a whole stack of higher pitches on top of it. Those extras are called **harmonics**, and they are what makes your voice sound different from a violin, even when you sing the same note.
%[text] A **spectrogram** shows all of it at once. Time runs left to right. Pitch runs bottom (low) to top (high). Bright color means loud, dark color means quiet. Think of it as an X-ray of your voice.
%[text] `minFreq` and `maxFreq` set the pitch range you want to see. Notice `maxFreq` goes way past singing range, up to 4000 Hz, so you can see harmonics too.
minFreq        = 80; % bottom of the pitch range you want to see %[control:slider:015a]{"position":[18,20]}
maxFreq        = 4000; % top of the pitch range you want to see %[control:slider:8767]{"position":[18,22]}
windowTime     = 0.05;  % seconds, the time slice used to make the spectrogram.  %[control:slider:2347]{"position":[18,22]}
% A smaller windowTime gives better time detail while a bigger window gives better frequency detail.
overlapPercent = 75; % Percent overlap between time slices.  %[control:slider:7ed7]{"position":[18,20]}
% If overlapPercent = 0, slices touch but don't overlap. If overlapPercent
% = 50, each new slice starts halfway through the previous one. More
% overlap gives smoother time changes in the spectrogram but requires more
% computation; less overlap is faster but can miss fast changes.
  %[control:button:7f95]{"position":[1,2]}
show_spectrogram(recording, minFreq, maxFreq, windowTime, overlapPercent)
%[text] **Reflect.** Do you see stripes stacked on top of each other? Those are harmonics -- the extra pitches hiding inside every real sound. A whistle is close to a pure note, so it makes **one** stripe. Talking makes a whole ladder of stripes.
%[text] **Reflect.** Turn `windowTime` up and down. Small windows show sharp changes in time but blurry pitch. Big windows show sharp pitch but blurry time. You cannot have both -- this is a real puzzle scientists deal with when they study sound.
%[text] **Challenge**. Holding a steady pitch (by singing one note) appears as a horizontal line in the spectrogram. Making short, sharp sounds (like claps, short whistles, or pops appears as a vertical line. Gliding your voice up and down smoothly can create diagonal streaks. Can you **make the following shapes** by recording different sounds? Hint: you may need a friend for some of these!
%[text] 1. Rectangle
%[text] 2. Triangle
%[text] 3. House
%[text] 4. Staircase \
%%
%[text] ## Summary
%[text] Nice work. Here is what you did:
%[text] - Sound and light are both waves, so a pitch can be matched to a color by how fast it wiggles.
%[text] - A microphone or an audio file gives MATLAB a list of numbers that describe a sound.
%[text] - Chopping a signal into frames lets you see how it changes over time instead of all at once.
%[text] - One color carries three separate measurements at the same time: pitch, loudness, and purity.
%[text] - In the Bright Beats Challenge you turned light into sound. Here you turned sound into light. The same idea runs both directions. \
%%
%[text] ## Future Learning
%[text] - New to MATLAB? Try [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted)
%[text] - Learn more about sound and audio signals: [Bytes and Beats](https://www.mathworks.com/academia/courseware/bytes-and-beats.html)
%[text] - Learn more about images: [Pixels to Pictures](https://www.mathworks.com/academia/courseware/pixels-to-pictures.html)
%[text] - Learn more about signals: [Signal Processing Onramp](https://matlabacademy.mathworks.com/details/signal-processing-onramp/signalprocessing) \
%%
%[text] ## Optional: try the Color Beats App
%[text] On a computer using MATLAB Desktop or MATLAB Online in a browser, you can explore the same ideas in a separate app. Click [Open the Color Beats App](matlab:ColorBeatsApp). Choose **Demo Sound** for the same piano scales, or **Record** for a microphone.
%[text] You can also type `ColorBeatsApp` in the Command Window. The app window is not supported in MATLAB Mobile; use this student activity instead.
%%
%[text] ## Helper functions (leave these alone)
function build_the_rainbow(minPitch, maxPitch)
% We use log2 because your ears hear pitch in octaves:
% doubling a frequency always sounds like "one step up," whether you start low or high.
% So the colors should step up the same way.
keyFreq = logspace(log10(minPitch), log10(maxPitch), 400);
keyHue  = 0.8 * (log2(keyFreq) - log2(minPitch)) / (log2(maxPitch) - log2(minPitch));
hsvKey = zeros(1, numel(keyFreq), 3);
hsvKey(1,:,1) = keyHue;
hsvKey(1,:,2) = 1;
hsvKey(1,:,3) = 1;
image([1 numel(keyFreq)], [0 1], repmat(hsv2rgb(hsvKey), 60, 1, 1))
set(gca, "YTick", [])
numLabels   = 7;
targetFreqs = logspace(log10(minPitch), log10(maxPitch), numLabels);
noteFreqs   = zeros(1, numLabels);
notes       = strings(1, numLabels);
for k = 1:numLabels
    [notes(k), noteFreqs(k)] = freq2note(targetFreqs(k));
end
xTicks = interp1(keyFreq, 1:numel(keyFreq), noteFreqs, "linear", "extrap");
xTicks = min(max(xTicks, 1), numel(keyFreq));   % keep end labels on the chart
set(gca, "XTick", xTicks, "XTickLabel", compose("%s (%.2f Hz)", notes', noteFreqs'))
title("Your Color Key: low pitch = red, high pitch = violet")
xlabel("Pitch (musical note)")
end
function mic = choose_computer_microphone
% Let desktop MATLAB users choose an input device from the computer.
    info = audiodevinfo;
    inputDevices = info.input;
    if isempty(inputDevices)
        error("MATLAB did not find any computer microphones. Check your system audio settings.")
    end
    deviceNames = string({inputDevices.Name});
    if usejava("desktop")
        [whichDevice, ok] = listdlg("PromptString", "Choose a computer microphone:", ...
            "SelectionMode", "single", "ListString", cellstr(deviceNames), ...
            "Name", "Choose Microphone", "ListSize", [360 180]);
        if ~ok
            error("No microphone was selected.")
        end
    else
        disp("Available computer microphones:")
        for k = 1:numel(deviceNames)
            fprintf("%d: %s\n", k, deviceNames(k))
        end
        whichDevice = input("Type the number of the microphone to use: ");
        if isempty(whichDevice) || whichDevice < 1 || whichDevice > numel(deviceNames)
            error("Choose a number from 1 to %d.", numel(deviceNames))
        end
    end
    mic.Type = "Computer";
    mic.Name = deviceNames(whichDevice);
    mic.DeviceID = inputDevices(whichDevice).ID;
    mic.SampleRate = 44100;
end
function recording = record_your_voice(m, recordSeconds)
% Countdown, record from the mic, plot the raw waveform, and return a
% struct with the audio data for later steps.
    disp("Get ready to make a sound!")
    for count = 3:-1:1
        disp("   " + count + "...")
        pause(1)
    end
    disp("GO! Speak, sing, whistle, or hum!")
    if isstruct(m) && isfield(m, "Type") && m.Type == "Computer"
        recorder = audiorecorder(m.SampleRate, 16, 1, m.DeviceID);
        recordblocking(recorder, recordSeconds);
        fs = m.SampleRate;
        audioData = getaudiodata(recorder);
    else
        m.Logging = 0;
        discardlogs(m);
        cleanup = onCleanup(@() stop_mobile_recording(m));
        m.MicrophoneEnabled = 1;
        m.Logging = 1;
        pause(recordSeconds)
        m.Logging = 0;
        audioData = readAudio(m);
        fs = m.Microphone.SampleRate;
    end
    disp("Done recording.")
    recording = prepareColorBeatsRecording(audioData, fs);
    show_waveform(recording)
end
function stop_mobile_recording(m)
    m.Logging = 0;
    m.MicrophoneEnabled = 0;
end
function show_waveform(recording)
    plot((0:numel(recording.y)-1)/recording.fs, recording.y, "k")
    title("Your sound as a wiggle")
    xlabel("Time (s)")
    ylabel("Wiggle size")
    axis tight
    grid on
end
function painting = paint_the_sound(recording, minPitch, maxPitch, frameTime, silenceLevel)
% Slice the sound into frames, measure loudness / pitch / purity of each,
% map those to HSV colors, draw the painting, and return everything Part 4 needs.
    y  = recording.y;
    fs = recording.fs;
    % Chop into frames.
    N         = round(frameTime * fs);
    numFrames = floor(numel(y) / N);
    frames    = reshape(y(1:numFrames*N), N, numFrames);
    frameTimes = (0:numFrames-1) * frameTime;
    % Loudness of each frame.
    loudness = sqrt(mean(frames.^2, 1));
    % Pitch and purity via FFT.
    window   = 0.5 - 0.5*cos(2*pi*(0:N-1)'/(N-1));
    spectrum = abs(fft(frames .* window));
    spectrum = spectrum(1:floor(N/2), :);
    freqAxis = (0:floor(N/2)-1)' * (fs/N);
    inRange  = freqAxis >= minPitch & freqAxis <= maxPitch;
    band     = spectrum(inRange, :);
    bandFreq = freqAxis(inRange);
    [peakStrength, whichRow] = max(band, [], 1);
    pitch  = reshape(bandFreq(whichRow), 1, []);
    purity = peakStrength ./ (sum(band, 1) + eps);
    % Map to HSV.
    hue        = 0.8 * clamp01(log2(pitch) - log2(minPitch), 0, log2(maxPitch) - log2(minPitch));
    saturation = clamp01(purity, 0.02, 0.15);
    sorted     = sort(loudness);
    loudRef    = sorted(max(1, ceil(0.95*numFrames)));
    brightness = clamp01(loudness / loudRef, 0, 1) .^ 0.4;
    % Silence gets painted black.
    isQuiet = loudness < silenceLevel * loudRef;
    brightness(isQuiet) = 0;
    saturation(isQuiet) = 0;
    pitch(isQuiet)      = NaN;
    % HSV -> RGB.
    hsvStrip = zeros(1, numFrames, 3);
    hsvStrip(1,:,1) = hue;
    hsvStrip(1,:,2) = saturation;
    hsvStrip(1,:,3) = brightness;
    rgbStrip = hsv2rgb(hsvStrip);
    % Draw the painting.
    image([0 recording.duration], [0 1], repmat(rgbStrip, 60, 1, 1))
    title("Your sound as a painting")
    xlabel("Time (s)")
    set(gca, "YTick", [])
    % Package everything Part 4 needs.
    painting.frameTimes = frameTimes;
    painting.pitch      = pitch;
    painting.hue        = hue;
    painting.rgbStrip   = rgbStrip;
    painting.isQuiet    = isQuiet;
    painting.duration   = recording.duration;
    painting.minPitch   = minPitch;
    painting.maxPitch   = maxPitch;
end
function show_pitch_scatter(painting)
% Show a scatter of pitch vs. time, colored to match the painting.
    scatter(painting.frameTimes, painting.pitch, 40, squeeze(painting.rgbStrip), ...
        "filled", "MarkerEdgeColor", [0.6 0.6 0.6])
    title("The pitch behind each color")
    xlabel("Time (s)")
    ylabel("Pitch (Hz)")
    xlim([0 painting.duration])
    ylim([painting.minPitch painting.maxPitch])
    grid on
end
function summarize_your_sound(painting)
% Print average pitch, dominant color, and how much time was silence.
    heard = ~painting.isQuiet;
    if any(heard)
        fprintf("Your average pitch was %.0f Hz.\n", mean(painting.pitch(heard), "omitnan"))
        fprintf("Your sound is mostly %s.\n", colorName(mean(painting.hue(heard))))
        fprintf("You were silent %.0f%% of the time.\n", 100*mean(painting.isQuiet))
    else
        disp("Everything was below the silence level. Record a little louder!")
    end
end
function show_spectrogram(recording, minFreq, maxFreq, windowTime, overlapPercent)
% Compute a spectrogram of the recording and display it.
% A spectrogram is a picture of how loud each pitch is at every moment in time.
% Time runs left to right. Pitch runs bottom (low) to top (high).
% Bright color = loud, dark color = quiet.
    [S, F, T] = compute_spectrogram(recording.y, recording.fs, windowTime, overlapPercent);
    % Convert to log-brightness so quiet details are visible.
    brightness = 20*log10(abs(S) + eps);
    top = max(brightness(:));
    brightness = max(brightness, top - 60);
    imagesc(T, F, brightness)
    axis xy
    ylim([minFreq maxFreq])
    colormap(turbo)
    colorbar
    if top - 60 < top
        clim([top - 60, top])
    end
    title("Your sound as a spectrogram")
    xlabel("Time (seconds)")
    ylabel("Pitch (Hz)")
end
function [S, F, T] = compute_spectrogram(y, fs, windowTime, overlapPercent)
% Use MATLAB's spectrogram function if it is available. Otherwise fall
% back to a base-MATLAB framed FFT so this works even without the
% Signal Processing Toolbox.
    y = y(:);
    nWindow = max(16, round(windowTime * fs));
    nWindow = min(nWindow, numel(y));
    nOverlap = min(max(round(nWindow * overlapPercent / 100), 0), nWindow - 1);
    window = 0.5 - 0.5*cos(2*pi*(0:nWindow-1)'/(nWindow-1));
    if exist("spectrogram", "file") == 2 || exist("spectrogram", "builtin") == 5
        try
            [S, F, T] = spectrogram(y, window, nOverlap, nWindow, fs);
            return
        catch
        end
    end
    % Fallback: framed FFT by hand.
    step = max(1, nWindow - nOverlap);
    starts = 1:step:(numel(y) - nWindow + 1);
    if isempty(starts)
        starts = 1;
        y = [y; zeros(nWindow - numel(y), 1)];
    end
    nFreq = floor(nWindow/2) + 1;
    S = zeros(nFreq, numel(starts));
    for k = 1:numel(starts)
        frame = y(starts(k):starts(k)+nWindow-1) .* window;
        X = fft(frame, nWindow);
        S(:, k) = X(1:nFreq);
    end
    F = (0:nFreq-1)' * (fs/nWindow);
    T = (starts - 1 + nWindow/2) / fs;
end
function [name, snappedFreq] = freq2note(f)
% Find the closest piano note to a frequency, tuned so A4 = 440 Hz.
    noteNames   = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
    midiNumber  = round(69 + 12*log2(f/440));
    snappedFreq = 440 * 2^((midiNumber-69)/12);
    octave      = floor(midiNumber/12) - 1;
    name        = sprintf("%s%d", noteNames(mod(midiNumber,12)+1), octave);
end
function out = clamp01(x, lo, hi)
% Squash x into the range 0 to 1, based on the low and high limits given.
    out = (x - lo) ./ (hi - lo);
    out = min(max(out, 0), 1);
end
function name = colorName(h)
% Give a plain-English color name to a hue value between 0 and 0.8.
    names = ["red","orange","yellow","green","teal","cyan","blue","violet"];
    idx   = min(8, max(1, floor(h/0.8 * 8) + 1));
    name  = names(idx);
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"hidecode","rightPanelPercent":40}
%---
%[text:image:366a]
%   data: {"align":"baseline","height":105,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAABD4AAAFgCAYAAABT67n1AAAAAXNSR0IArs4c6QAAAIRlWElmTU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAAFKAAAAAQAAAUoAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAABD6gAwAEAAAAAQAAAWAAAAAAJx+9EAAAAAlwSFlzAAAywAAAMsABKGRa2wAAQABJREFUeAHsvQmUJMd53xlV1dXV9zE999mDGYA4CRDgTUoGJFoUbVk2TVGSrcN4ls1dSct91tq72l0fpGxp7ef3tLQe17KXtC2aNFcrYy1799mSSIsiJEAUQREEAQxuYO776umZvuva\/z+7oqc6O+vOu\/7RLzqzIiPj+EXml5FffhFhjJwIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAIiIAI9BmBTJ\/VV9VdJ6B215XQK4FqrwnofBEQAU8Cks+eWBTYAQHJ5w5gKaoIiIAIiEB\/EFAHqz\/aeaOWn\/jEJ\/IDAwOFK1eu5Kanp83a2pqugQ060e8MDg5WFxcXq4VCoTo0NFRdWVnJcMuScX91dTWTz+ezvZa0WCxWbB71aTXLw5Ytm82Wz5w5s\/rkk0+W6s\/VvgiIQG8E6uXz6OhoqmWzWwZZWWdlEOvv1\/PJyq7JyckKW8jmZffxTMz6lVdvV0D3Z9s6Sj53z1BnioAIiIAIpJvAQLqrp9q5CGTQ4ZvIZDJT6AAO4iU6iw6f07lGp88VVT\/DJoCOq0GbVNmBRee1yjbBlsoppyjVajXD9iqXyxnGteGdlNOeh3SQXJV5bPoy6JUHz6Fj2aB0KePc1dnZ2TkE3XAO6J8IiIAfBDbJZygGUimfG8kgK+u4RRxHyUt5142cq28M5mflqpV3Ni\/Go8zD8UylUkmkoknyub61tS8CIiACIiACjQkk8kHfuDo60ojA448\/PoTO3jZ07g4izl74UXT4BqEEycJX6Rudq\/DgCUCZYWptkENubKshtJXTNsydnXO4MrZL8KuMizgd3b82D5xLi5EhpDOM7aY88LuC48vYruB4BT7DfLhFWBnHqIW5he05dLhPQxEy\/9nPfnYVYXIiIAJdEmgln7tMNnanQW5UIdcgThx5VsDvEeznGM7C1sJ53JFBCKLMc2RQN5VhXkwbPo90hrEdZHoM45ZpYn8N+8yP267z6qZ8fp1Tq8sm+Qy5fWZ4ePiG5LNflJVOvxD49Kc\/nT1\/\/nxubm6uoz5Wv\/Dxq56wOvd87wiCe5h5kQ\/z27t3bxnXkmNl6BczpdM7Ad3UvTOMfQof\/\/jHB2E2vBcdocPo5N2HzuBRdJS2oeBD+M1P\/7oxI25FtAMfAOzk82VgF\/Z3wNMiqwzP+5QKimUcv4j9a\/B8e6CSpG1Xl0ceJzH9XQijOYdtf+axhuvjEsKuYL+IbQ75MJxl4O9l7F7F9nX4l3FNnZyfn7\/wxBNPsJxyIiACHRLoN\/kM+UFZQeXrDPZ3Q75QAUsZRBlImcYhdFcQfgnHqVSlDOq2r0JFLk6vjmK7B9tpbJkWZS3EV5bKlpvwFxB8E+H83ZFc5TkRO1ZJ8jniRlD26SEAmTyMF9dRWIgN0PqsVCo58oeWsumpZfg1qeeIfmaFlnhupoyTy+UomzeGdLvjtFNymxfjMi98+Kt4pcO8YAmfZTszrlcchrdyNj9aFTINZFmEZf2CFM+tyIV\/3Gno8LNVjmERePTRRweOHj3KzuXb4O9Fvg9iexe20\/AFeHYqna9i2JeLjgAfqFRmUBGxG0KYXyfZCecXSadUtNiAcJ3Dbyo++PLQTQedHf4BpLETwnm81vF30mc+ENbM4xbiXMZvvoA4Lx3Y59tDCRtam1zF\/qs49jy2LyOd1\/fv339Fmm0Ho\/6JQNsE+lQ+O7ILsmMGsmMaHU+HF347so5bdB5pgXERsoYWZuwAd9VXQVpW8TGGtPZArjqdaZsXM8aQIsrZi\/CO4gPxNjrcPB53h3KjyOvyGfJ8BeW9hjDJ57g3nMoXSwJUekxMTOxEP2g7CjgET4u0DcvYWBY6QYWCjKJSwLEiJld30SnKcNx5J7Fx3XHa\/W3Pp4zEvpOn+1wcc54RNq77eCe\/mQ\/TQ1oleH4kvIK+8WX0jfkck4sJga46EzEpu4rRgsAnP\/nJwtLS0m5Eo4XHg9g+gO392B6CH4Hny7auAUCIgWNb0PMtYBgvA5CZ64oPlo37VErAUxnBzi2a0rHE4OF2nc2DDxvmwYe5o1xhAnafmnH85IsHt7w+7DXChxHjLyDsOPwx\/H4BZaI\/jklYL3\/uc5+jVYicCIhACwJ9LJ+tXOGQvgF4LxlEWUUZRCVJvQxqQXXLYSvz8pBVzG9DzjEm5RkVypBptCyxssvKuy2JxTxA8jnmDaTixZcAZEDm537u56bw9X8P5AL7zAdR2klsnQ+ECEM3h6JLrlsCYEgzO3Kk1fEk9ifAl31eZ1g1jtPR6pjzx3FINZUgW5Qj7ebPvNiuiE+LvylsOcTbUapgn+myQW\/B36jlm63FR1Bnjs8WnMs+te2jM82TKP+bULizbzzfWYqKHRQBTW4aFNmI0+UYxbNnz+7ATXcERbkP\/u3wtPi4AzfjNt6kOIafcnEjAOHpdMYblIvWGmM8hm2DKK2DW+RB4T3qlUrtuhmzDwemg7ilmmkfBT6HyciJgAg0ISD57GhurTLXixTESobKed9cM5mHvPhyQ59oJ\/mc6OZT4SMk8DM\/8zNj6BPvxz1Ei+gHIRPuhMzgcLxhbPmuRMuACEuYiqypyKAym0O694IrP8w6Q7rxm3CpeFjC9hw8hzty3iIqRroCj\/NppUwFB4f274cfx2+++DgfGbFfRnk4rPsctku1uF0rWpAuy19EOkyLltF818rDgjEHS6I1DAmnMl8uYgJdXUwRl1nZtyDwC7\/wC8NYEnUHvmTdiZuZCo8HcBM+gO0sbsRp3IgUJBtf2bgvFy8CaCfPAqEdPcO7CewmD3aseR6uK34dvQ5\/HP4FlOtFhL2A429hPplrGtfYTYvonH4gQPl87dq1HZgYuO\/lczcyqNtrpFFeTM9Pudpt+fw4T\/LZD4pKo58IUAn9xhtvjOHjzQFYwfIjIa2iOSScHw0n4TkPHj8GeXfKEEGubQJkSMUDLT624RnIyTw23kUoh2mBh+GHHCZCCwnGpSKi246vMzk20hpH27KNN+XFZwKUEgy7hjirtXbuNi+mw3OprKHChSsfvoYw9ouPwb8Ma6JzX\/rSlxYRLhchAVl8RAg\/iKyhVcyxU42b\/ChuPCo7HoKnpQeFOCd2k6UHQCTVQYgGXvRmefChRIfriKsk7MIuH0osFOR6ltpzZ+lI\/L4ALycCIlBHoF4+4\/6RfK5jU7\/bTAbVx\/NrP+z8\/Cq3Ox0P+cyOuOSzG5R+i0CNAJUeeAE\/hD7z3ei\/sL\/MD4V3Y0sLAc65xhdZbOR8IkB5RKBZzKPimSR40\/puxvNgh4G1tstSNrJ\/6uUQhwouZ6ig1\/F2w+quE86NR2shKni4n0P+FVxnGXz4OP2Zz3xGlh\/tQg0gnu7mAKBGlGQGners2NjYNivAcbNRiNPi4xD8DMJphtXw5o+o3Mo2gQSg5HC+kkKYU7NNk8QTqMbzNf9d\/H5tdnb2Jr6m8CFHLycC\/UxA8rmfWz\/kuks+hwxc2SWRAOf0GIV19CH0Ye7FPcM58B7CPhcC2I\/+sjPUDvubrASCrCjzQv5BZhGLtFlPOrt1F4oM3Bx6YcNzm+XF\/N35ucvU6rdNn+lQ\/lLJAs\/5Q07Dv4Lw5xDnJfjXcPzcwYMHF9E\/9tbEtMpMx3si4Ax56CkFnRwLAo9i9ZadO3fSnGsvbjZqrB9Bwbi9E1tqHjkzU8ObPxaVUCESQ4BCnh6XFZVp4yg4x2xa648FaLZvXrp0ae3uu+8uvfzyy1J8JKZlVdAgCHjI54eRj+RzELCVpiObJZ91IYhAYwL4UDiMoQ934CWUFtHvgOdHwnvgaemxofTAvlwABCifwnKt8kLf1dei1OVHiyHOl0cLFr5vc5QF5+nLXr169cYLL7xgJ9RGsFxYBDTUJSzSAeezY8eOLIR4AcqNcdx0O3Fj7UWWu\/B7Ci+hDSfL5A0qhUjAjZPw5PlQoAbb6+HAMCjbuATuNK6lPagqJ3Tajt9jCM9fuXLF3ydKwlmq+P1JwEM+7wMJyef+vBx8rbXks684lVifEIB1NJe4vgtWq5zT437s09JjH\/otnMxUltERXwdsg7BcUHmh38z+7yjesahM47geri42gt8jmAuPliCa7wMQwnZSfIRNPMD8MHEOlR\/UJvLGsl\/hsVvZYtmDOM5XIY574+Q+iBNgyZR0kglQsYHluAwuLaca9Q8JVweBS4WN49oahsBn5Cy+dJsnn3zSOU\/\/RKCfCdTLZ9wnXBmJVlKSz\/18UfhQd8lnHyAqib4jANm7DcKXVh4Pwt8DecwPN47SA\/t9x0MV9p8AryO+a8HR6uMAPC2JdsBPoj\/wFLaX4eVCJiDFR8jAg8wOL6fsRefgqVW0plW497YKccRxijI8PGympqY8X2qDLKvSjj+BmsDmDNucsNTZstQ23Nagdn3xOqPSbZDXHxRqnNBJ1h4WkrZ9T0Dyue8vAV8BWDks+ewrViXWJwRw\/0yij\/I2VPcoPJex5YcbfQTsk\/YPo5q8nuhxrXEY+BT2+UF6N37ncb2NhVEG5bGVgBQfW5n0RQhnU2bHaffu3eahhx4yu3btcobD0AJETgRIgBYevEbOnj1rnnvuOXPuHJdWh60ehk7JiYAIBEdA8jk4tmlJWfI5LS2pekREgIqO7cibK3rQ+s55SfUqC\/vFlMn2g6FXHIX1NwEoMpy+MbdejtcXjsFALzeK62k39jn\/h1wEBKT4iAB6kFni5uKSTDTnoHdMPbwEOoU4TWS3b99u3v3ud5t9+zjkXE4EthLAcm\/mxIkT5tSpU44ipIHig9cd+hFY8D6brXArJdpWlgrpbwK8R0DAymjJ5\/6+HHypveSzLxiVSJ8RgBJjAN2UYchkvgeVsd\/wfYh9aOv7DJOq2yYBXh+NHK4tR6lmhyXCSm+MSpBG8RUeLIGGN3qw2Sr1qAnU34gc7iInAo0IDA0NOZObNjqucBEQAX8JSD77yzPNqUk+p7l1VbegCODFk0PD+Q7kvIBS5rqdtfCYnJw0WDXRjIyMOC+wXnHd5+p3fxDAdeRU9NatW+by5ctmYWHB+W3DvSjg+snj47O3aYjXCQrzlYAUH77iTE5iVnvNr\/KYZCc5BVdJQyfA68N2AELPXBmKQB8SkHzuw0bvssqSz12C02l9TaA2nNBa4DkWHW6FBufP4Qvs3r17zWOPPWYOHjzoDHlhuJwIkAAn\/ufzmpZ3X\/\/6183c3Jzzm+Fux+uL71y4fio4Z6umzX2CfgdCQIqPQLAmK1G3sE9W6VXaoAno+giasNIXgcYEdP81ZqMjGDfl8aVaXERABJoTgELDUXogVsMXUL6k8qV2fHzcHDlyxMzMzDRPVEf7lgAVac8884zzkZDXTCPHj4iQ2RoK3ghQCOEytQkBsrIQAREQAREQAREQAREQARFIFgEqF2X1mqw2C7u0NYVG2Nkqvy4ISPHRBTSdIgIiIAIiIAIiIAIiIAIikE4C9ss9X2rX1tbSWUnVyhcCvD46sb7jqlxy0RCQ4iMa7spVBERABERABERABERABERABERABEQgBAJSfIQAWVmIgAiIgAiIgAiIgAiIgAiIgAiIgAhEQ0CKj2i4Jy7XTky4wqxcXMsVJgPlJQIi0N8E4ioH\/SxXP87h2Y917u87WbUXAREQAREIkoAUH0HSTVHadqxj3KoU13LFjZPKIwIikF4CcZWDfparyUT5qW3YfqxzahtTFRMBERABEYicgGZXibwJklOA0sqKufr6a2b+9ClTwdJNuXw+1MLz61elVDS5wYKZvuMOM3PkqMmGXIZQK6zMREAERKBNAv0gn0uVqnnzWtGcuL5mVktVk89lTOOFA9sEF5NoXFOzWK6awkDGHN42aI7M5E0+m5baxQSyiiECIiACItDXBKT46Ovm76zyq7dumbf+61fN67\/zn01xackMjo1hjfPO0ugldpUzay8smqGpKXPfxz5uJg8cMINSfPSCVOeKgAikhMAa5PPx37fyeRnyeRQ1C09AV6vr8nkY8vnej\/1IIPKZyo6nTy6Z3z52y9xYqZjRwaxJi24AOh2zuFYxU0NZ85fvHzcHJidMfjC89kvJbaBqiEBkBDi0z08rN78qEtdy+VU\/pSMCnRCQ4qMTWn0et1Ismptnz5hLz3\/XrC4smKHJyTD71aZarpjVm\/NmZPsOc\/ADH8Tvcp+3iKovAiIgAusEypDP82fOmIvfjV4+H3j\/BwKRz1QOXLhVMi9cXDVXF8tmEkqCbJja9wAvtgpemuahzNk+mjPvOzRs8LiTEwERSBABKj2oZCivrppyEcvf0owrCt0lzaMzWVhHD5oB+DgqYxLUrCpqyghI8ZGyBg20OhDqHFoyMDRkKuUStgUI1\/CkOhUfZayVzfyzzhrY4eUdKFclLgIiIAK9EugT+TwAE48hDAcZzmecYSG5EJ9BvTZRs\/MxysWpE+vGOkbywtSsgDomAiLQksAaPgqe\/uOnzEV8IHT6q4WhUO9lR\/GysmryoyNm3zvfZfa\/9\/1moIC+upwIiIBDQIoPXQhtE2D\/MgeFQw6KhwEqPhyBHp7ygUNd1h8khXXFR3hZt81IEUVABEQgCgL9IJ8p8qkUKAxkofyowqdpqEsGc3wYp26sox5vUdxFylMEeiNQXFyE4uNp89ITv2XWsF8YHw\/3AyH6yRyWPrJtxqnInoffKcVHb02qs1NGQIqPlDWoqiMCIiACIiACIiACIiACIhAugfW56BbM4tWrmJPuljPsJVTLaCo+MCQcY24MlTAGcy\/JiYAI3CYgxcdtFtoTAREQAREQAREQAREQAREQgY4JZGCtxeHYtPTIZLNmcGIi1Dk27Nx3zJ\/W2WEqXTqGpRNEIAICUnxEAF1ZioAIiIAIiIAIiIAIiIAIpIsAJxPN5HImm8NQPCg\/wlY+UOHi+JTMf5Suq0O1iZoA7kg5ERABERABERABERABERABERABERABEUgnAVl8pLNdA6kVV8iqlErOmMUSZo3ODa6Gqsnm2MkSlgkrYWUXlsNZKiyQmipRERABEUgWAS\/5HOYyhpUYymcyKeMft3RhTxhay9b54MvVZ\/QBdr0d9F8EREAEREAEoiAgxUcU1JOaJ3qP5WLRFJeX4Zeg+MijJuF1JR3FB\/ItIf9KEYoPaT6SeiWp3CIgAn4TkHzeIMqnEpUOFTApYZ1YKj\/Wn1ThPa\/WCwOlC3YcpUeutq2Vbf24\/ouACIiACIiACIRFQIqPsEinIJ9sPm\/G9+41u+6\/3xSXlszg2BhqFV5H0pkte3HBDE1Nm7HduzCGET1JOREQAREQASP5fPsiqFDbgEfTUD5rto3mnCVwHRWENcG4HTXYPZSBC9OWUKCltbJZgxIGOhhZfgRLXamLgAiIgAiIgCcBKT48sSjQi0ABio4jH\/oBM3PnXc5QE3a0w1N74AseeowVWJzkCgWz7chRrU3u1UgKEwER6EsCks+3m52KBiyuYHZNFczb942aHeN5U0ZYOeSVHTG3ocmhIFduFc3z5xbN6esrsEIxJp8L88l5m4v2REAEgiXAfiqHZHMp27WFBWg5MdFoiGPcqpWyWUXeA+gnl1EOGUYH295KPXkEpPhIXptFVuKB4WGz5x0POz6yQihjERABERCBLQQkn28joZKjCoXD1MiAuX\/vqLljex5WF8YUy7fjhLGXh1HiAJQfx68Wzem5VXPyGuYcQdmk+AiDvvIQgWgIOKu6wCKZVslRrOrCPLmqDDKPBoByFYEYE5DiI8aNE6eiUYsdpta63brHtVztll\/xREAERKBXAnGVg1GVy45oodUHlQwF9HRyUHyEbWcxiHyp+GAZWBaWy5at1zbX+SIgAvEjMDA0ZHbe\/4C58wc\/YkorKyY\/PBKq4KlCsco5+ArjE2b7XW8z2QG95sXvKlGJoiSgOyJK+gnKO45KD+KLa7kS1LQqqgiIQMIJxFUORlUuKjjoObRlFaYey0WDSU4N5tgIt6GZ\/wA+vLIM3LflCrcUyk0ERCAsAoWxcXP0Bz5s9r3r3Ybz0mVodRHiUBdOIsR8s7D4GJ7ZriHhYTW88kkMASk+EtNUKqgIiIAIiIAIiECnBPAuEImlhWPhIROPTptL8UUgkQRo4bY+yfQ+LASwLzZ1iMryLjYAVBARqCOgAWB1MLQrAiIgAiIgAiIgAiIgAiIgAp0QoEVXHF1cyxVHVipT+glI8ZH+NlYNRUAEREAEREAEREAEREAEgiIQ5pCWTuoQ13J1UgfFFQGfCEjx4RNIJSMCIiACIiACIiACIiACIiACIiACIhA\/AlJ8xK9NVCIREAEREAEREAEREAEREAEREAEREAGfCEjx4RNIJXObACdSiqNjueJatjjyUplEQATSRyCuMlDyOX3XmmokAiIgAiIgAnEioFVd4tQaKSlLVEsYtsIX13K1KreOi4AIiIBfBOIqB+NaLr+4Kx0REAEREAEREIFoCUjxES3\/VOd+8eJFc+rUKbO4uGhyWFM8y\/XMQ3Tlctmx8Ni2bZuZnZ01k5OTIeaurERABEQgvgQkn+PbNiqZCIiACIiACIiA\/wSk+PCfqVKsETh9+rT56le\/as6fP28GBwfNwEC4l9va2pqj+LjnnnvMxMSEFB+6MkVABESgRkDyWZeCCIiACIhAJwQ4JDGO1nlxLVcnbBU3HALhvomGUyflEhMCtPSg0oNWH0NDQyafz4dasuXlZUfxMTMzY1ZXV0PNW5mJgAiIQJwJSD7HuXVUNhEQARGIHwEqPahkKBaLjo9K4WDz5QdVfliNozImfq2nEpGAFB+6DgIjwOEtFEhUehQKhdAVHxSMlUrFyVdCMbBmVsIiIAIJJOCWz2Fb5Ek+J\/CiUZFFQAT6nkCpVDKvvPKKee2118zKykokfWxadPNj6pEjR8z9999vRkZG+r5dBKA9AlJ8tMdJsbogQGUDO9MUTtyG3bFmfuxccyvFRxcNqFNEQARSS8Atn8O2yLNzMEk+p\/YSU8VEQARSSICKjzfeeMP8\/u\/\/vrl165YZHh4OdQ4\/9utp0c2PqrTmvvPOO6X4SOF1FlSVpPgIiqzSFQEREAEREAEREAEREAERiCOBMl6iK1ACV+NYuLiWiYoHKhyo9Lh586ahIiTMxQuY\/9LSkqHVBy1OaNktJwLtEpDio11SiicCIiACIiACIiACIiACIiACfUqA1oK0EOTwEio9uI3CqpoWH5rfo08vwh6qLcVHD\/B0qgiIgAiIgAiIgAiIgAiIQHII4EV9AJYDU9iOotRZWhHQy7VHgIoOelp62G17Z\/Yei+3EfG3ezF9OBNolkG03ouKJgAiIgAiIgAiIgAiIgAiIQJIJ4OV5GOXfj5fnCWxzUnokuTVVdhFon4AsPtpnpZgdEuC4Oy55ZZeSDfvBwvF\/zJNlCDvvDlEpugiIgAiESkDyOVTcykwERCBeBPIozhQnV1YfMV4No9KIQJAEpPgIkm6fp82ONcf\/8aFCk7SwnX2YsQxSfIRNX\/mJgAjEmYDkc5xbR2UTAREQAREQARHwm4AUH34TVXobBCYmJszs7Kyz5BQnIMrlchvHwtixFh\/79+93yhBGnspDBERABJJAQPI5Ca2kMoqACARBAPNC4HtYtYy0w+2YBlEZpSkCItA2ASk+2kaliJ0SoNLjIx\/5iLPetp2EqNM0eonPL5q09JicnDTbt2\/vJSmdKwIiIAKpIiD5nKrmVGVEQAQ6IIC+IWfElNKjA2Y2qv2QyUlF2cdu5OzxcrnsWH9z22wiUqbFdwWuGMMPpfZ8r\/RtvozP8gTpmFezcgeZt9L2n4AUH\/4zVYo1AjMzM4ZeTgREQAREIF4EJJ\/j1R4qjQiIQOgE+NauJUE6xE5FgFU8NDvVxqHSoN3h7vUKBnt+szx4jB85g3T1ZQoyH6UdDgEpPsLh3Fe5UFjFUVDEtVx9dXGosiIgApESiKscjGu5Im0sZS4CIhAIAfRR1yBzrmMuuBnKHr8c55S7fv26uXXrlvNC3u4Lv1\/5B5kO61IoFMyNGzecOpKbtczwytdaeExNTZndu3eb0dFRR2Hipahg2vTLy8vm0qVL5tq1aw4\/ryHyfL+w4SzLm2++aXbt2uXMJ0j+vTqWj+nTWnx6erptpU2v+er8cAhI8REO577KJY5KDzZAXMvVVxeHKisCIhApgbjKwbiWK9LGUuYiIAKBEMBL+QpetM\/i5Z3DXcYhf3xZ0parGL7++uuO5wT7QQ\/DCAROg0Qpo7kKzsrKijlz5oyjxOCwlEaOSggqM\/bu3Wu+7\/u+zxw6dGhjwQP3OUyXrC5evGi+\/vWvm6tXr24sjOD1bGB8hlNJ8q1vfctRqlDR4qVUcefV7DeVOZwfcHh42Nx3331mfHw8VW3YrO79ckyKjxS2NG78KoRNGTdwFYLBP1V2ClmpSiIgAiIQJgGI5QrkckXyOUzqyksEREAEbhPAF\/0i+so3EbIMeTwK78z3Abl8O1IXe3z5psXH6dOnDZUgQ0NDXaQSz1PAyFFkUKFx8+ZNR\/FBxQbDvZy1+BgbGzOHDx9ua+g74z733HNOcjy\/kbP5LiwsmHPnzjnKCSo9em0\/nk\/FDq1T9u3b17MipVH5FR4dASk+omMfRs69SfAwSqg8REAERKDPCFDpgSpLPvdZu6u6IiAC8SAAEcy39Sy891t7D8XkSzk9h0vYIRk9JBebU63igwoGq3hop3B83DVTYtSnQaUK02\/HMV1bJlue9UdrO2d7x+H5tt0aKXS8z1RoUghI8ZGUlmqjnDDPqsL8KwMBMIybdxI37QhOy\/JG7lUYtJG9ooiACIiACDQgIPncAIyCRUAERCACAugjW8WHb8oPvizzxZlDQNjvbjYUJIIq95Ql60YFA53dNnu3YHw6KjI47Kcdx3hW8WHP9zqP+drykDGHyfC8ZuXxSscdxvOppGGabMdmZXCfq9\/JILB+BSejrCplCwIwqaMJNRUd04i6H4JpEltfxi22yFqHRUAEREAEmhCol8+Q05LPTVjpkAiIgAiIgAiIgAj4TUAWH34TjSg9zDxchaYUCk\/qPjIj8NOc\/Ifa0141oBFVSdmKgAiIQCoIuOUzKiX5HELL8oMjvzlm8Y++9gEyhJzXs9jIFz\/Dzju0SiojERABERABEUgIASk+EtJQaS4mFTNQ1MSuinEtV+xAqUAiIAKREoirrIqqXHYCFSoeCvmsGR40poR58nIh27gOYrrEAXiWgWWx5Yr0YlHmIiACIiACItCnBKT4SFHDY1Igzu9BJQJnBuJ0yM4s1XGvYr3Sgx3lqJ0tj91GXR7lLwIikHwC9fIZsoXy2bfnb72skgxdt\/KgKr1cqZrlYsUsrkLxgafiWuNFAgK5wIpUfEDZwjKwLCwTvZwIiIAIiIAIiED4BHzreIVfdOXoJoChLdXa5D5ZdIQTofSwdeCSVG+99Zazhjc77hymE6YjN05oxLW7Dx8+bA4ePBhLK5QwmSgvERAB\/wjUy2ek6rt85hJ8x48fd5b248z4lKH1ChH\/auKdEuU28+Ukc5SflKNhy3FbshzMK2hhcX2xZJ47s2BOX89j4jtMWheyYj0HS8YsCnJtseiUhWVyCmYLqq0IiEDqCNj+JPuU7a5mkgQIfJ5QzrNOUSvY7bPNlodlqr3\/9ISS6dn241YufQTCfbtMH78414imE4n5uHTr1i3zrW99yzz77LOO0Al77XMKTb44zMzMmA9\/+MPmwIEDob40xPlCUtlEQAT8JRBEp5Hy6\/nnnzff+MY3HFlGJa7tHPpbeu\/U2ElcXl424+Pj5rHHHjP79++PTPExkMs4D7\/LC0Vz4\/hNDHFZfxSGbU9oH8C09lgrY5lElCPk0TbejaVQERCBQAhQtlMBjFW8HG9XPwkks5AT5fOEnvWzyo8wnzHu6jJvPnfsijFk3+uzleevrq46zy5bR3e++p1sAlJ8JLv9Nko\/NzeXmZycZJ8K9211Eds5CKdtvQqBjQwC3qEgvXHjhmPxwf2REa7EG56jgGOnndvFxcWehWd4JVdOIiACcSfgls\/osF2HnJvxUz5Tds3Pz5sLFy44smx0dDRULKwLZSeeQ+bmzZuRylDnQYjar2F8y8IqvuChbHRWEeH8COGfVbTABNMMQhljFR82PIQiKAsREIEQCVDRMTY25nxEo\/KjUCiEqoAOuqpc4tUqdfjBknKfPmwFiM2XfKemphxrbSpBGN6LYxqsHz8c8D0k7Hr1Unad2x4BKT7a45SIWPjil4VpMZd1mcPNfxY3MM2px\/A79kvaUrhw3WxaerADH4XFBwUm8w3bRDwRF5cKKQIi0BOBevmMhCif+fz1TT7Xy1AWNGwZSvnJTiPzpSyP0tmu77rCgSUJW+WxtfYsC50t29YYChEBEUg6AQ71O3LkiKMAZl+WigLK5jQ4KnUo26nw+Pa3v22uXr3qWFtQ+dDKtcuA8WzcZkoMfiBlWXbu3Gne+c53OoomhpF5L455Mg2+B+zatSsyq8Ve6qBzmxOQ4qM5n0QdhcDN4KalW4bguIntErZc2tYZT47fsa0PBR0fEFbpwG2YjvkzzzQ9pMLkp7xEQASaE6iXz4h5E95X+UwZxo4p5VgUsoxKD5tvXMy7gcRwng05ERABEQiDABUfs7Ozjg8jvyjyoHX0mTNnnKypJOC7BZ8\/zVy77x+MZ+M2SpPHmS8VH9u3bzcPPPCA2bZtW7PsdUwENghouOkGivTsQChQAUIp1FwSpafKqokIiIAIJIIAZTMdCiv5nIgWUyFFQAREoDUBvpD3g6u3jG6nzlSK23k4WvFhvHasNmy+\/FgZtHWjzatV2XU8GQSk+EhGO3VUSnxtY7\/a+YcT1bnuiJ4ii4AIiEBwBCibkbrkc3CIlbIIiIAIhE5gXZ8derahZ8jJP9ux9CAPeiozuHIj585o5jhUhcNorJKkHZ4sB8sTpGunHEHmr7T9JRDueAJ\/y67UREAEREAEREAEREAEREAEREAEQiBACwhrBWG3XtlyyCOVBlRmcKl1Wmfs2bPHmf\/ErUzghNiXLl1y4mEycOc8e75X2gyrL0ejOAoXATcBKT7cRPRbBERABERABERABERABERABETAk0AzpQdPsHPmXbt2zTz33HPOqmMPP\/ywMzSlfngKLTyo9GCcN954w9nn+Zwzqpmz+dtts7g6JgKWQPOrysbSVgQCJkDBReFHkzWau4U9OZ41l6MpnjXhC7jKSl4EREAEfCNAGUrZSRmKFWQcGer+quZbZh4JcRw38+UM\/yxHEI4j6IvlqlkuVsziWgXLw6Zn8tIy2o91Gs7DNBx17I\/ZAoK4SpSmCLRNwN5mdtv2if0ekc+WVhYZ9jiXOeeEqHxGcOlZKj12797tLBnL59Xly5fNyZMnHaUHt3x+2PQbceZxq1gJ8znXqDwKTw4BKT6S01apLik77RSKVDpYH2aFbZ5SeoRJXXmJgAj4RcBLhobZIayX39wPylXwilLCv3UPc+dMOt5ZoOvYqBfrKCcCIhAcAcjGKuQU1z6thCkng6tRuClTqUHFA7d89tC7OdrfPMa+9fXr182LL77ozPfxjne8wxw6dMhcvHjRfOc733GGuFy5cmXT\/B72\/Pqa1efFvOnlRKATAlJ8dEJLcQMjwK+EBw4cMPfdd58jINtZF9zPwrCjTs3z9PS0sx64l8D1Mz+lJQIiIAJ+EuDSfhw\/fe+99zqyjF\/VwpRjlKG0+BgdHTW7du0KpENKC49DUwPmvQeGzfxKxYwMouObkum7qexYgsXH5FDWqWMuJfXy8xpXWiLgFwG8iHOC6TzSy8FzJUS\/kk59OnyuUM5zCVnKfSo1uPVSfhCGfQ7R8uPEiROO4oOWHyMjI+bUqVPm2LFj5vz58xuWHq0AUuEyNjbmWI9wK+VHK2I6Xk9Aio96GtqPjMDExIR53\/ve53TaKTzDFmTMk4Kba7Dv2LFjQ1BHBkQZi4AIiEAHBIaHh80jjzxi7rjjDqcjys5h2I4dYI7LnpmZMVTE+O0K0AZ8z+ERc8fMoDMchIoQrBvgdzaRpMfBLWUYyuRRx30TA6YwkI56RQJTmYpACwJ4GS\/A70a0afT\/cnw5Zz9QrjUBPlv4oZJWG2+99ZY5c+aMM4Fpfb\/dKjvqU2Mfm8NYbty4Yd58801HQc+5PTgHCIfC8Jz6NOrPZdvYfjo\/jO7fv9951vF5x367nAi0S0CKj3ZJKV6gBPh18uDBg4Hm0WniFLJewrvTdBRfBERABIIkQFlFRcO+ffscH2RenaTtpwzlK0kO5h2z03nHd1KOpMZlnaX+SGrrqdwxJzCE8u2F3MzzZZyySq49AlRuz87OOlYfVEJwqVpaTFPx7eVsP5pbes6lR8sPKj1oJUhvFfU2bn06bBt6KkUYjx9K77rrLkfxwrlCpPiop6X9VgSk+GhFSMcDJ+Bn5zjwwioDERABERABERABERCBxBLACzYnhxhsZGGQ2IqFUHAqJzjUhewOHz7sWHvw4yUVGVy61iopWBQvRQYVJFy+lkNfrBVIo\/cAhtPT0apx586dzkfSI0eOOEM7OdRFTgQ6ISDFRye0FDcQAl6CMZCMOkw0ruXqsBqKLgIikHICcZVVfparHy0f+rHOKb9VVb2YEIBswvt0tQKv2TG7bBNae9BSm0oPztnx7LPPmqWlpaaretlnApUZdvUvhtnw+qIwDj0dlSzM4\/777zf33HPPxqow9fG1LwLtEJDiox1KiiMCIiACIiACIiACIiACIiACIuAoIyYnJx3FB604uGoLlRnccs4OhnkpNIiOlh7WNYpDpQcVHrT0oNKD1iVHjx41sxhmw4lR5USgGwJSfHRDTeeIgAiIgAiIgAiIgAiIgAgkjgBeqmlQxZVdElf2uBWYlh+ca4OTnVJBwSVrOYdHsVjcUHy4OfO3teZw18eGUznCOT244MADDzxgOLyF81jRwkROBLolIMVHt+R0ngiIgAiIgAiIgAiIgAiIQKII4OW6gpfvNbxca0kQH1rOWn7QOoPzfNBz9RYqP1pNeuqVPS09OGkpJzLlcBoOb6GlB5UePCYnAt0SkOKjW3I6TwREQAREQAREQAREQAREIGkEVlDgC3gx3wslyABepjnpR9LqEJvy0oKDSglaZ9x3332GViBvvPGGOXXqlLOKC5UV1urDbt2FJ396WnpwlTIuWXvnnXc6lh60KNHwFjcx\/e6GgBQf3VDTOSIgAiIgAiLQBQF0+tC321gqWz3tLhjqFBEQARHohQBk8CrOvwB5PAy\/DfsDfCGnbJbrngBXe+E8HLTUoJufn3fm\/aDVRzO2PEZPBQmXy+X5d9xxh3n44Yed1VtoSSInAn4QkOLDD4p9kAafBXgmyKWMgNo1ZQ2q6sSeADp3nNWtxC072mE7di6jyLdVPVkuukZl60dZ1Y91bnWd6LgI+EEAc0fAsKBShNwpQ+ZUKXesDPIj\/X5Ng3NyUPnBZWc5J8fKyoo5efKkuXDhgjP8xcp3uyUncrfezhdy6NAhx9pj165dZnx8vF9xqt4BEJDiIwCoaUyS\/XN2S8sVmKFJIZ74Js6hQXMYJhnBe1fi2akCItAjgRzOH0THj9vQzatth5PmxPTscNqwHuvV1enMu94MulEiVlaVoTYqUyOQYif5nOLGVdViQQByD6LHkcGaMCKAFuGwl8NYhWVsbMxRXKyurm6s9MLs7HPHKjwYRqUJ5wrhfB6czJTDW6hEkRMBPwlI8eEnzZSntbRWMd8+u2Jeubxm1qD9KOTC\/1qZcsSBVo+vCmulqhnOZ8wDuwvm4X1DZlBtGChzJS4ClgA\/L+IFP4uO3iQ63LsRPo19vONG86Xx3Llz5vXXXzc3b950TIupfAjTcdlDOn4ZfNvb3ma2baO1eXO3Vq6a75xbMS9eRCe6WDWDAxmTlqeQ5HPzttdREQiAgBUfdhtAFv2ZpFVijA0XTLm4ahZv3jCFgay5eu2aWVxcNCVqsCG98fQzA+iHcv4OPgNo6XH3XUfNkdmDZnBYSo\/+vHqCrbUUH8HyTVXqC1B8\/OGJJfPbx26ZxbWqGS9wsqJUVTHVlangK+mt1YrZNpwzP\/GOSXPfroIUH6lucVUuLgSmp6ery8vLHNpCiTkFvweTt+X58s8vXlG4M2fOmK997WuGChCaF3NcdZiOJtCsO7\/scUK8dhUfz5xZMV9+bt5cXy47zyCsRxlmsQPLS\/I5MLRKWARCIUBRnhJx5Buv3OCQuWt2P2R1zuzbOWO++\/zz5viJk2ZhedXA3tBRfAzlc+bA7u3mwQcfNHfddZfZt3evGYiR0kPt6tvlEIuEwu3pxKLKKkS3BKignUNn89zNklnAC\/TEkBQf3bKM4jxYtZt5tNsKvpTeXOFEU1GUQnmKQH8SgGKhCqOPDCwr+NwthG1h4aZO0+O5uTlz5coVR\/HBWfTDdFbxYSe\/aydvyizKrvN4Bl1ZKptJKN9DNlRpp5hdxZF87gqbThKB2BCg0oNDwZeKFbMK69p+f2G2z7hyZdRUpg6Y\/A6oOiaumNLQvKms3QCskqnk8qZUmDCV8T0mv\/2wyUwfNDcyIya3st5B5XDMsJ1tN1pHD8NKRcqssFsg2Pyk+AiWb6pSz0KoD0EIjA1CEKBmY7T4SFUN010ZPpD5KGG7OSbiarx0N7hqFysCsO6g0oNlYk8O01RUOcdHZI6myByHTRPjKCw+7BAf5m07yO3AoOyiDFvFsBdu+VxKg5N8TkMrqg79TsCxjD6+5AzJo4waStFwvE7b1jFwrGkNylBgLMwPmktrB83CMIbKr75hhleumLX8lJkfOWpulg+Zi2dGzOTCKub6WB8GyfzwtaDTbHuKz9yotBrNZ817Dg6ZD86OOG3YU6I6OVYEpPiIVXPEvzDsZA7gn\/Up6XPGH7wPJWTHmu2Wg0+LebgPWJSECPQlAXZKqXCgAsRuwwTBfDnUpROlB583lF2UYfYZhN1UOMnnVDSjKtHnBDgX3jdPL5t\/\/wKHhFfMOC2j+5wJB7TQ5dAHzVd2m5HhvNmxcssMlJbNcmGnuTx8xCwUd5nnTuVM+fSCE5dzf0ThKIedIeEjOecD4XsODEvxEUVDBJinFB8BwlXSIiACIiACIkACtaEu3KXZhzOpKX\/IiYAIiIAIpIMAh0lw4uV5DMmj9cf6PBb9rvpA22ayUFZnsSjCkKnCymNo5ICpZgbMUmG7WRzcZhYxvGUVhh5Y591RiEc1FptzLc2vVFBWY1ZKXPUsHdelanGbgBQft1loTwREQAREQAQCIcChLlR+IPEi\/CrGLhcCyUiJioAIiIAIREKAIzuGMDcEJ\/+nNdoEJvWUWyewPuolY0qZIXMTio\/VwWlTzA2btdwILP8wnwaUDeuTfVNRFI2yiIoPOrbfUE7zezgwUvZPio+UNSirA8HBYWocJMdVBKSvJBQ5ERABEYiIACYRzYyOjmbL5XIVQzxuQEafLxaL+7DNY6hHZr2zF1HhlK0IiIAIiIBvBPjKziF59HzZj+YV3rfq+JpQFUDKZsCs5sdNCUqPSgbDW7KYWJusoHQgr2idbTc1XLTtEFzuUnwExzaylKHscEypUQBu5URABERABCImAAUH+sEZfFCq3sT2Iraj2G6Dd57DUn5E3EDKXgREQAREIFACVG5wmv0yHnuVLOZ5qmk6bHigmStxEQABKT5SdBnAdJouiy+K46jWTvhJ+Bw71FF0qsuYJYhL4CL3FFGOZ1Xw8uSMSeQXBjkREIFYE+CKLrTIK8NHJhxhfWK4pO3y8rLBc8Pwd5jOLme7trYW2POJZssYph1Y+u3yknxul5TiiYAIpJvA+iOvwu+yte7q+kSmkT0K041btdtCQIqPLUiSGTA9PV1FB7aCMeQ0m55GLfbl8\/khdmbDVnpQllkRRqWHo+BNJtbElHr9wSGlR2IaTAXtWwJ4Cc5CJnNy01hY5Nnng92G1TDMr94Hlq+TT2Cpt5Ww5HNbmBRJBESgTwjY9wT1WvukwWNUTSk+YtQYvRaltmpABhbVg0hrmMsFhv0Vj3XA50xnbOPUyICZHh7AklBZwy9vVhnSaz11\/m0CfHPi18SVYsVcXyqaxVXOIc7xpbfjaE8ERCA+BPCyj1t24wbd2Am7hNu2bTP33HOPmZmZMVCSc9WZUItgLT2OHDliMP+Jr3lzSUKCHcPEgttG8phsMOsoWTj5VZhO8jlM2spLBEQgOQTsIrfJKbFKmg4C4fZ00sEstrXgqgFQerB87N9xLHkkXxSL5arJ5zJm\/1TBvHt23MyM5k0JYRz6IucvgQFwzkHLcX5+1Txz4pZ5Y4Vm61VH2eRvTkpNBEQgTQRmZ2fN+Pi4M9yFipg6ZUwo1bTWHlR6bN++3dc8SxhjyVUCdo0PmvccHjd7JwvO84fPoTCd5HOYtJWXCCSHABWzlEbsF5fgbfc4Mk14ctB1XFIr9flBcAD\/2GeW618CUnykt+3tvR5qDdcFuYHio2qmYO1xdMew2TeVNWtcnzvsz22h1jyazPJYKQ0fM50vmi9fWHIeniH37aOpuHIVARHoigAVDlRyTExMOL6rRGJ+kiMD8TAaH8qZO7YPm6PbBwyM4kwx3GlM8ByUfI75paLiiUAkBGwHnbIY369kpRtCKwB16Ar+EKqlLDokIMVHh8DiHL021IVFpKUHx5BHWlwr2KnWRl9bc30E0RrkynTtNog8lKYIiIAIJJDAJtlIGekEhFgRK5ftNsSslZUIiEB8CdDSg1ZpM6MDZics04bxBYtDwq3lR3xLnryS0cCDr0NLGAp+6daaubG8PvehLD+S15Z+lFiKDz8oxiSNuqEuZSg9SpipP5L2tfoWDrlYg5nHSkkWH0FdInxIDuBL5hpMu7EwgzOuPVp1V1A1VboiIAJ+EIhaIe5HHVqlQRlIT5lI2bhSXLc4DNviQ\/K5VUvpuAj0JwEOCR9EZ5lDwj9wZMJRflBWaUi4\/9dDHlMA5PA5+OyNNfPUm\/Pm+uKSMxehFB\/+s05CipG8GCcBTNLKODc3l5mcnMxwPVuYMs\/DXywWi3tRD\/RzM1zpJWlVUnlFQAREQAREQAREQAREIDUE2Btft+yomjEMxzswXagNCc85Q\/JSU9GYVGQQQw6xxoJj8TcyCMuaDf4xKaCKESoBKT5CxR1sZpjYNItVXBzFB3I6D33HELZT8APYx00v5UewLaDURUAEREAEREAEREAERKA1AXbLOblpCfMPcR48buX8JcCx\/3TkbF+DZBm9zqQf\/0vxkaJW51CXWnVg2GtWoego0thDSo8UNbKqIgIiIAIiIAIiIAIikFgC9UPCudrUGhQeWgQguOakhY1dPce+KAWXm1KOMwGrCItzGVW2DglA0cF25eSmat8O2Sm6CIiACIiACIiACIiACIiACIhAugjoxThd7blRGyg9rFLTbjeOaUcEREAEREAEREAEREAEREAEREAE+oWAFB\/90tKqpwiIgAiIQCoJxHX+priWK5UXgSolAiIgAiIgAiLQlIDm+GiKRwdFQAREQAREIN4EaOBHJQPmeTKY4Drywg4MDBj624aHkRdJBRABERABERABEehzAlJ89PkFoOqLgAiIgAgkn8DKyop5+eWXzYkTJxwFSD6fD7VSVLxgCXVTKBTMnXfeae6++24TdhlCrbAyEwEREAEREAERSBQBKT4S1VwqrAiIgAiIgAhsJUDFx7Fjx8xTTz1luD8yMrI1UoAhVHwsLS2ZiYkJx\/rk6NGjUnwEyFtJi4AIiIAIiIAIdEZAio\/OeCm2CIiACIiACHRNAAqCCoaAVLDlUuNYZM8fV6lUzPLysrlx44azXVtbC3WoCfNfXFw0thxUhMiJgAiIgAiIgAiIQFwISPERl5ZQOURABERABPqCAJUeqKivmgHOpzE4OOhYenB\/eHg4dMUHG4+WJiyHnAiIgAiIgAiIgAjEiYAUH3FqDZVFBERABEQglQRggVHFhJ+ZbDY7DL3HJJQTHIuSpQ5kXQ\/SW7Wp7KBH+iaXyzlb\/g7TMW9bjjDzVV4iIAIiIAIiIAIi0IqAlrNtRUjHRUAEREAERKBHAkNDQxziQkXHNLb7oSSYRJI5P5QePRZNp4uACIiACIiACIhA6glI8ZH6JlYFRUAEREAEoiQwPT1dxTKzmP6iQhMMWnpMa7nXKFtEeYuACIiACIiACPQbASk++q3FVV8REAEREAEREAEREAEREAEREAER6CMCUnz0UWOrqiIgAiIgAtEQKJVKzoQbGObCIS\/laEqhXEVABERABERABESgPwloctP+bHfVWgREQAREIEQCGNpS5VKvmNODHxxyfmfNuUK4hC2XtKWHcsXvLJqmx\/yXlpZMPp83xWKxaVwdFAEREAEREAEREIGwCUjxETZx5ScCIiACItDXBIKa0JTKDvooVlehUieKfPv6QlLlRUAEREAEREAE2iYgxUfbqBRRBERABERABDonMDc3l5mcnKSlB3Qe1UUoJ65j6MuMnwoQWlrMzs6ad77znY7lR6FQCNXqg3VZXV01IyMjZt++fc6Sup2T0hkiIAIiIAIiIAIiEAwBKT6C4apURUAEREAERGCDwMrKShbDXTi\/xxwCz8JCgs\/fMfz2ZUlbKhweeeQRc9ddd5l664uNAgS8Q8UH883lcmZiYsIZ8hJwlkpeBERABERABERABNomIMVH26gUUQREQAREQAS6IzA4OJiBcoBuGSnchF+C0mOEig+miHBuunI8lwqHmZkZx3eVSAAnsVyoXwApK0kREAEREAEREAER6IyAVnXpjJdii4AIiIAIiEDXBKAMgC7A0QZII9A1RZ0oAiIgAiIgAiIgAp0RkOKjM16KLQIiIAIiIAJdE4DOg8\/drJ\/Kj3U9StdFCuzEuJYrsAorYREQAREQAREQgdgSkOIjtk3TfcHwRbGCs8u1bff2090XQWeKgAiIgAiIgAiIgAiIgAiIgAiIQCwISPERi2bwtxD8olhnTu1v4kpNBERABERABERABERABERABERABBJEQJObJqixWhUVM+rT0oPjxsfgd8BPwDsrBkARgl05ERABERABERABERABERABERABEegvArL4SEl7T09PV8vlMpdK5Njxafh9mOV\/BNWj9UdKaqlqiIAIiIAIiIAIiIAIiIAIiIAIiEBnBGTx0RmvWMceGBiowugjA4XHIJQdo\/htaAQSuuKjpmfhugXZbMYMQL1Whpf6xf\/Lh2zpc4CtVSP956sURUAEkkmAzxvKRMpGyki6SsgPIcnnde76LwIiIAIiIAJxICDFRxxawacylEqlTDabpaKD3TtuIlku0fYtc1B6FHLwuMrYAS2WfaqoktkgMJiD4gM+P5DBMhHryiXLfyOSdkRABESgRoCPB1gExo7H+mOLz4rey2ZlIGUiZWMhDwUInj8+JN0RN8nnjnApsgiIgAiIgAgESkCKj0DxRpY4+32c7wOvxOG79c5lxiwXK+baYgkv5oNmrVwx5bLtjoZfprTmmIdiiQqmOXBeK+GFBhUNu3OfVraqlwikkYBVLBSLRbO2tga5XPZF2dAtK1gomkKhYLj1y1EGUhZSJlI2XirkTKZvUGwAAEAASURBVBnmHsWQn0GSz361qNIRAREQAREQgd4JSPHRO8PYpFAb6sJOLOf1gIUvu37hOubIzh635+fXzFNvzpvRWqczbDPjcGseTW45mHBjUhczv1wyVxaKUIKgwx+NoU80AJSrCIhAVwROnz5tXnzxRXPjxg3DYZG0FgzTwULRGYa5b98+8+CDD5odOzgftz9uAMpgWntQJv7JiZvm5YsY9glLF+jfQ3WSz6HiVmYiIAIiIAIi0JSAFB9N8STrYN1QF3bvylR+RFEDdjrpLt1cc\/z6ryhK0j95WlsaKkFq+Pun8qqpCIhAxwTOnz9vnn76aXPmzBnH4iKfx3iQEN3Kyoqj+Hj7299uDh065Lvig1W5tlh0fNTPIMnnEC8sZSUCIiACIiACDQhI8dEATNKC5+bmMpOTkxkuaQt3C+W\/DDPm3awHLD8ydvx0GPViJ5MdvVLNtJhf2tZtQMLIvR\/zqDpWH9as2vLvRxKqswiIQHsEaHGxtLRkFhYWDIe9RKX4WF5edobbtFfq9mJZGWiHt\/AZtD74pb3z\/Y0l+ewvT6UmAiIgAiIgAt0RkOKjO26xPAumyll0ZtnDm4Ou4xyUHYMImsTvAQ57CUv5Yb9u0fKDM+rLhUPAorb8w8lVuYiACCSRAIe3DA0NmZGRkUgsPji0hs8kloH7fjorAzn\/Ea3g4uBsMWzZ4lAmlUEEREAEREAE+omAFB8pam0OdVk37qgW0aFcRtXWsK3aDmYUVbWdvSjyVp4iIAIiEDcCkNEwQMCSWzDEQ9kifQ9GGRylA7f0YTqbn90GlXfI1QqqGkpXBERABERABESgRwL+fmbpsTA63R8C6EiyXTm5abg9WX+Kr1REQAREILUEqPRA5RzlR2orqYqJgAiIgAiIgAiIQMwISPERswbxqzg1pQcVH1J++AVV6YiACIhAlwQw51LN0CNTQBIjkNEFyul1PUiXieo0ERABERABERABERCBtghI8dEWJkUSAREQAREQge4JYC6LCoYdUhE9BX3Hfmy3QenhDDeV8qN7rjpTBERABERABERABNohIMVHO5QUx0Wguj4wPdLR6a4i6WdbBNRkbWFSJBHwlcD09HR1dXW1Wi6X+cwdh98+ODjozKsRtdIj6vy7BZ1GWZbGOnXbvjpPBERABERABPwmoMlN\/Saa4vTYKVvBojG3VitmYQ1L1OLbpcbRJKfBsbqwubVSNoVcxqyiHdXJTk7bqaTJJ4BVVKpYatwuL56LukZQwpiVlRVnSVuWi0vahumYN5Uu3DL\/dhxlFmXXAp5BlGV8\/jg2NO2cHPM4ks8xbyAVTwREQAREIPEEpPhIfBOGW4Ecvlfm8eI8iG77ILZSfITLv5fcynjJGBzIoP0w861svXpBqXNFoGMCXHWrtsJWBUNdSkgg0ucvymC4pG0+n9\/YdlypHk6g4oUKj1wu19GKMuvPIDx\/rCxLyRzeks89XEw6VQREQAREQATaIBBpx6uN8ilKjAgMo6P50J4hswhrj9VSxQzn9fYco+ZpWRSuJbFcrJjxQtbcu7Ng8mn5VNqy5oogAvEhACsHCs7IhefOnTvNww8\/bA4ePOgoP6iACNNhslcnu0OHDpnxcY7+ae2odKfs+qG7xxzLQz6DUqL3gPWL5HPrK0AxRCBlBOq\/Htbvp6yaUVaHWNPynIiSY1ryluIjLS0ZQj3G8ML8Z+8cNe85MIS1GGliDHEiQR0CeZ+yQJthDU1Ye2TM5FDWFKDIkhMBEQiHgB3qUrP6iFzxQYXDtm3bDCxRHIsLWoCE6ezwFkz62rbig1aGH5wdNg\/sLpgyHkKpegZJPod5+SkvEYiUABWddDnI3QIUuCP5dUvcUuRPhvVypen\/IN50B8C1gH+0GCT6Gv40VVN1aZOAFB9tgur3aBTSA3hh3jGac3y\/80hL\/dmuIb\/vpAWd6iECbROYm5vL4AU\/U1N+rEDJcBNDPSaimFiUeVLJMTIy4vi2KxFwRMuikQKGsopGajMjOccHXJxYJC\/5HItmUCFEIDAC\/BhVKlfNWtmYInwJXs5\/AhUYNJagLOdHW7pw1fzreep\/PAhI8RGPdoh\/KSQl4t9G3ZRQ7doNNZ0jAh0TwFCSLF7uOb\/HHE4+B0sLfOzLDMMzvOP0uj2hkWKh2\/T8Oq9lufpRVvVjnf26oJSOCMSUAG9rfkjk39XFknnh3KI5PTfgKECoCJHzlwCtnGlZc\/nWmrmxXHIU6Blq0eX6koAUH33Z7J1XWiKic2ZJOEPtmoRWUhnTQABDXKjgYK92Ef4aXvSnsR2k4oP1C1P5wfyS5vpRVvVjnZN2Xaq8ItANAc5XRGvbczdWzdxS0VGE8OkgtUc3NJufQzlK1kVY1iyuYUJtKj0Eujm0FB+V4iOFjYsONNcG5KoB\/Lqo2zuFbawqiYAIJJMA57aoyeUqtsmshEotAiIgAiLQNQH77r2wWobio1RTfOt50DXQlieuzwlFhRMVH3z06uWoJbRURpDiI4XNWvuCyCn6NU1SCttXVRIBEUguARh+sHdr5bN6usltSpVcBERABLoiYF+6OUEzF0jEzEtdpaOT2iWwruywHxss\/3bPVrz0EJDiIz1tafAlkS6LseRcG3An\/CR8jibUMqNOUUOrKiIgAoklAFmMvpc6uYltQBVcBERABHwiQDV4FlYIciIgAuEQkEVAOJwDz2V6erqKVQIqUHpk0LGeht+HFQSGaP0hpUfg+JWBCIiACIiACIiACIiACIiACIhATAlI8RHThummWLWlEvk1kRPmDUMJ0k0yOkcEREAEREAEREAEREAEREAEREAEUkNAio\/UNCVmMy2VrL0cJzfFqlgaxZai5lVVREAEREAEREAEREAEREAEREAEuiAgxUcX0HSKCIiACIiACIiACIiACIiACIiACIhAMghoctNktFNbpawNdWFcKrQwWbQ1AGnrdEUSAREQAREQAREQAREQARHoggDtrEuVqlktV+CrplDCei3qindBMppT0GxmtVQxa6WsKaMdZTcfTTsEmasUH0HSDTltDnXBUonMtQylRwkrvKh9Q24DZScCIiACzQhANqsv1QyQjomACIhAQglwhPla2ZjlYtUsFStmAF1yfYRMTmNWoOxYQtuNQPlRhOJKmo\/ktF27JdWLcbukYh5vbm4uMzk5meF6tpjbYx7+YrFY3ItiQ+aip635PmLegiqeCIhAPxCgiIZIRtfYVCia+6HOqqMIiIAI9AOBPJam3TOeM\/fsHDRLa1UzVsgaGXwkp+Wh9zALaxUzPZw1O8cGzPq35OSUXyVtTUCKj9aMEhMD1h5ZLmlLxQcKfR6d6iFsp+AHsG+k\/EhMU6qgIiACKSVQs8pjX1j94ZS2saolAiLQnwTGBrPm+4+OmiMzg47FwCAUIXLJIcAvEbT0KAxkzJ1ow4LaLzmN12ZJpfhoE1QSotWt6lJEeVeh6Cjyi6KUHkloPZVRBEQgzQRojYf6QRxnRrGdgXwex36OCmkppdPc8qqbCIhAvxAYzmfMI\/uGHN8vdVY9RSBJBLSqS5Jaq82yojPNds3Vtm2epWgiIAIiIAJBEaA1HmUylBzTyGMfJqOmAoS\/g8pS6YqACIiACIREQKI8JNAhZ6N2DRl4wNlJ8REw4KiSRwfb2tfZbVRFUb4iIAIi0NcEpqenq7VVtzgBNYcgTuRyOU1619dXhSovAiKQJgIbve40VUp1wXNaENJEQIqPNLWm6iICIiACIhBLAnYo4vqIF8NhL3IiIAIiIAIiIAIiIAIhEZDiIyTQykYEkkrgtvFQUmugcotAfAjgfuKQFyk+4tMkiS6J5HOim0+FFwEREAERCJGAFB8hwo5TVnZCPZpbDw3R8lpOBLwJFAoFLOklUeFNR6Ei0B4BDnVhTLyocl6PphOLSz63x1SxjJF81lUgAiIgAiIgAu0R0NtMe5xSF4tfiehpdl0schEYORHwJsDro2ae7x1BoSIgAi0J2KEuUGpQAVJudoLkczM6OlZPQPK5nob2RUAEREAERKAxgaZfnRqfpiNxJYA+dQY+i44zp+NxNuv97M0lpqUHv+Jfu3bNPPvss2b37t0Gqw4YdM43R9SvviWQz+cd5djp06fNzZs3TYvJGHnd8XrLQEnCL9qaDqpvrxxV3E1gbm4uMzk5mYGM5U2ygHvkGl5Yd1I24\/eW5Wwln90E9dtNQPLZTUS\/RUAERCAaAnyOyyWDgBQfyWinjkpJhYZ9CW10IjtNdBcuXDBf+9rXjP3NjricCJCAFeRra2tmaWlp4xoRHREQgc4JQNmRg3ytwN\/AvXUOv\/PYTiAlLj2+Sflh5bHkc+ec++WMbuQz+wX9wkf1FIFeCdj+sIaE90oy\/ed3OuRQH5mjuyak+IiOve854wW1CgHNifM4dmUNQruEfbpNnWpmXFOOmOXlZTM\/P+9YezCcceVEgATqH\/qDg4MGcxQ4YGy4pWSvL2xpLrSGa4vXHydvlBbNQtK27wlwjg\/IaA5xWYSfg9+Je2bc3j\/1gCSf62lo34uAlcN8KetAPq\/iepN89gKqMBFwEaBspoOSWkPCXWz0czOBTocc2v705lT0KwwCUnyEQTmkPDBJKeRzhZ2aZfgF+DV49KGzG4oN\/Hac7TRRsPProm5CS0ZbNwFeI\/ZFrNExXHfsIbBTvYhrawW\/S1TEPfnkk+5T9FsE+pIAhTPuoxI2K7hHlnGvFLGfo\/zlMMN6J\/lcT0P7zQhIPjejo2Mi4E0Ashe3jqPZcDZW5tbHrh9y+J3vfMcZEo7zNCS8HlKf71vrzDaHhDtDxnFdcTh4n5OLrvpSfETH3tec77vvvsrrr7++hi8\/C5DiV5H4Bfjt8FPoVE82yowvtPRyItANAQpvmuzhmpvH+Zfgz2P\/Gvwirqu1HTt2SLp3A1bnpIqASz7z\/riIe4cWH9OSz6lq6lhVRvI5Vs2hwsSIAD\/2UfmBIjU0c7YvtRcvXnSGhNOyivcUvZwIkACe4Q4IDglfXFxsOiSccalMw7XHufAaXnciGywBKT6C5Rta6p\/+9KfL8LcgoC\/hBnwLgnkcmQ\/gRhvA\/kH4bbzZKLCpsZYTgV4IWGUZriV+qr6G6+oErrWXsU9\/HML9Mh4Ci0888YQutl5A69xUEGggnznHh+RzKlo4XpWQfI5Xe6g08SOAPgvnW1qDDKaVNCed3qLQ4H3EPjPnOLtx48aGZR7jyokACfD6oKNCo9mQQycS\/vH9C+esQKm22czTRtA2cAJSfASOOLQMquhclz7+8Y9fGx0dPQGBzdlLaU7ltDE72LjhGlp+hFZKZZQaAjWBfwMVOgH\/Mn6\/AOH\/EhRvp7\/4xS9yDgN9FklNa6siPRJw5POjjz56fXZ29gSU0JTHks89QtXpjQlIPjdmoyMiAAJF3CML8Byi69lXqd1Dzld9Wn\/w5VZKD1079QTsNUIlmVWU1R\/nPq8Ze92srq5S8TGP57+W0HSDCum3FB8hgQ4rG3xhL\/\/UT\/3UFVp3wISaammuGFDGjUbTqkPYn8TN6YxtsTdsWGWLez7NeFihFfc6BF0+ywGsSvBcneI4rqtjyPdFXHPHcM29hQlzr+O3Z0ci6PIpfRGIMwHMeVOy8hn3D+VwS\/nsl1zyK516vo3StHKiPm6z\/Ubp8JxmaXV7XrOy8FizdHm8WZl4vJVrlH6v6drzkb7kc6tG0PG+JoBu8DI8hxzuRr9ldzMY7DLXus3NoumYCHgSoLxHP5lWRZx\/8Rb8aVxzq56RFRg4gVzgOSiD0Am88MILxYmJiYWZmRlnhQ3cYLzh2MGmafVwzbfs3IVe8BhnCGYxLl14RePDn0Ic\/hpyPQ4ux+Cfw\/4L8G8cOnTowq\/\/+q\/TdFROBETAgwDl8w\/\/8A8v3Lp1i5NP86sPTa6dYYnYH8H9NER5w\/uslWM8P5xf6dSXxa80G6XTik+j8+rL2O1+L2k3K3cv6bIubvmMoJcQ9hzyfBH7r0s+k5KcCBjz0Y9+FOsBDO3CahzbYKW6H\/dIQVxEwE8ClMeU6bi2uMIm5148jf1Xsf9d+D\/+7ne\/S4tpuZAJyOIjZOBhZccvi7Ozs5fwFR73XpZze9i2puUHflapAOEWG28zv7DKGnE+9u2CLx4FCiq3Ay8KLr6k2Bd6f9423BnF+Le9TqBEYym5HOdx+JfAhh3ql8DuOF7krmK4leb0ABA5EWhGgMMSH3\/8cUc+456iPOHQRMqiLO6pg9gO1X5TJlE24edmx3sR9+UKQnlTbo2wHj0I+cY0mR\/LRoX6ek51\/6lsRz1WcIzyYGuE9bi2bFTIDzaRvfwyZs2CmZbjkQeHC\/HjzZb0kVYZZumOUgnHbT7YbemYVhZp55C2fWZuOglpl5A2mbNunaSN5qpmUdchnL+lzDjGr4JMl\/W1jLHb2uFcJJupYqJpbjnB+QmEUS6\/iPK+hP23JJ9bc1SM\/iHw6KOP3sCCAG+89tprd2H4AW8cO\/9C\/0BQTQMnANnLPDj5\/0n4N3CdvYbtq5D1tPyQi4CA54M9gnIoywAIfOELX1jBnB\/nYP1BTQc7WhzTyM7aCjpDU9gv4CbMYcs7s5MOXACljSxJrmlGBKMowR6O4aQjEj4I6SCg+JuaWSuotmpHnJip\/QcUDiR2Dtgp56oUr2L7PLaczPT1gwcPXubLXGoJqGIi4DOBevlMGQNH5Sp3aA47AV+A3HFW5oIC25FJlEuQ3c4+Xs55v\/ErEpUfnC9ky8s0wn2Xb7jn+XJOGTiD\/UlbNvx2ZCbrgrKxLlfguW1YNhyjG0c6O71kL9JhXa\/jOJfJZv1QfUc7TUXRKF70xxC+xXIVZVpBercQdQ3lcTT9zKiFQzYZKibyOGUMaY8ibbesr2Ks\/zLS59wA9nna8tmJNBmHbTsIvwvlcpTsSMMpEo7bJTK5DD2t6VjmLfVyIm\/9h9M3y2dE4VfF57F9GXWhpYfk81ZuCuljApisdBWWHpcnJyeXCoUClZHm2rVrzsocxIL7x5Gz7SCy97E7LtPo1fmddqP0WE4\/yttrfXm+n2VslFazujY6h2Vrdh6P09k4kL18VvLd4Tg8FdEvYfsKf+MZwA+IchEQ6P2ujKDQyrIzAp\/85CcLN2\/e3I+b7g7cbPfh7DtxQ27DlibVXFWAn4tadt46yzUZsVH1jRcDMNiLUk\/D876gwLIdz5uIx2Va59dRZdydYURNr6vVmdohKj6WUNOruI5ewzX0El4CTuCryXlaGKWXgGomAsER8JDPR3FvTeFeG0auO+D34N4bxW++OGO36swLgn1n2XL8pqKEYVue5zgWhHxzFB9Iezuy3AM\/zHzqysb5JS7j90V4KkpblW0SaVD2UtlDZ2Uvn0lzSOs8trRicCwXwQbvKLkRTOK9H34WM+nT8sPpLPPlhctrYxWG81hU6iTM2OdxmmP5gS3T3sKIgciDedHaJgelxhjcweHh4UNIm3NlMYozsSFelKqYw+jUwsLCaeSzADnIg2Tsma5zIv7V0mdcmtPvRvSdCKMlD8N4OpVDy\/AXsM92JU\/7\/MFuY4dzeL7kc2NEOiICWwhgifFBWH3cedddd\/0khrz8PCKMv\/nmm+bKFepr1+933FvOfqt\/zeLh1mx1etPjjdLuNt1G6bEQ3abZtAJdHPSzjI3SalbXRue0ywjPBeeDKeJTlh9HelR4fAd5cujhG7jOLqrPTJrROFl8RMM91Fw\/+9nPrn7iE5+4gE7dKjw7yexIjsEP4obkF672pHuopQ4tMyBwrDuoAOLLBb+yYuNYgaz3lDMZLnnGL478eknX25NsPY3E\/Efd2XEnE3bSyeAWrqMzUHqcxovAnAR4YppSBY0hASuf8ZLOe8t5+cWW1ga0DuCcH8PoLNEKwZHT2HeGKyKcspyKSCokKbC2yKX1YKf3zuEko0iDL96Mx7RsfOZL+bZaS8OGI3izs+lhyzhUzIzAO8pzxmTZkAZf2lmPJUQrM24tXUbZcAhjGegpc0exZX3pbNmqSI9l4pcxZ8lJ7A9AiT8AK8aZBx544P1333330QMHDhgoI5ylJqEIMRjSYV599dWr3\/jGN545efLkWcRdgzKDyhimvUVpzeIxTyg4cjg3v3379l2PPPJIHmnP7tixY+MLMNO+evVq5pVXXrnw1FNPfQPluDQ+Pl6EssVRXiD9ltwQh0ogMmObUtHiFIqMEEYFDduT7OxDqGGaiLfhkA6T4CTmfFbdRF3OQmlzSvJ5A5F2RGATgZdeeqm0f\/\/+6\/fee+9r6Ms8jXv\/Dtw7FciKHO6fUXjKXmd1RJxIGbbpfByztymH6fG+3nSc8Xl\/w1H5y53NETbF3vyjLm1ahrGPvilCLW2m6axI0yptpscEEI9j3zeGFTIdmzbKyuOUs86Q7lZpbiqQDz9sGZEUZbRjgcNkPcpIOen0xRuVkWnxGFzb\/PzIH2k45a2Vi8+tkwjjioecC+9lXFtvIeyS+sygEKGT4iNC+GFm\/bnPfW4JQxFWTp06xY7kJXTWOMwli69Wfa34oKCyDg86drTtA8IGs0Od4frc7FxuBPbZDgU5OLB3XYbw5oP8Oq4prt4iJwIi0COBOvm8Ui+fKXMgozfkErNhB5WOcgn3Im7JdbFkt87Bun823J2OjcI8OpFvNj0rL1Fem9RG2Zgmy2YP2HPs7\/otZS5e0Kk0uZ1QLQLK7KTDYyw\/lEM5PMMG7rnnnp14YZl86KGH7oZ1xj4c40t\/GS8wgxivvwjT9ddffPHFP4Xi4\/idd965BgVFyV0mWwbLBfXJIX5+z549+6BU2fk2uJGRkW3I07FmQ9oDu3btuo56vfLNb36TSpVzKIOj+LBtYdP02loGNr9m3Gxcu\/VKrz6MdYN35DOe7ZLP9XC0LwLeBCqQK9fh\/gTyj8MRdk9NTY1BduzAkJc7oEzdj1uK1micb4mKDcqnDRlFecNwbLfh2ATkgvPSizBHmYBzKQ\/5gn4FcbhlX3tDJjKel6NcYNqIyvezHSjjCC3ZGE7HJGppcw4lpk35tEXx4kSu\/UMcnkz5QIX6bqbHdNaD1yMxTbiNId04vkVJvB4zmP91ZSRvltGpky0jywtZzLpzyDlXFKRmY0sZGR++Y34+5G8V\/LwuqJDikEVnSDiq8jKeH7SSvoxnvZ0rEIfloiAgxUcU1CPKE4qPCub8mEcncIWdPHQ2MzDnZad3Q5hHVLTIs52fnzfoQFdgHr2FBb70ZSyryAsaUQFYf\/gqrxU+VDCnB782y4mACPhEwEs+M2l09ipeMppyCUMusu3I8CDkGzpxVESsa2FcDDopG14wqjA1rzaSvawjkycD5Je9fPlyBjqJq+hMDmJIyypeDHZBQeF07CGjBhD\/FpQLz6Kj+fyJEycuQ5FRwTOvgrAMrTbcbmVlZSPtt956K\/P+979\/Ds\/HYZSHc4RsQ9nYkTWIl0NZr+PYM+jUHkPcOShVKBMbpl2fF2Uo69roOcO4KHMWL14tX47q0+W+5LObiH6LQGsCv\/u7v7sKfwLWXVc\/9KEPTXzgAx+YgiXXXtz7VyBbOEyBQ8K5EACt2jbJOoRRLlA2bYds2UuZgX3GoSziMDW+4F7GeRcR1xnyh\/2W9zbi8nwqcmmltxNp74anpZ4jh7Bl2kyPS\/FeRhzmQwVMs7Sp9KCFCOdTugF54Qzpxn4ZctwqTTgBJ63BuaXyoK2hdozrk7NlJO85lJHzW7FstNYjZw4H5JDHc9jO4Tc2W8uI493yoyKFjLrNH6c7ii22xzK4OkPCsX8M\/vju3bsv4RnvKNHxWy5CAlJ8RAg\/iqyfeOIJTshW\/KVf+qVmQjKKokWaJ77kRZp\/kjL\/1Kc+xQdEkoqssopAIggEJZ\/TJN\/AqIIXlbnf\/M3fXITC4y0oQcbx0jIA5YZ5+umnK88+++wSvthexnLul2G+vvaVr3wlgw5nQ4Fl2SAOO8zVnTt3zn\/+859fxJCXVx588MHRxx57zHkB+PrXv15+\/vnnFzHc5dLevXuvIO0SytI07SguOsnnKKgrzwQTWMPQuPn3vve9i4cPH7527Nix6+gjc5JhZ0g4+jocgscXb8qHDYdwvNtWGM658jjJMs3vHBmCfVp3UAnC4X6LiFeGEpUyqKEcsgnjXFq\/8QWcL\/ocFkdtLRUATv4IYxpUgnAoBdO35cBPb8dza+ezLkxvqJYOlQ22TGsIo2LBGUaCODbcO1GfQ1k+ejjO2TQGBpw7imUgR2tNwbItIh4n9KbbUkac0xU\/n\/JHMo4yyRlyiLKcgULsFBXmUnqsN1gc\/m+5aOJQKJVBBERABERABERABFoQ4FfWwWeeeWYAc31kfvRHf7QM5YfzxQ3h9gtpiyQ8DzsvNLOzs4P4IuwoPj7ykY+UMbzFpr3p669nCgoUARFIHAFYRedg5TUD66tpWlrgBZxKDG5ocbZRHxx3hl4wfCPQYwcv8Rkb1+OwZ5CN71faTI+O5W+Wpi2rjeucFOK\/durdThnbSYfVsmnZdm3nPHsOz7fncZ\/n8hiUHXw20JKGVjnXvvjFL3JIeNNrBMflQiQgi48QYSsrERABERABERAB3wiwc1mEWbrBkBbDcfZw7GT2qphgGitQfKzBuoRpGuwbKD6YrjqxDhH9E4H0EYAVVxnKj2uY72Me8oQKUE5wzGFym+57hmHi5OrZs2eN+1g9FVieZWzc+vBm+zZ+s7QZB5OzOmVjOZqlx2M2zbm5uYZxbVmb1adVPr0cb7eM9fXxys+m0yk\/e14rRo3y5\/lkx3wxtKVy8eJFDm1pyNur7AoTAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQAREQARHoGwKa3LRvmloVjZgA7zWN9Yu4EZS9CIiACHRIQLK7Q2CKLgJtEtiHeB\/yiPslhPU6Tw+T\/SvwXMmk3j2NH2\/VB7j2fxK\/3Uu5\/ltXHL9+3o+EHqlLjHX+f+CX68K0mx4Cau8YtKUUH903whRO\/RH4e+APwR+sbRl+Dv5NeApXbl+G\/wq8H4IcycTe9fPNPYPW+UH4D8Mfhuc6uTvhJ+GvwZ+s869i\/wl4Z910bOVEQASCJSC53ZhvP8ttUpHsbnxt6IgIBEHgI0j0dzwSHkIYJy7u1d1EAuOuRP4afn\/RFVb\/k0ulFuoDsM9JToP4cPWLSPefuPJi2D91helnOgiovdPRjn1Xi+9FjSk0l+ApCNv1fMn9q\/DOLNHYptnx5nZz+Z\/SXGHU7fvh\/xCeSyi6697sN9eL\/5fwD8An1fGF6eeTWvgAyy0uAcLtMGnJ7dbA+lFuk4pkd+tro59iSG6H19pUfHj1j9yKh25LRMWHO\/2fbpEYFR\/uc4L6SOwlc\/9ei\/LpcHIJqL2T23Z9WfJ7Uevn4d0CsdPfryANWoqk2fXTzU2Fxe\/Bd3odeMX\/OtKhlUhSHL+k\/Co8F7d\/KimFDqGc4hIC5DazkNxuExSi9ZPcJhXJbsnu+rtDcrueRjj7Unxs7TtK8RHOtRdFLv32jI2Cccs8+8H6oCWENiL8JOJ8C\/7tbcRtFeVuRODwhp9rFVHHY0\/g4yghrwsOa\/HDPYpE\/hSeXyDj7n4cBXwV\/n+AH4h7YUMsn7iECLtFVpLbLQD18WHJbsnu+stfcruehvZFQAREIKUE9MLSvGE5KdJn4T\/RPJpz9Br+H4e\/BX8AfhY+D9\/I\/R84wLhfahRB4bEm8D+jdP8bfCsTyNOIwzlfaHK5G\/4OeH5ZauQ4zpzzwfwd+H\/WKFLE4Q8i\/9+MuAxxzF5c4tEqktvxaIe4lkKyO64tE025JLej4Z6UXNdQUFroyomACKSAgBQfzRvxl3G4mdKD5v2cmIhbKjHqXQ4\/3gVPs7U\/X3+gts8X5t+A5xwP\/7EWpk0yCPwtFPMfNynqmzj2Wfj\/Au81e\/gehD8O\/0l47rsdr53PwI\/C\/4r7YAx+t1L2xKCIkRRBXCLBviVTye0tSBRQIyDZrUvBTUBy202kv39z+E29Nbwmn+\/v60G1F4G+IfAYalqB95qL4RmEf7ADElSAnGqQFhUf0x2klYSoaR7H9l40gP0C4L42buDY34RvV6HIL9M\/A89rwJ0WfzOfd8DHzT2EArnL+1TcChlBecQlAuiuLCW3XUA6+JlmuU0Mkt3GSEZtvSHEZCuTsELiOMdHWHVnPmmXuWGyTEJeau8YtFK9VjMGxYlNEaiI+CK815eAJxH+ffBPw7frOG8D54HgcBi341f9\/9YdqN+xJMDr4rfgvYYwvYRwKrg+D1+Cb8dRsfGv4f8M\/EWPE5gPr0MqSOREQASaE5Dcbs6nn49Kdvdz66vuIiACIiACIgACUnx4Xwa\/iuD9Hoe+hjAOW1n0ONYq6FVE+CF4vuy6HYc86OXWTSV+v\/8WinTQo1ivI+wD8G94HGsn6FlEeg\/8CY\/IXFrvlzzCFSQCIrCZgOT2Zh76dZuAZPdtFtoTAREIhwA\/nu6AHw4nOycX5sm54qjsjbNjObfDh8FmG\/KZDAGG2jsEyL1mIcXHVoLjCPrxrcHOcIS\/gvAlj2PtBn0TEb\/sEZnzPPyER3gnQWHd2CxTP97cI6j3z3s0CIepfBR+3uNYJ0GnEZnDZLzcLyAwDKHtlXcUYfaBSOZyItAOgaTKbdYtLNndj3KbfCW7SSF4J7kdPGPlEDyBjyGLf+jyneTK4Tv\/AZ5WwHxfuFzbXsX29+D5fuHnh04qVj4B\/\/\/CX4AvwjOv6\/D80HoK\/kvwPwZfgI\/KjSFj9nHJgB8Ll+GvwPND8ln4P4SnBfT3wvfiduFkKro\/B88h2Ndq\/ga2q\/An4b8Iz\/c5P5Quam+ATJJrdy6CJNWp17L+ZSTgdTNwskrepL26X0UCj8Ozk1DvfgY\/fqM+oMk+b2zetPfC31PbsvNMR0FH4fdH8L8L\/5\/gKWB6dby5\/wb83fB3wA\/B01GofBv+C\/C\/Dc\/8\/XAU5lQo0MLm3fD8nYOno2C3dfzP2GcdKdCCdGwfatHd7pcR8LI7sMvftCj6EvxPuc7nw4rXZaPrg2U7VHcOBfz\/Xve71S7nq\/kBV6Qn8fsP6sLehf2\/UPvN68\/taAnDzkK9++f4caku4Eexf3\/d729hn+1Hx\/T\/Ojyvs73weXg6DgF6C\/5p+F+DZ7u365LCpd36KF5jAkmQ2yx92LK73+U2mUt29ya7Jbd5FRnjfp6th+p\/2gj8O1TI9m9t3T6Fnar90WDLvuo\/hn+gwXH2Hz9c809h+5caxGs3mArdvw3\/P8KPNziJ\/Sj2zX6y5qkE+bvwX4YPy7Fs\/wT+p+Gp\/HA7vgvtq\/nvxZb9wK\/Cs5x8t2jXsa7\/Pfw\/gJ9ocBIVTuwrs49Nfx6e\/dZ\/BV+G78SpvTuhpbixJvAVlI4Crt7P4\/e0j6X+HaRVgn8Wni9zH4ffDd\/K8camoGN56svXbP8c4v438Dn4bhxv7hfgm+Vhj\/0R4lEB84se8f8ewtpxFOZ\/H\/4mvE231fYk4v4EfJDuGSTuLsciwvy8Llh+mv4twbvz4nXp5XYi0B33tFfEJmFe7cWHQb37Wfxw59Pq99vrE8A+Hyz15\/wL\/GYH49dd4fVx6vep3PocfDvMk8QFVZLrkUCc5TarFrbslty+fUFJdm+Wu\/UytdF+veyW3F7nV8\/k9tWlvV4IUDHrdQ0Wekm07lyvfiRfwJu5FRx0l8n9odJ9\/s8hwH2fuNNw\/34N53zeI692+spUFHzX41x3Ho1+fwHn8pkUtHsbMngZvlE5WoX\/ZJsF\/H7Ee7WHfH4H5zZSlngVQe3tRUVhiSRA5QMVEu6b8cs+14Y3mJfms1k2Yd\/YLItu7vUWGcWmCO++Lv7P9cO+\/6cFizsvXpd8mXc7fkF2x42r4qPiKutv4DctOdzlb\/X7RZyzB76ZSxKXZvXQsdYE4iy3WfqwZbfk9u1rRrLbmF6V1pLb688oKT5u31d+7aVB8fG\/AkarPksnx1spPg4jvzM+5MmX\/Rx8UO49SLiTj7RejFaRxgdbFJD35TK81\/mdhPEDbztDytXeLRok7ocH4l7AkMv3XuTnJQie9Lkc1EJ34nhjc0iA2\/yukzT4gOFL5vfAUxi1cry5f6VVJI\/jdyGMvlNHYU6Lkf2dnlgX\/69hn8qBvwBP7btf7n1IyOte+a9+ZeBKh4qPv+gK43X5Q\/D\/xhUe1k8+QPx2j3eZ4P0474\/hvxf+bJdp+HVaEFz8Klu\/pBNXuU3+Yctuye3NV71k9\/oLwWYqvf16vMvTJbe7BKfTYkvgAZTMbR1rC\/sGdtiXewaeL\/Dvhv8BeCoEunWDOPG34Bv1k\/89jj0Ffwyecd8J\/354WgC6Hd8J\/gH8p9wHfPjNvNlXnfBIi33zJ+C\/BU+rFf4mR1qz8z2g3jEdMnwQ\/lz9gdr+CLbk4fVutIbw\/wj\/bfjn4VmWd8F\/CP4ReLdjGf4t\/EfhG\/Xr1N5uagn87fUyl8Bq+FbkvQ1S+sMG4WEEh31js066uTe3LJVFXo4PtCAclVx8GLiVcHcEkVmbadLqaRqeMoMPoY\/B17tT+PGv6wOwf9H1u9XPK4jwGfgn4V+Gfwf8Y\/AcwzoMX+8O48c\/g\/+R+sAI9sPgEkG1EpVlHOU2AYYtuyW3t162kt3r4\/mDlN2S21uvO4X0RuD\/xunsA\/XqxntNoMX5v4bj7n4aT+EL90\/DL\/BHzbFfRyUDFSWtrDpqp2zZ8Hy+vLvdSQT8DfivuQ58tfb7x7Bl\/2zUdZzl+P\/gn3WF9\/rzf0EC93okch5hfxXe\/U7Fj57\/Cp79v5+Fr3cz+PE4\/K\/UB9b2P4vt3R7hJxHGOn\/Ldew\/4HcWnvUmS+7Xu7+IH+T4+frAun21dx0M7aaDwC+jGtT01fu5iKtGYVVfHrt\/AuHUIHs53szU5PLBYePXb\/+m10l1YX\/Q4LzfRvhYXTy7m8HOP4Kvz8O930zQU6C54\/P3Cfjvh2\/kKNj4YHGfy3p7aXQbpdMq\/AuI4M6DAjxI9zoSd+dJDbrb7UKAO95pd6QWv3\/RI41\/2OSchzziP9Ukvj1U8TjPlp2KDiozvNw7EXgW3sat3z7mdQLCksSlQRUU3CaBOMptFj1s2S25vfWC+QKC6uUF9yW7NzNpJbslt7deVwrxh8BHkIz7\/gz690+3KPqKR5nYx3U7TlTqVdZ\/jnCv+PXn\/3iDc5leo77yJI55zVlyCuE81srR4uoCvLvMv9XqxA6PsyxeDF9C+I4WaeVw\/Cvw7jKyf+h2ja6dP0JEKnpbOb5beJXzOMJZDrdTe7uJ6HcqCPwb1MJ9w70WYc3CvrFZVd3cWxucGnH3dfEnW6P5GsLOqDtPPhDcLkkv+I060H+KSrV6cO9BnMvwbiY818sliYtX+RXWPoG4yW2WPGzZLbntfb1Idm\/m0o3SWnJ7M0P98o9AIznpfs77+funWxTf62XYS5HxL5GOu1xUTEy1SN8e9nrBZ3qNFB9\/G8fc+fHe5At8u47WDO40Sgjb324CbcT7MY88mOdH2ziXUQ7De8mcd7jOp4LJXRd+9LzPFa\/Zz894pME0f9TjJLW3B5QkBtEyQO42gX23dzf2rmzshb\/zQx5ZUiD8LPycxzF30NcQ8C\/cgfhNwfIxj3AGeQmnWwj\/u\/AUCM0czROtaV2zePXHKIjd5ojM56\/Dz9dHbLB\/DOF\/3+MY6+eXMN\/mkX47ZfM4re2gSx4x93qEpSHo76ASrXheQJxf9agsrUEOeoQrqH8IxE1uk3zYslty2\/t6l+z25uJHqOS2HxSVRlIJ\/DmPgv86wm54hHsFeQ3d8Ipnw\/6S3anb\/l\/YZz+\/XfcbiPimKzKtG\/6sK6yXnz\/scfJzCPtPHuFeQScQyA9\/1q1ih9Yi7v7v99gIddsv1+LWBTXdZRtQWeV2P+gOwG+1tweUJAZJ8bG51bw6SV43xeazgvsV9o3Nmujm3tqeXtdFuw+3ram1F+KlcNvd3qmJivUkSvuHbZaYGv5rHnG9XjI9oikopQS87s8o5TYxhy27Jbe9L26va0Oy25tVJ6FPIrLkdifEFDdNBDhs5ICrQvxgRwuCdh2HZHyjzciDiPcuj7i\/5xHWLKiMg3\/gEeGDHmHdBnk9i\/4pEiOfdt1\/h4h\/Hv4o\/Cg8ef8XeOumscMwt\/uUO6DF76s4\/msecf6MK4x5qb1dUJL6U4qPzS3n9dXZbY2w+YzgfoV9Y7Mmurm929Prupj0jhpo6FqgqUeT+C91kO0C4npNOuX1oO0gWUVNOAGv+zMquU2UYctuye3GF7DXtSHZ3ZhXu0ckt9slpXjdELgXJ93hg1\/sJvM2zrnLI85lhHlZ6npE3Qh6emOv+c5DOFzwiPJdhA116I95pPOIR1g3QXz2TXmc+KJHWLMgxv8d+Lfgqaxxuw8gIOMKJPsTrrB2fn7TIxKvvfo+hNrbA1JSgwaSWvCAyn3RI90Zj7AwgsK6sW\/VVcbPm\/v9dek22m0lzBud5xUepDD3ErxBKyH4AHG7c+6AhP\/msK1vdFgHr0mu+FVArn8JxElusxXClt2S242vfcnuxmy6PSK53S05ndcugeOIyCEOvTpeq0G4nR6JnvUIaxV0plWE2nHOceblOlUoeKXBsO2NDnQY7sWFSZzuMJ1W0d\/nEeGkR1g7QY2UJXz3s+9HXvVSe7dDN4ZxpPjY3CicR8Dt\/BII7nRb\/Q77xmZ5dHN7t4qXgPMyofY+u7vQflB88H7rVIHk9QDlRKZy\/UsgTnKbrRC27JbcbnztS3Y3ZtPtEcntbsnpvLQQ8EvmesknL0ZR9De9ytEqzKsvdgMnWQVCq\/PbPe7F42S7J7viNTrv\/2\/vTMAlqcozLPuqiMoqwgAuQWRRDO6gAgoRjbiBSlSExAV3NBI1oiQm0WjQkKDGhauAiEviQowQkUEhgoqKgqICMwOKuLDvDku+b+bWUPfcv9au7q7u+\/7P892q85\/9rarT1adP1fXERxbH8U6gTXJw9Ulu\/BDaHv1y6AtsnSHUVVXkqC7sfDu4uPM07tmPZuW9FG6YtlNQ+LSt+FgW9LHKFU18eGnlOK7RqrYSPxoCfRq33eNRj92M28XnGWN3MZu2MYzbbcmRb1oIRD+IRqvLqvpbd+Ijenykquwm8esr8ZpNMhSkjbh4orRruykosOmPaFkRt2rHkzOprZdzRP3ieOcATdIuEx9zj9aVc4MrQmvob5cv\/smq2FA76TNqWZy3o76wXScXtynMt+jDaUsl235+0k48i1RKtLRx2iY+onO8CmDRM7TDvjGoahfx4yPQp3HbFKLzmpuy+udHVzfhrpGxuz73uimj87sqL+N2FSHiJ4nAbUFjbwl8Va47qhLMxt9dM90gybp4LCiaDPB43rXdJyjQExhtzN\/x8u\/zyMrIT4ZwvDMqU7DtYoZvCjCs6sLZq\/bm7uyj4BlzXQOFFin3xZKXfy2e1Zna\/lTKbNQXtuvl4s7oz92ePze4KrSH9i5dFepu50kFRV1U4B\/U7YF\/HNbmg2qTgoZGLzEsSFrbPS4utRtIwhUE+jRuu0GjHrsZt4svBMbuYjZtYxi325Ij37QQiFYxbNOic1vVzHNtkM4\/hO0d+Nu6upj4yE8WZO3wj4T+kb2L8rMyr8l2cts2\/J3dxyC61\/PLajPjeGckpmDLxMfcg3iFgj+UHjnXveJ\/XB+Z+AYJvliZvTTfet6stLnXYdInvCMb9YXtOrm4TWG+nSOXH7HYOok6ROHjE18XwUODQvzB9\/XAH7miQTxKl\/miL2pZ3DC30aqWqvoeFCTwpEf05S9NOilc0nYTLifQp3HbLR312M24XXx+MHYXs2kbw7jdlhz5poVA9Hhlmy\/e6T1lEZ\/oM8XXoe9L26w0KapnUH80QbOWCt1Mij6niurzanjnK1opGdWzqKiwCn903DxJc3UuH8c7B2PSd5n4mH8EvyxXOvHh8E7ST+Ynb+XxxEdqy+XI\/5\/qUV\/Ybg8Xd3pUVobv1uZk6a1JtFdmPEY6L\/EPEvS5tmdQwOflK\/oQSJOvnToqwuN6TKTuh36++VGe6LzN58n2J4VL1l629Qn0Zdx2i0c9dkfnf3QzV0UzuraiPJNyE+62M3ZHR3AwX93zJF9LlCc6b\/N5sn3G7YwE274QuDJoyAPl85d138vXtbrjtCc4UvMqil2k76QRYwz7RwiPuelj\/P7BqsnEx+OV\/jTpLmnJrM7V9p8km32pmaV\/3LozjagIbxfE+zMuXw7HO4A0qS5fONhcAl+ZG1wR8kV8TOBv43q0Mu0QZPSNe\/5GoOzCDrKXuupc2C6g7OIurSCJ9ABUxy4PEvmc9GDeNzupoEHvlb+r68jnmcuL7MTIKV9+cM6SrJPt1Nz6A3sc5l8Bmt7ULgoa+qvAN8lcgu7gqiDQl3HbzRz12M24XX5yMHaX82kay7jdlBjpp43A99ShdKWFv3Qf3KCjvt\/br2Z6\/+h6Q5B238BX5XqlEvxcOk86RfI950ukLsyT\/hcHBT0n8JW5nqbIDaR7SztLfy49VsrsnGwnt11X+034Z1lfke3ktumP3BzvHBx2p5OA37Vxd6BnDdhdX8g\/Csp1XXslZfu5uKgNL03S1Ql6Rjgt65tBRr+E6OYg7SFB2iKXB\/MfB2W8I8jgCYPrg7TvDtJWuYY5mGd1+4Mi5ehwm\/ZmZea3bykof4n85hqZPxiiNq0XJQ58Pgb+sErLODpIm7l2DdJ\/O4ss2Xr2Pq3noJL0aZRvLH4RlGFuqU0Sl7TthNsR6MO47ZaPeuxm3K4+Xxi7VzJqM3YzblefX6RoR2A\/ZUvvCRxu+uNNUe2eLEjLr\/qS78dm0zzR\/dcXgnSXyedVH3Xs+UqU1uNwdK\/s8r4WpPfkyyKprvm+8CoprfeMugXUSPfxoHwfh\/vVyJslicbrl2aRs9tLtU37sUS+Jj+m7R+U4TJfLaXG8U6JEJ4qAp5tTC8oh38t+ZGXtvY5ZYzK9Ze5aGAd9YXtfnFxm0JsPva3S+kx9OqCqg\/TuMR7vH7Xyx+ltGyHn31Psnl7\/pCN8tRdNfOUgvxlEx+egU\/r9ORalUU30Bcpkydf6phn89N6HX5wkHmSuATNx9WCQF\/GbTd91GM343b5CcPYvZJPm7Gbcbv83CK2PYFJnvh4obod3Y\/8VQ0cvufxvU+Uv2ji48CC9F+tUV+W5KiCMg7IEnSwLbqnfHfNsl8UtNGPD6UTJ38bpDPP10h1zMcg+iHa9\/ObBwVwvAMouKaLwH+pO9Gg5BUK+zTsqi+w9xSU5zreWFDeqC9sN4OLu+BgzLrfrm10XtjnD6xoAms2a+Hm9YrxYBuV+7HCXPdE\/DbI+8F7ogv3\/I6fHwd53Y6jC3OtnGhI25ouDYyyRzfQLscf6FXm1R4XS03qnRQuVX0nvj6BPozbbu2ox27G7epzhLG73djNuF19bpGiHYFJnvhYT12+VErvSW6Vzz\/SFJlXfn9WSvNl4aKJD98DXVaQ7zj5vfKvzA5RZHQtL5HfZXdp0YSCV9J4ZXaZba\/I66SMRbY9I8h0f\/m84iVLk239A6LvqctsE0WeLmV58luvrImM4x1RwTdVBLZVbzyA5S+IbN+zjx+QFklVtrcSXCBledPtqYorGnRGfWG7L1zcplBsniz4vpQexyx8nuKeUJx9TsxuCp0lZXnT7S8Vt+GcHHHA51Ca1+fuk+PkK7wb6W+ULyunbOJjS+XN0mXb2+XbakXJxX+iD13nv0batzjbvTZW3NelrK78tuwGI+pfH7mUdJ2ohgT6MG67yaMeuxm3q08Uxu74MayqsZtxu\/rcIkU7AvspW\/7zPNufhEdd3GP\/CJq1Od36O8KmTjRrq2n7KKnox6Ysf9HEh4t5jpSlS7f+YWhPyeNc3rZR4D+kO6Q0j8NVkwRK0th8P1c0bpyguAclJbrN\/gH4Biltoycyiu6p3xakz\/J7FeRDJHPPzJ+TPud+JWXp8lvfi6Ztk2uVcbxXoWBnWgl4drLo4vXFcqfkXxhfLj1ZWiTtID1bOlI6TcpfVOm+v0B79rfMRn1huy1c3GVHZOWvZpcoSXo882Ef23dKe0gPlh4geTb7iZKP6blS2bl1k+IfI9Wx\/ZUoX3e2f6P8fyPdJ1eI918rXSZl6aJt2cTHvQvyeqLmXZKXeh4ubS7lray\/vpbM5b65DJ4Q9Aeey43a+I1c2mh3UrhEbcfXnkAfxm23ftRjN+N29TnjsZixe\/54WjZ2M27Hn2fVZxspqghM+sSH+\/dpKbo\/yXy+tr4lXVuRLkv\/DqUrsw8pMksbbW9TvO8\/vXLhQmm5FKWzz5MQ+YkBBTuz96ukonrtv0ryPdx3Jd+rFqV9jeKKzG3\/H6kor\/3mfpb0Q6mMhdM+V6oyjncVIeInnsCL1IM\/SmUXVpu4pSoz\/WIo1zwbx4XtRnBxzzsUcxz3U+gMqc2xr8rjZz89gVbXVlfCJVJRuZ5UyGbSo5vYyHd0ReXLSurL2nFQUkZUT5Y22zqN+3+2VPZheLPiPZtfZpPCpawPxLUjMO5x260ex9jNuF19vjB2F39WZONwfuxm3F7JK8+k+iwjRR0C0zDxsbY6+hkpu3aabK8O8lVNfKylPB8P8jWp12m\/Kq0pDcvczhmpabvy6T0xU2UbKcHpUj5f032vBD60qqLZeI53TVAkm2wCT1Pzy76ENb3I\/MXu4Q2QjPrCdtO4uKsPkD80\/l1qevzL0p+k8qpWAUUtO2yAdrwlyFs18VHngzctI7qBbjOp+Fu1t+5qmEngEh1PfIMTGPe47R6Meuxm3K533jB2l39u5cduxu2VrPJM6p1lpKoiMA0TH+6jJ7nfJ0XXStH9nlf9PkVK46smPpRlhfnRkDbfS\/xom+9b11tRyvD\/vF1V3Cal\/SwLu19vlfx5Vsc8nv+LVLWiI6rz58q3c51Kcmk43jkY7E4vAU9UfEpqegHnL7TLlf8QyUv4m9qoL2y3j4u73lHyh7cfa2ryoZc\/L7x\/vnSwNIgdocxNBn7PcvuRFFvanqqbvPWV5+wgX76cL7jgnKV83NYnSp7IyOcr2\/ek4bZSE+s7lyZ9IW0zAuMet93aUY\/djNv1zxHG7njszY\/djNsrGeWZ1D\/DSFlGYDdFpp\/318jX5h45qidb6Zqvw9d8maX3+L8vS5zEPULhE6Wy+zCXd5Tkz4UtpTukfPvqTnwo2702kT4gXSnly4j23S9PeGwljdq2UYWflKIXl+bb6tXJn5a2kNrYQ5TJq0Sul\/Llpvse07xi+yBpkPfJcLwFEJt+Ah5o3iZdIaUXUxT2BbZE8pevdaVBbdQXttvLxV3vqO2gZMdJfj9HdC6kPg\/OH5YeJXVlbsN\/Sp7VT+vLwo77orSjlNnvtJPFe1s18eF8fh\/HyVLRh9n3nChn0Q20o7eWvFQxjc+35weKf5Hkm4U21mcubfpDnmYExj1uu7WjHrsZt+ufI4zdc8f\/\/Nidjsv+Umdj3F7Jgb8QSAl4QmM\/6XXSMdL7Ja\/QsG8taRi2kwo9VDpS8mTIhyR\/73i2tLO0oTRu8\/3bHtKrpXdJx0q+13yhtKu0ntSFmXFWz1Ha\/1fpvZLrfYa0jdSlcby7pDnksvzLENaOwOrKtrnk2dMHzcr7Hlwul34xq19q61\/WuzZf2I+TfHPrm\/r7S65n2az8UiPvd2m+uHeRfAO\/reTZ2V9LF0vfkLIbIu12Zh7Md5fcR8sDp\/leKl02K0809MncRt8ULpLMydvNpD9Iy2a1VNslkichhmH3UaH7SNtJW0irSf5VwOx8rK6WujL318fI10O+nt8ofJeUmfcdn9kd2vF5nNki7ewt+Xry+ez8vn58fv1Y6sL6yKWLflFGPQKrK9k4x2230uf8KMduxm1Tr2eM3Ss\/I\/JjN+P2fCb1ziZSQQACEIAABCAAAQgsSAK+gc6v4hjGRNmCBEunIQABCAyzft1EAAAaOElEQVSJAOP2kMBSLAQgAAEIjJaAf\/3CIAABCEAAAhCAAAQgAAEIQAACEIDAVBJg4mMqDyudggAEIAABCEAAAhCAAAQgAAEIQMAEmPjgPIAABCAAAQhAAAIQgAAEIAABCEBgagkw8TG1h5aOQQACEIAABCAAAQhAAAIQgAAEIMDEB+cABCAAAQhAAAIQgAAEIAABCEAAAlNLgImPqT20dAwCEIAABCAAAQhAAAIQgAAEIAABJj44ByAAAQhAAAIQgAAEIAABCEAAAhCYWgJrTm3P6BgEINA3AtepQavlGnVlbp9dCEAAAhDoHwHG7f4dE1oEAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAwDQRWG2aOkNfIAABCEAAAhCAwCgIcAM1CsoLt44nqOsPTrp\/ucJnJr5xBddVxQcmld+k8BcTXxY8WDtrZIHZ7aeSMEEIQAACXRC4vwrZV3q6tK20mbSptJF0tbQ0p4u1\/3npemkh2Hbq5JMG7Ohtyn9tTtdo32prff58eIk6lb\/fu0vhE9p2lHwQgAAEIAABCEAAAnMJzCh4d6IvzU0y1pC\/SKTt88RMkflGOU2fv5ksyocfAhCAQF0CeynhWdKdUjrelIU9afsRaSdp2s2TDGUs2sZ5\/J+Rnik1tT5\/PniiI89kedPODZj+Ecp\/+IBlkB0CEIAABCAAAQj0lsCMWpa\/2fI+Ex+9PVw0DAIQGCMBT1h8XUrHzDbhM1WOV4lMqw1r4iPP+nTBe1gDgEx8zId1b7k+IHmi5dvzo\/FAAAIQgAAERkdg9dFVRU0QgAAEIAABCAQEni\/fdyU\/1tKFPVmFfE\/y6hGsHYF9lO1c6aHtsi\/4XAeJwMXSm6Q1FzwNAEAAAhCAwNgJMPEx9kNAAyAAAQhAYAETOFJ9P0XyO4fKzI9hfEc6TbpAulEqM78jxGnfUJaIuFIC91XsqdL9SlMRmRLYRY6TpS3TCMIQgAAEIACBcRFgFn5c5Kl3Ggj8UZ3w0mgMAhCAQBsCnpT4x5KMlyjuWOm\/pUuDdFvI9zLptZL3U1tDjmOkDaT3pJFTGN6xZp\/8bia\/42nrWXllzB5SZA+R851S0wmkhfz5wLuvojMJHwQgAAEIQAACU0tgRj3LPzPt\/S\/1qLdNX276FLXdN8iZHt2jvtAUCEBgsgg8Vs3Nvhyn4+R1ivtLqe6PE2sr7aGSX3CaluWw63mkNC0WvePj5gE750dbfiBF\/Pzfcvy+ijLr8+fDqF9uuqtApRy\/XQaPOAhAAAIQgAAEIDDJBGbU+PTmZ5InPib5WNB2CECgPwQ2VlOWSen46PCFklcZtLHdlOk3UlTuT+T3BMk02DAmPszFj7QUHZdXTDA4Jj4m+ODRdAhAAAIQ6IYA7\/johiOlQAACEIAABOoSeIMSbh0k\/oV8T5B+GcTVcZ2vRI+RlgSJ\/S9F3x34cd1D4BrtelIlsp0jJz4IQAACEIAABCaDABMfk3GcaGVMwL9ebiqtE0dPlHdUfVlNVPzSQ\/\/ijEEAAqMnsL6qPDyo1o+pHCD5sYpBzC9B9WMykb1Rzo2iiBa+UY1ZLZo2UBY\/kvGHoITtAt8wXV59UvV4zTDq9+epP1fXGkbhlAkBCEAAAhAYF4G6zw+Pq33Uu\/AIvEBd9i+TmZ2tndNnA\/6y7vgXSjtIm0j+Im\/zM\/E\/lL4sfUb6vdS1PVcF+m31efNL74qsD30xowOkZ0i7Sw6vIdmWS14W\/y3pVMmPId0uYRCAwPAI+F0cnnxM7e\/l+GnqbBk+Q\/lOkP4iye8vtc+Rjk\/8WbAPY1bWlnFuL1LleyYNeGASToNNPx\/S\/PvK4XPjYdK20oaSzRNiPi8+J50o\/VayvUm674q9lX+8yqfouOaSzdv1RJj\/9ezzpEdJnnCx3S39TvIqJP\/Xoc9KV0tF9qeKeOZspN+flZpXOB2dOP9d4aw\/SRRBCEAAAhCAAAQgMDkEZtRU3zzl5S\/XZXanIvPp3zeb+MXaenIjH1e0f73SHSFlkyLaDa3py01vVSlpnWV1jLIvaQf9q\/LfSjcEbU77kIWXKq05YxCAwPAInKeis2su294snyd2u7QHqLBbpKyObHtaSSXjHLNKmjUvaljv+Mgqio7RGVlkwbbp50NWjCelL5Cy41O29WfbX0n+3FmW5FmscJEVvePjJcrgiYeyOrM4n0uuu8hepYgsbd0tjw8V0cQPAQhAAAIQgMBEEZhRa9MboKqJj\/QGzRMf\/lUoLadO+DjlK7OmEx+3qbC03rKJj1H2Jd9P\/zL5o6CtaduLwjPKyzJnQcAg0DGBDVTecim99j7acT1ZcR5v07rukG\/TLEGyHdeYlTSjMjjMiY8tVHs01n+wolVRnrLPBxf3aimdbEqPVxT2+eJHmvJxixUusvS4+hw4Vsrnr7v\/4YJKmPgoAIMbAhCAAAQgAIHpJzCjLqY3U00nPtL8TcP7lGAe9cRH07an6cv6knVzW+1cEXBPy6oKf01lrJEVyhYCEOiEwN4qJbr2\/JjBMOxlKjSq7+UFlaVfkKO8TXx1xqyCppS6hznx8aECZn4MpcyaTnwcqcKasKxKu7ikcV0fVz\/Wk9or5ahqYxrPio+UImEIQAACEBgagTWHVjIFQ2A4BHwD56XaXhr8a2lX6amSv\/BH9ho5\/zeK6IGv6774ZYOnSFsV9O1z8n9bulBy2kdLj5e81Dq1\/eR4p3RUGkEYAhBoTeBJBTnPK\/AP6j5VBXhFQTqJuV3Lgrses1o2Y2jZvGrhdUHp7vf\/Bf62Ln9u+Z0ukS2R87+kc6Ubpd2kp0h7ScMyT0h8XfLjPL+V\/Bnid3YcIEWrVt4v\/xelvJ2kwMaS7yv9Lqx0cmSZfJ+Q8nZVPsA+BCAAAQhAAAIQmFQCM2p4+gvPICs+fCPom8DIfIPmG\/y0Pvu2iTLIN84VH133xV18j5T23+ElUtlN84GKvynIa3ZFvBWFQQACDQnMKH16jV7ZsIymyf1yyrTOTxYU4i\/4adosPIwxq6AZle4uV3yspdqeKHmVW9bXdPuvlS2KH4+JJg1clCeg0zoc9ufjfaTIXiFntKokK2dxlGnWV3Zcv6s0fqFqZE+W8wopqyO\/\/ZMow6zPEzv5tN53nzEIQAACEIAABCAwlQRm1Kv05qftxIdvmopuIjN4bwzqc\/2vzxIk23FNfAyjL34zf\/QiU\/\/K5rgq83\/S+Y2UHq9TqjISDwEI1CbwFaVMr7Hv1M7dLqHHm7ROr5qLrOgL8jDGrKj+ur5o4sN9PLaG\/k1pPiX5s+gc6RYp5ZMP+10adf6tbDQpEX1meZI+X362f4z8UXq5V9nu2itq7+JVqebvFB1XT\/asOz\/5HM\/+CmVtzG+9mrLImPgoIoMfAhCAAAQgAIGpJDCjXuVvlLzfZuLjDuXzjVQd85eItM4PFGQcx8THsPpyRNBv3+zuVdD3yH1YUIbbu1WUGB8EINCYwNnKkY5PfsRgmPYFFZ7W+ZOCCqMvyMMaswqaUMt9cNCntI9dhK9RPXvWalG8GiOayDg5aPtV8q1fs55\/CvK7r4tL8kfH9Xql37IkTz4qmjxzO4qMiY8iMvghAAEIQGBsBFYfW81UDIH6BGaU9Ec1k38rSFe0dDhIOnTXjGoYRl+eHbT8M\/KdEfiLXMcr4pIkcg2F90l8BCEAgXYE7hdkuy7wden6fVDY5oGvyDWjiGGMWUX19cX\/fTXkUdJZHTbIj9XsF5T3D\/J5JUcde68SedJiUDtJBdR9zMoTdqlF53KahjAEIAABCECgNwSY+OjNoaAhJQSaLAVfGpSzduAbl2sYfXH\/\/CK61Jr+kux3enwzLUThJwY+XBCAQHMC0RfWOo+iNa+pPMcfy6PnxA5jzJpTQY8CXjnhl2G\/QPKLn5dKXdoeKiw93j4n\/O9p69q1Suh\/8T6ofaNBAUuDtBsHPlwQgAAEIACB3hLw27cxCPSdwNIGDbwxSNuniY9h9GVX9XmdoN\/+lbbq+e0024WpQ+HdAh8uCECgOQFPLqbWZBIizVsnHH1B\/XWdjLNpljZI2\/fxt6wrr1Ck332yrCzRgHEPC\/JfKt\/tgb\/MVXcFTlkZF5RFJnFXJGEH1wt8uCAAAQhAAAK9JcDER28PDQ3LEWhyI1p3uXCu+JHuDqMvWxT0oOg5\/oLkhe4HFMYQAQEINCHwqyDxsB8ZGHTiYxhjVoChE9dWQSm+z9lAeqjkyY2nS6tJqR0hh\/\/DSZP+pmVUhaNHjJZWZQri2+RJi\/H7S+ra8roJSQcBCEAAAhDoKwEmPvp6ZGhXRsBLj6Nfm7L4dOv0fbVh9WUcX5z6yph2QaDPBKKxbLshN3inoPy6Kz6GNWYFTRrY5Unvsn79VPFfknaW\/MLXh0h588SI3xG1l\/S9fESH+32Z+PBxvb7DflEUBCAAAQhAoPcEeMdH7w\/Rgm+gl4Y3XQbcV2jD6st9h9xh\/7cBJkmHDJniFwSBaMWH\/7PG9kPq\/SKVG60IK5sgyDdlWGNWvo5R7\/9YFT5Oujio2P+21u9GekQQ14UrmqRep0XBf2iRJ5\/Fx9X\/6QWDAAQgAAEILBgCTHwsmENNR6eYwChWuXCTPMUnEF0bGYHzC2rySy+HYU8qKPSiAv9CcV+tjvq\/q0T\/8caTE\/8tRY8IyT2Q\/S7IvUbgq3JtWpWAeAhAAAIQgAAE5hLgV9y5PAhBYBIJ+C3\/qfkX3b1T5wBhJj4GgEdWCMwSOEfby6WtEyKHKHx84usieGhQiMcLr2pY6LZUAF4mnSql7\/zw8fm49FypS\/tlUNiDAl+VKz1\/qtITDwEIQAACEFjwBJj4WPCnAACmgED0kjovb\/cXrL6\/7HUK8NMFCNQm4NVZJ0tvTXJ4ZcZjpPMS\/yDBRyrznkEBn5dv2P9JJqi2l66vqVUflN4YtO458vllqB8N4tq6oomPNpMYbfK0bTP5IAABCEAAAlNBgEddpuIw0okFTsATHKn52t4ldRKGAATGTuCkgha8V\/6uPpO9gsHlRXZi5FzAvrep79H7Pozkn6U2KzKcN7JfBM7t5Nsw8Je5\/IJWDAIQgAAEIACBBgS6uslqUCVJIQCBjgn439beEJS5b+Crcr1SCX4u+ZfnUyR\/eXqJhEEAAt0Q8PXqf5uamldnHJU6W4bfrHz7BHmXynd24F\/IrtvUeT9qdFcAwS87PS7wt3UtUcY7kswbKPzaxFcWdJsOL0tAHAQgAAEIQAAC8wkw8TGfCR4ITBoB37D73QGpvUWORamzJLye4t4l+d867i69QPpr6aUSBgEIdEfgMBUVPW7yDvkHnWh8nsp4T0FT\/UjH3QVxC9l9rjp\/TAGA\/eU\/sCCuqXu5MvhRp9SOkKPuqo83KO390wJ6Fo4mkdbsWRtpDgQgAAEILDACTHwssANOd6eWwKeCnnki49jAX+TyJMdmQeS\/BT5cEIBAewJe9XF0kN2fyb6WPQGyWhBf5Xq9Enil1lpBQr+s80uBH9dKAu\/UxisyIvuQnNG\/oo3SVvnerQTpqg9PZLxPqron8+OLR0h9t1uCBtad2Amy4oIABCAAAQgMTqDqQ3bwGigBAhAYBYEvqJLopt2\/Vh4nrV\/RiEMUf1SQZql8Xwn8uCAAgcEI+DGy8wuK+Dv5vQrhCQXxqXs3Oc6S\/KLO6HP9EvmjF3jKjc0S8Jd1P+oXmSeE3x9FtPBdqjyfDPK9Sr7TpU2COLu8SsjnxEYO9NyiiQ+vJNyq5+2meRCAAAQgMMUEWHo4xQeXri0oAneqt36u\/4tBr31D\/VTJ\/6HAj8Tkf23cRuG3Sy+Xol+Y\/UXKZWMQgEC3BHwdHiT5X8tuHxS9u3xnS54c8eTjYulK6TrJX379n5v2kJ4lOW10\/cp9r5ulg6WbHMBKCXji4QTpL4JUnhw+UfpmENfU5Ymtl0rrJBn3UvhC6X8lvwfmWskvMvUE2OOkSbEbg4auLd+Z0kmSz2OvSvLn1VUSBgEIQAACEIAABCaawIxaf3eiqqXWdyXplyvcxA5Q4rTO6Jlql+lf8dK0lzuiwPwSvDR90ZcNFzHKvmRN9pLstI35sPvwfelrkm+wzTcfn9\/3F4Cy\/ikagwAEBiTgRyjOkPLXXlf7F6ncHRq0bxxjVoPmrUrqiZyUkSd4urAHqJDfS2n5Dl8irSdF1vTzwRPRUR1tfWdGjZr1DXpc9wnaempJfY5aFuRJ+3ZQRRlEQwACEIAABDojEC2J7axwCoIABEZO4M2q8RMltfoXRi+L30\/aUSpa9eWbWv\/C6RtVDAIQGB6Ba1T006XjOq7iMyrPK0F+1nG5017cH9TBNxV0cnv531UQ19T9UWXw+zqajrGexPhqUFn0stwg2chcXrVSZQ+vSkA8BCAAAQhAoCsCTHx0RZJyINAPAl7BcZjkG\/ebWjTJN8\/+AvYCyUvxMQhAYPgEfK35X5T+meTHLZp+GVaWVfYD7flRjRdLXa2CWFX4Atnxajcfh8g8tu4aRbTw\/Yvy7CH9tGZe\/6txPw7jx0VSuz11jDn8OtV\/TkUbmPioAEQ0BCAAAQh0R4CJj+5YUtJ8Al4unFrkS9Pkw7\/LB2rsNy0\/LbJJff5lsMkXlCZlu12D9OUY5d9O8o31b6Qq802zJzz8i+bh0q0SBgEIjJbA\/6g6r\/7YUfqwVHfi4gal\/Yjk1VyW30XRhY1yzGrS3qhdka9JmWlav+j0ltSpsFfJvT7wp666nw9nK+Mukh8n8SqQH0oes++UXL8fr\/G7MA6UdpYWS+tIqdU9V5yvKaum6V2H276\/9FnpeimybSInPghAAAIQgMAwCPD8\/jCoUiYE+kdgJzVpd2mTWfnm\/XLpUumyWbVZIaKsGAQgMCQCvk63lhZJ285uN9PWX6qXzWqptkukvv3iryZhQyJwpMr9x6RsT3YXPaKTJB150OexP382l3zf6Zeb+vPHEzx+dAeDAAQgAAEIQAACEIAABCAAAQhAYEoIeHXHcyVPRhe9KLWqqx9XAq82zMvvd8IgAAEIQAACEIAABCAAAQhAAAIQgMBYCZym2rMJC6928ModP5ZY1zZQwmukrIxs+7S6BZAOAhCAAAQgsBAJrL4QO02fIQABCEAAAhCAwBgI\/CxXpx\/78KNMz8r5qnb97pGNk0SeQPl+4iMIAQhAAAIQgAAEIAABCEAAAhCAAARGTuBQ1Zit0si2fpH1tjVacoDS+D8AZfmyrVeRYBCAAAQgAAEIQAACEIAABCAAAQhAYOwEHq0WZBMW+e1V8v+1dO+ghY+Q73jJ\/248n8f7ngh5vIRBAAIQgAAEIAABCEAAAhCAAAQgAIFeEPiYWpFOYGTh5YpbKv2fdIF0tZTFRdujFY9BAAIQgAAEIAABCEAAAhCAAAQgAIHeEFhbLTlHiiYymvhOUhn+V7EYBCAAAQhAAAIQgAAEIAABCEAAAhDoFYHN1ZovS34xaZPJDqe9RfpLCYMABCAAAQhAAAIQgAAEIAABCEAAAr0msKNad4LkR1yqJkAuUpq3Sg+UMAhAAAIQgAAEGhDwv1LDIAABCEAAAhCAAATGR2BdVb2NtGhWnty4VbpyVpdr+3MJgwAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAAAQgAAEIQAACEIAABCAAAQhAAAIQgAAEIAABCEAAAhCAwMIk8P+WFHGpcpa3TAAAAABJRU5ErkJggg==","width":323}
%---
%[control:button:729f]
%   data: {"label":"Choose audio source","run":"Section"}
%---
%[control:dropdown:audio_source]
%   data: {"defaultValue":"\"Sample audio\"","itemLabels":["Sample audio","Computer","Mobile device"],"items":["\"Sample audio\"","\"Computer\"","\"Mobile device\""],"label":"Audio source","run":"Nothing"}
%---
%[control:slider:2b17]
%   data: {"defaultValue":130,"label":"minPitch","max":300,"min":80,"run":"Nothing","runOn":"ValueChanging","step":5}
%---
%[control:slider:1ed5]
%   data: {"defaultValue":1050,"label":"maxPitch","max":2000,"min":600,"run":"Nothing","runOn":"ValueChanging","step":10}
%---
%[control:button:009c]
%   data: {"label":"Build the rainbow!","run":"Section"}
%---
%[control:editfield:30cf]
%   data: {"defaultValue":10,"label":"Record Seconds","run":"Nothing","valueType":"Double"}
%---
%[control:button:255f]
%   data: {"label":"Load or record my sound!","run":"Section"}
%---
%[control:button:6370]
%   data: {"label":"Listen","run":"Section"}
%---
%[control:slider:923e]
%   data: {"defaultValue":0.05,"label":"frameTime","max":0.2,"min":0.02,"run":"Nothing","runOn":"ValueChanging","step":0.01}
%---
%[control:slider:7682]
%   data: {"defaultValue":0.05,"label":"silenceLevel","max":0.3,"min":0,"run":"Nothing","runOn":"ValueChanging","step":0.01}
%---
%[control:button:1f3b]
%   data: {"label":"Create sound slices!","run":"Section"}
%---
%[control:button:71be]
%   data: {"label":"See the pitches and the summary!","run":"Section"}
%---
%[control:slider:015a]
%   data: {"defaultValue":80,"label":"minFreq","max":4000,"min":0,"run":"Nothing","runOn":"ValueChanging","step":100}
%---
%[control:slider:8767]
%   data: {"defaultValue":4000,"label":"maxFreq","max":4000,"min":0,"run":"Nothing","runOn":"ValueChanging","step":100}
%---
%[control:slider:2347]
%   data: {"defaultValue":0.05,"label":"windowTime","max":0.1,"min":0.01,"run":"Nothing","runOn":"ValueChanging","step":0.01}
%---
%[control:slider:7ed7]
%   data: {"defaultValue":75,"label":"overlapPercent","max":90,"min":0,"run":"Nothing","runOn":"ValueChanging","step":10}
%---
%[control:button:7f95]
%   data: {"label":"Make a spectrogram!","run":"Section"}
%---
