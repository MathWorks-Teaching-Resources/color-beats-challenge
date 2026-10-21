classdef ColorBeatsApp < handle
    % COLORBEATSAPP  Interactive Color Beats Challenge.
    %
    % Records a sound with the microphone, then shows five views:
    %   1. Color Key       - the pitch-to-color rainbow (with note labels)
    %   2. Waveform        - the raw sound wiggle
    %   3. Painting        - each moment shown as one colored stripe
    %   4. Pitches         - a scatter of the exact pitch behind each stripe
    %   5. Spectrogram     - every pitch at every moment, all at once
    %
    % Every slider updates the relevant views live.
    %
    % Runs on MATLAB Mobile using the built-in microphone (mobiledev).
    % Falls back to audiorecorder on desktop when Mobile is not available.
    % A Demo Sound button generates a synthetic recording for classroom use
    % when no microphone is available.
    %
    % Usage:
    %   app = ColorBeatsApp;
    %
    % Copyright 2026 The MathWorks, Inc.

    properties (Access = private)
        % ---- Figure and layout ----
        UIFigure
        MainStatusLabel

        % ---- Recording controls ----
        RecordSecondsField
        RecordButton
        DemoButton
        StatusLamp
        StatusLabel

        % ---- Sliders + value labels ----
        MinPitchSlider,    MinPitchValueLabel
        MaxPitchSlider,    MaxPitchValueLabel
        FrameTimeSlider,   FrameTimeValueLabel
        SilenceLevelSlider,SilenceLevelValueLabel

        WindowTimeSlider,  WindowTimeValueLabel
        OverlapSlider,     OverlapValueLabel
        MinFreqSlider,     MinFreqValueLabel
        MaxFreqSlider,     MaxFreqValueLabel

        % ---- Axes (views) ----
        ColorKeyAxes
        WaveformAxes
        PaintingAxes
        ScatterAxes
        SpectrogramAxes
        SummaryLabel

        % ---- State ----
        MobileDevice
        AudioData double = []
        SampleRate double = 44100
    end

    methods
        function app = ColorBeatsApp()
            app.createComponents();
            app.updateAllValueLabels();
            app.refreshColorKey();
            app.showEmptyState();
        end

        function delete(app)
            app.releaseRecorder();
            if ~isempty(app.UIFigure) && isvalid(app.UIFigure)
                app.UIFigure.CloseRequestFcn = [];
                delete(app.UIFigure)
            end
        end
    end

    % =====================================================================
    % LAYOUT
    % =====================================================================
    methods (Access = private)
        function createComponents(app)
            % MATLAB Mobile cannot display uifigure windows, so this app
            % cannot run there. Catch that up front and say so plainly,
            % instead of letting a low-level error confuse a student.
            try
                app.UIFigure = uifigure( ...
                    "Name", "Color Beats Challenge", ...
                    "Position", [80 60 1180 780]);
            catch ME
                error("ColorBeatsApp:UnsupportedPlatform", ...
                    "ColorBeatsApp needs MATLAB Desktop or MATLAB Online in a browser.\n\n" + ...
                    "It cannot run in MATLAB Mobile, because MATLAB Mobile does not " + ...
                    "support the app windows this app is built from.\n\n" + ...
                    "On an iPad, open ColorBeatsChallenge_Student_v5.mlx instead. " + ...
                    "It has the same activity with sliders and buttons that do work there.\n\n" + ...
                    "(Original error: %s)", ME.message);
            end
            app.UIFigure.CloseRequestFcn = @(~, ~) app.closeApp();

            rootGrid = uigridlayout(app.UIFigure, [1 2]);
            rootGrid.ColumnWidth   = {370, "1x"};
            rootGrid.RowHeight     = {"1x"};
            rootGrid.Padding       = [0 0 0 0];
            rootGrid.ColumnSpacing = 0;

            app.buildSidebar(rootGrid);
            app.buildMainArea(rootGrid);
        end

        function buildSidebar(app, rootGrid)
            sidePanel = uipanel(rootGrid, "Title", "Controls");
            sidePanel.Layout.Row = 1;
            sidePanel.Layout.Column = 1;

            sideGrid = uigridlayout(sidePanel, [20 3]);
            sideGrid.RowHeight     = [repmat({"fit"}, 1, 19), {"1x"}];
            sideGrid.ColumnWidth   = {110, "1x", 74};
            sideGrid.Padding       = [12 10 12 10];
            sideGrid.RowSpacing    = 6;
            sideGrid.ColumnSpacing = 8;
            sideGrid.Scrollable    = "on";

            % ---- Section: Recording ----
            addHeaderLabel(sideGrid, "Recording", 1);

            addLabel(sideGrid, "Seconds", 2, 1);
            app.RecordSecondsField = uieditfield(sideGrid, "numeric", ...
                "Value", 10, ...
                "Limits", [1 60], ...
                "RoundFractionalValues", "on", ...
                "ValueDisplayFormat", "%.0f s");
            app.RecordSecondsField.Layout.Row = 2;
            app.RecordSecondsField.Layout.Column = [2 3];

            app.RecordButton = uibutton(sideGrid, "push", ...
                "Text", "Record", ...
                "FontWeight", "bold", ...
                "BackgroundColor", [0.85 0.25 0.25], ...
                "FontColor", [1 1 1], ...
                "ButtonPushedFcn", @(~, ~) app.startFixedRecording());
            app.RecordButton.Layout.Row = 3;
            app.RecordButton.Layout.Column = [1 2];

            app.DemoButton = uibutton(sideGrid, "push", ...
                "Text", "Demo Sound", ...
                "ButtonPushedFcn", @(~, ~) app.loadDemoSound());
            app.DemoButton.Layout.Row = 3;
            app.DemoButton.Layout.Column = 3;

            app.StatusLamp = uilamp(sideGrid, "Color", [0.55 0.55 0.55]);
            app.StatusLamp.Layout.Row = 4;
            app.StatusLamp.Layout.Column = 1;
            app.StatusLabel = uilabel(sideGrid, ...
                "Text", "Ready. Press Record.", ...
                "FontWeight", "bold");
            app.StatusLabel.Layout.Row = 4;
            app.StatusLabel.Layout.Column = [2 3];

            % ---- Section: Color Key & Painting ----
            addHeaderLabel(sideGrid, "Color Key & Painting", 5);

            [app.MinPitchSlider, app.MinPitchValueLabel] = addSliderRow( ...
                sideGrid, "Min pitch", 6, [60 500], 130, "130 Hz", ...
                @(~, ~) app.onColorKeyChanged(), ...
                @(~, e) app.setValueLabel(app.MinPitchValueLabel, "%.0f Hz", e.Value));

            [app.MaxPitchSlider, app.MaxPitchValueLabel] = addSliderRow( ...
                sideGrid, "Max pitch", 7, [400 2500], 1050, "1050 Hz", ...
                @(~, ~) app.onColorKeyChanged(), ...
                @(~, e) app.setValueLabel(app.MaxPitchValueLabel, "%.0f Hz", e.Value));

            [app.FrameTimeSlider, app.FrameTimeValueLabel] = addSliderRow( ...
                sideGrid, "Frame time", 8, [0.01 0.30], 0.05, "0.050 s", ...
                @(~, ~) app.onPaintingChanged(), ...
                @(~, e) app.setValueLabel(app.FrameTimeValueLabel, "%.3f s", e.Value));

            [app.SilenceLevelSlider, app.SilenceLevelValueLabel] = addSliderRow( ...
                sideGrid, "Silence level", 9, [0 0.30], 0.05, "0.05", ...
                @(~, ~) app.onPaintingChanged(), ...
                @(~, e) app.setValueLabel(app.SilenceLevelValueLabel, "%.2f", e.Value));

            % ---- Section: Spectrogram ----
            addHeaderLabel(sideGrid, "Spectrogram", 10);

            [app.WindowTimeSlider, app.WindowTimeValueLabel] = addSliderRow( ...
                sideGrid, "Window", 11, [0.01 0.20], 0.05, "0.050 s", ...
                @(~, ~) app.onSpectrogramChanged(), ...
                @(~, e) app.setValueLabel(app.WindowTimeValueLabel, "%.3f s", e.Value));

            [app.OverlapSlider, app.OverlapValueLabel] = addSliderRow( ...
                sideGrid, "Overlap", 12, [0 90], 75, "75%", ...
                @(~, ~) app.onSpectrogramChanged(), ...
                @(~, e) app.setValueLabel(app.OverlapValueLabel, "%.0f%%", e.Value));

            [app.MinFreqSlider, app.MinFreqValueLabel] = addSliderRow( ...
                sideGrid, "Min freq", 13, [20 1000], 80, "80 Hz", ...
                @(~, ~) app.onSpectrogramChanged(), ...
                @(~, e) app.setValueLabel(app.MinFreqValueLabel, "%.0f Hz", e.Value));

            [app.MaxFreqSlider, app.MaxFreqValueLabel] = addSliderRow( ...
                sideGrid, "Max freq", 14, [500 8000], 4000, "4000 Hz", ...
                @(~, ~) app.onSpectrogramChanged(), ...
                @(~, e) app.setValueLabel(app.MaxFreqValueLabel, "%.0f Hz", e.Value));

            % ---- Section: Summary text ----
            addHeaderLabel(sideGrid, "What did you make?", 15);
            app.SummaryLabel = uilabel(sideGrid, ...
                "Text", "Record a sound to see a summary.", ...
                "WordWrap", "on", ...
                "VerticalAlignment", "top");
            app.SummaryLabel.Layout.Row = [16 19];
            app.SummaryLabel.Layout.Column = [1 3];
        end

        function buildMainArea(app, rootGrid)
            mainPanel = uipanel(rootGrid, "BorderType", "none");
            mainPanel.Layout.Row = 1;
            mainPanel.Layout.Column = 2;

            mainGrid = uigridlayout(mainPanel, [6 1]);
            mainGrid.RowHeight     = {180, 180, 180, 220, 260, 30};
            mainGrid.ColumnWidth   = {"1x"};
            mainGrid.Padding       = [14 12 14 12];
            mainGrid.RowSpacing    = 10;
            mainGrid.Scrollable    = "on";

            % Row 1: Color Key
            app.ColorKeyAxes = uiaxes(mainGrid);
            app.ColorKeyAxes.Layout.Row = 1;
            app.ColorKeyAxes.Layout.Column = 1;
            app.ColorKeyAxes.Box = "on";
            title(app.ColorKeyAxes, "Color Key: pitch to color");

            % Row 2: Waveform
            app.WaveformAxes = uiaxes(mainGrid);
            app.WaveformAxes.Layout.Row = 2;
            app.WaveformAxes.Layout.Column = 1;
            app.WaveformAxes.Box = "on";
            title(app.WaveformAxes, "Your sound as a wiggle");

            % Row 3: Painting
            app.PaintingAxes = uiaxes(mainGrid);
            app.PaintingAxes.Layout.Row = 3;
            app.PaintingAxes.Layout.Column = 1;
            app.PaintingAxes.Box = "on";
            title(app.PaintingAxes, "Your sound as a painting");

            % Row 4: Scatter
            app.ScatterAxes = uiaxes(mainGrid);
            app.ScatterAxes.Layout.Row = 4;
            app.ScatterAxes.Layout.Column = 1;
            app.ScatterAxes.Box = "on";
            title(app.ScatterAxes, "The pitch behind each color");

            % Row 5: Spectrogram
            app.SpectrogramAxes = uiaxes(mainGrid);
            app.SpectrogramAxes.Layout.Row = 5;
            app.SpectrogramAxes.Layout.Column = 1;
            app.SpectrogramAxes.Box = "on";
            title(app.SpectrogramAxes, "Your sound as a spectrogram");

            % Row 6: Status label
            app.MainStatusLabel = uilabel(mainGrid, ...
                "Text", "", ...
                "FontAngle", "italic");
            app.MainStatusLabel.Layout.Row = 6;
            app.MainStatusLabel.Layout.Column = 1;
        end
    end

    % =====================================================================
    % RECORDING
    % =====================================================================
    methods (Access = private)
        function startFixedRecording(app)
            app.releaseRecorder();
            recordSeconds = app.RecordSecondsField.Value;

            % Prefer MATLAB Mobile; if unavailable, fall back to audiorecorder.
            try
                app.recordFromMobile(recordSeconds);
            catch mobileErr
                try
                    app.recordFromDesktop(recordSeconds);
                catch deskErr
                    app.setControlsEnabled(true);
                    app.setStatus("Mic unavailable", [0.85 0.20 0.20]);
                    message = sprintf(...
                        "Could not record from any microphone.\n\n" + ...
                        "MATLAB Mobile: %s\n\nDesktop: %s\n\n" + ...
                        "Try 'Demo Sound' to test the app without a microphone.", ...
                        mobileErr.message, deskErr.message);
                    uialert(app.UIFigure, message, "Microphone unavailable");
                    return
                end
            end

            % Once audio is captured, refresh everything downstream.
            app.refreshAllPlots();
            app.setStatus("Ready. Press Record.", [0.20 0.65 0.30]);
            app.setControlsEnabled(true);
        end

        function recordFromMobile(app, recordSeconds)
            app.MobileDevice = ColorBeatsApp.getOrCreateMobileDevice();
            if ~app.MobileDevice.Connected
                error("ColorBeatsApp:MobileNotConnected", ...
                    "MATLAB Mobile is not connected. Turn on Sensor Access: menu -> Sensors -> More.");
            end

            app.MobileDevice.MicrophoneEnabled = 1;
            try
                discardlogs(app.MobileDevice);
            catch
                % discardlogs is not critical; ignore if it isn't available
            end

            app.setControlsEnabled(false);
            app.doCountdownAndRecord(recordSeconds, "mobile");

            audio = readAudio(app.MobileDevice);
            fs    = app.MobileDevice.Microphone.SampleRate;
            app.MobileDevice.MicrophoneEnabled = 0;

            app.storeAudio(audio, fs);
        end

        function recordFromDesktop(app, recordSeconds)
            fs = 44100;
            recorder = audiorecorder(fs, 16, 1);

            app.setControlsEnabled(false);

            % Countdown, then record.
            for k = 3:-1:1
                app.setStatus(sprintf("Get ready... %d", k), [0.95 0.65 0.10]);
                drawnow
                pause(1)
            end
            record(recorder);
            for sec = 1:recordSeconds
                remaining = recordSeconds - sec + 1;
                app.setStatus(sprintf("Recording... %d s left", remaining), [0.95 0.25 0.25]);
                drawnow
                pause(1)
            end
            stop(recorder);
            audio = getaudiodata(recorder, "double");
            app.storeAudio(audio, fs);
        end

        function doCountdownAndRecord(app, recordSeconds, ~)
            % Shared UI updates for the Mobile path.
            for k = 3:-1:1
                app.setStatus(sprintf("Get ready... %d", k), [0.95 0.65 0.10]);
                drawnow
                pause(1)
            end
            app.MobileDevice.Logging = 1;
            for sec = 1:recordSeconds
                remaining = recordSeconds - sec + 1;
                app.setStatus(sprintf("Recording... %d s left", remaining), [0.95 0.25 0.25]);
                drawnow
                pause(1)
            end
            app.MobileDevice.Logging = 0;
        end

        function storeAudio(app, audio, fs)
            if isempty(audio)
                error("ColorBeatsApp:EmptyAudio", ...
                    "No audio came through. Check that the microphone is on.");
            end
            y = mean(audio, 2);
            y = y(:);
            if max(abs(y)) == 0
                error("ColorBeatsApp:SilentAudio", ...
                    "The recording is silent. Try again a bit louder.");
            end
            app.AudioData  = y / max(abs(y));
            app.SampleRate = fs;
        end

        function loadDemoSound(app)
            % A hum -> whistle sweep, a bit of "shhh" noise, a low hum ending.
            fs = 44100;
            duration = 8;
            t = (0:1/fs:duration).';
            y = zeros(size(t));

            % 0.0-2.0 s: steady hum at 220 Hz
            first = t < 2.0;
            y(first) = 0.35*sin(2*pi*220*t(first));

            % 2.0-4.5 s: rising sweep 300 -> 900 Hz
            sweep = t >= 2.0 & t < 4.5;
            tS = t(sweep) - 2.0;
            y(sweep) = 0.35*sin(2*pi*(300 + (900-300)/2.5/2*tS).*tS);

            % 4.5-5.5 s: silence (with tiny noise)
            silent = t >= 4.5 & t < 5.5;
            y(silent) = 0.01*randn(nnz(silent), 1);

            % 5.5-6.5 s: "shhhh" white noise burst
            shhh = t >= 5.5 & t < 6.5;
            y(shhh) = 0.30*randn(nnz(shhh), 1);

            % 6.5-8.0 s: whistle at 700 Hz
            whistle = t >= 6.5;
            y(whistle) = 0.35*sin(2*pi*700*t(whistle));

            app.storeAudio(y, fs);
            app.refreshAllPlots();
            app.setStatus("Demo sound loaded.", [0.20 0.65 0.30]);
        end

        function setControlsEnabled(app, enabled)
            state = "on";
            if ~enabled, state = "off"; end
            app.RecordButton.Enable       = state;
            app.DemoButton.Enable         = state;
            app.RecordSecondsField.Enable = state;
        end

        function setStatus(app, text, color)
            app.StatusLabel.Text = text;
            app.StatusLamp.Color = color;
        end

        function releaseRecorder(app)
            try
                if ~isempty(app.MobileDevice)
                    app.MobileDevice.Logging = 0;
                    app.MobileDevice.MicrophoneEnabled = 0;
                end
            catch
            end
            app.MobileDevice = [];
        end

        function closeApp(app)
            delete(app)
        end
    end

    % =====================================================================
    % SLIDER CALLBACKS
    % =====================================================================
    methods (Access = private)
        function onColorKeyChanged(app)
            app.updateAllValueLabels();
            app.refreshColorKey();
            app.refreshPaintingAndScatter();
        end

        function onPaintingChanged(app)
            app.updateAllValueLabels();
            app.refreshPaintingAndScatter();
        end

        function onSpectrogramChanged(app)
            app.updateAllValueLabels();
            app.refreshSpectrogram();
        end

        function refreshAllPlots(app)
            app.refreshColorKey();
            app.refreshWaveform();
            app.refreshPaintingAndScatter();
            app.refreshSpectrogram();
        end

        function refreshColorKey(app)
            % Draw a rainbow from minPitch to maxPitch with musical-note labels.
            ax = app.ColorKeyAxes;
            cla(ax);

            minPitch = app.MinPitchSlider.Value;
            maxPitch = app.MaxPitchSlider.Value;
            if maxPitch <= minPitch
                title(ax, "Max pitch must be larger than min pitch");
                return
            end

            keyFreq = logspace(log10(minPitch), log10(maxPitch), 400);
            keyHue  = 0.8 * (log2(keyFreq) - log2(minPitch)) / ...
                     (log2(maxPitch) - log2(minPitch));
            hsvKey  = zeros(1, numel(keyFreq), 3);
            hsvKey(1,:,1) = keyHue;
            hsvKey(1,:,2) = 1;
            hsvKey(1,:,3) = 1;
            image(ax, [1 numel(keyFreq)], [0 1], ...
                repmat(hsv2rgb(hsvKey), 40, 1, 1));
            set(ax, "YTick", []);

            % Auto-label with musical notes across the range.
            numLabels   = 7;
            targetFreqs = logspace(log10(minPitch), log10(maxPitch), numLabels);
            noteFreqs   = zeros(1, numLabels);
            notes       = strings(1, numLabels);
            for k = 1:numLabels
                [notes(k), noteFreqs(k)] = ColorBeatsApp.freq2note(targetFreqs(k));
            end
            xTicks = interp1(keyFreq, 1:numel(keyFreq), noteFreqs, "linear", "extrap");
            xTicks = min(max(xTicks, 1), numel(keyFreq));
            set(ax, "XTick", xTicks, ...
                    "XTickLabel", compose("%s\n%.0f Hz", notes', noteFreqs'));
            title(ax, "Color Key: pitch to color");
            xlabel(ax, "Pitch");
        end

        function refreshWaveform(app)
            ax = app.WaveformAxes;
            cla(ax);
            if isempty(app.AudioData), return, end
            fs = app.SampleRate;
            y  = app.AudioData;
            t  = (0:numel(y)-1)/fs;
            plot(ax, t, y, "Color", [0.15 0.15 0.15]);
            xlim(ax, [0 t(end)]);
            ylim(ax, [-1.05 1.05]);
            grid(ax, "on");
            title(ax, "Your sound as a wiggle");
            xlabel(ax, "Time (seconds)");
            ylabel(ax, "Wiggle size");
        end

        function refreshPaintingAndScatter(app)
            paintAx   = app.PaintingAxes;
            scatterAx = app.ScatterAxes;
            cla(paintAx);
            cla(scatterAx);

            if isempty(app.AudioData)
                app.SummaryLabel.Text = "Record a sound to see a summary.";
                return
            end

            try
                painting = ColorBeatsApp.paintTheSound( ...
                    app.AudioData, app.SampleRate, ...
                    app.MinPitchSlider.Value, ...
                    app.MaxPitchSlider.Value, ...
                    app.FrameTimeSlider.Value, ...
                    app.SilenceLevelSlider.Value);
            catch ME
                title(paintAx, "Adjust settings: " + ME.message);
                app.SummaryLabel.Text = "Try different painting settings.";
                return
            end

            % Painting stripe.
            image(paintAx, [0 painting.duration], [0 1], ...
                repmat(painting.rgbStrip, 30, 1, 1));
            set(paintAx, "YTick", []);
            xlim(paintAx, [0 painting.duration]);
            title(paintAx, "Your sound as a painting");
            xlabel(paintAx, "Time (seconds)");

            % Scatter of pitch behind each stripe, colored to match.
            scatter(scatterAx, painting.frameTimes, painting.pitch, ...
                40, squeeze(painting.rgbStrip), "filled", ...
                "MarkerEdgeColor", [0.6 0.6 0.6]);
            xlim(scatterAx, [0 painting.duration]);
            ylim(scatterAx, [app.MinPitchSlider.Value app.MaxPitchSlider.Value]);
            grid(scatterAx, "on");
            title(scatterAx, "The pitch behind each color");
            xlabel(scatterAx, "Time (seconds)");
            ylabel(scatterAx, "Pitch (Hz)");

            % Summary text.
            heard = ~painting.isQuiet;
            if any(heard)
                avgPitch = mean(painting.pitch(heard), "omitnan");
                domColor = ColorBeatsApp.colorName(mean(painting.hue(heard)));
                silentPct = 100 * mean(painting.isQuiet);
                [noteName, noteHz] = ColorBeatsApp.freq2note(avgPitch);
                app.SummaryLabel.Text = sprintf(...
                    "Average pitch: %.0f Hz (about %s = %.0f Hz).\nMostly %s.\nSilent %.0f%% of the time.", ...
                    avgPitch, noteName, noteHz, domColor, silentPct);
            else
                app.SummaryLabel.Text = ...
                    "Everything was below the silence level. Try louder, or lower the silence level.";
            end
        end

        function refreshSpectrogram(app)
            ax = app.SpectrogramAxes;
            cla(ax);
            if isempty(app.AudioData), return, end

            try
                [S, F, T] = ColorBeatsApp.computeSpectrogram( ...
                    app.AudioData, app.SampleRate, ...
                    app.WindowTimeSlider.Value, ...
                    app.OverlapSlider.Value);
            catch ME
                title(ax, "Adjust settings: " + ME.message);
                return
            end

            brightness = 20*log10(abs(S) + eps);
            top = max(brightness(:));
            brightness = max(brightness, top - 60);

            imagesc(ax, T, F, brightness);
            axis(ax, "xy");
            ylim(ax, [app.MinFreqSlider.Value app.MaxFreqSlider.Value]);
            colormap(ax, turbo(256));
            if top - 60 < top
                clim(ax, [top - 60, top]);
            end
            colorbar(ax);
            title(ax, "Your sound as a spectrogram");
            xlabel(ax, "Time (seconds)");
            ylabel(ax, "Pitch (Hz)");
        end

        function showEmptyState(app)
            hint = "Record a sound (or press Demo Sound) to see the plots.";
            for ax = [app.WaveformAxes, app.PaintingAxes, ...
                      app.ScatterAxes, app.SpectrogramAxes]
                cla(ax);
                text(ax, 0.5, 0.5, hint, ...
                    "Units", "normalized", ...
                    "HorizontalAlignment", "center", ...
                    "Color", [0.5 0.5 0.5]);
                set(ax, "XTick", [], "YTick", []);
            end
        end

        function updateAllValueLabels(app)
            app.setValueLabel(app.MinPitchValueLabel,     "%.0f Hz", app.MinPitchSlider.Value);
            app.setValueLabel(app.MaxPitchValueLabel,     "%.0f Hz", app.MaxPitchSlider.Value);
            app.setValueLabel(app.FrameTimeValueLabel,    "%.3f s",  app.FrameTimeSlider.Value);
            app.setValueLabel(app.SilenceLevelValueLabel, "%.2f",    app.SilenceLevelSlider.Value);
            app.setValueLabel(app.WindowTimeValueLabel,   "%.3f s",  app.WindowTimeSlider.Value);
            app.setValueLabel(app.OverlapValueLabel,      "%.0f%%",  app.OverlapSlider.Value);
            app.setValueLabel(app.MinFreqValueLabel,      "%.0f Hz", app.MinFreqSlider.Value);
            app.setValueLabel(app.MaxFreqValueLabel,      "%.0f Hz", app.MaxFreqSlider.Value);
        end

        function setValueLabel(~, label, format, value)
            label.Text = sprintf(format, value);
        end
    end

    % =====================================================================
    % SIGNAL PROCESSING (all math is here; UI code above never touches it)
    % =====================================================================
    methods (Static, Access = private)

        function painting = paintTheSound(y, fs, minPitch, maxPitch, frameTime, silenceLevel)
            % Chop the sound into frames, measure each, map to HSV, return struct.
            if maxPitch <= minPitch
                error("Max pitch must be larger than min pitch.")
            end
            N = round(frameTime * fs);
            if N < 8, error("Frame time is too small."), end
            numFrames = floor(numel(y) / N);
            if numFrames < 2, error("Frame time is too big for this recording."), end

            frames = reshape(y(1:numFrames*N), N, numFrames);
            frameTimes = (0:numFrames-1) * frameTime;

            % Loudness.
            loudness = sqrt(mean(frames.^2, 1));

            % Pitch + purity via FFT.
            window   = 0.5 - 0.5*cos(2*pi*(0:N-1)'/(N-1));
            spectrum = abs(fft(frames .* window));
            spectrum = spectrum(1:floor(N/2), :);
            freqAxis = (0:floor(N/2)-1)' * (fs/N);
            inRange  = freqAxis >= minPitch & freqAxis <= maxPitch;
            if ~any(inRange)
                error("Pitch range does not fit this recording.")
            end
            band     = spectrum(inRange, :);
            bandFreq = freqAxis(inRange);
            [peakStrength, whichRow] = max(band, [], 1);
            pitch  = reshape(bandFreq(whichRow), 1, []);
            purity = peakStrength ./ (sum(band, 1) + eps);

            % HSV mapping.
            hue = 0.8 * ColorBeatsApp.clamp01( ...
                log2(pitch) - log2(minPitch), ...
                0, log2(maxPitch) - log2(minPitch));
            saturation = ColorBeatsApp.clamp01(purity, 0.02, 0.15);

            sorted    = sort(loudness);
            loudRef   = sorted(max(1, ceil(0.95*numFrames)));
            brightness = ColorBeatsApp.clamp01(loudness / loudRef, 0, 1) .^ 0.4;

            isQuiet = loudness < silenceLevel * loudRef;
            brightness(isQuiet) = 0;
            saturation(isQuiet) = 0;
            pitch(isQuiet)      = NaN;

            hsvStrip = zeros(1, numFrames, 3);
            hsvStrip(1,:,1) = hue;
            hsvStrip(1,:,2) = saturation;
            hsvStrip(1,:,3) = brightness;

            painting.rgbStrip   = hsv2rgb(hsvStrip);
            painting.frameTimes = frameTimes;
            painting.pitch      = pitch;
            painting.hue        = hue;
            painting.isQuiet    = isQuiet;
            painting.duration   = numel(y) / fs;
        end

        function [S, F, T] = computeSpectrogram(y, fs, windowTime, overlapPercent)
            y = y(:);
            nWindow = max(16, round(windowTime * fs));
            nWindow = min(nWindow, numel(y));
            nOverlap = min(max(round(nWindow * overlapPercent / 100), 0), nWindow - 1);
            window = ColorBeatsApp.hannWindow(nWindow);

            if exist("spectrogram", "file") == 2 || exist("spectrogram", "builtin") == 5
                try
                    [S, F, T] = spectrogram(y, window, nOverlap, nWindow, fs);
                    return
                catch
                end
            end

            % Base-MATLAB fallback.
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

        function w = hannWindow(nWindow)
            if nWindow == 1
                w = 1;
            else
                w = 0.5 - 0.5*cos(2*pi*(0:nWindow-1)'/(nWindow-1));
            end
        end

        function out = clamp01(x, lo, hi)
            out = (x - lo) ./ (hi - lo);
            out = min(max(out, 0), 1);
        end

        function [name, snappedFreq] = freq2note(f)
            noteNames = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
            midiNumber  = round(69 + 12*log2(f/440));
            snappedFreq = 440 * 2^((midiNumber-69)/12);
            octave      = floor(midiNumber/12) - 1;
            name        = sprintf("%s%d", noteNames(mod(midiNumber,12)+1), octave);
        end

        function name = colorName(h)
            names = ["red","orange","yellow","green","teal","cyan","blue","violet"];
            idx   = min(8, max(1, floor(h/0.8 * 8) + 1));
            name  = names(idx);
        end

        function m = getOrCreateMobileDevice()
            % Return a mobiledev instance, reusing any existing one from
            % the base workspace so a fresh mobiledev() call doesn't hit
            % the "already exists" error if the student ran a script first.
            try
                m = mobiledev;
            catch ME
                if contains(ME.message, "already exists", "IgnoreCase", true)
                    m = ColorBeatsApp.findBaseMobileDevice();
                    if ~isempty(m), return, end
                end
                rethrow(ME)
            end
        end

        function m = findBaseMobileDevice()
            m = [];
            try
                vars = evalin("base", "whos");
            catch
                return
            end
            for k = 1:numel(vars)
                if contains(string(vars(k).class), "mobiledev", "IgnoreCase", true)
                    try
                        m = evalin("base", vars(k).name);
                        return
                    catch
                    end
                end
            end
        end
    end
end

% =====================================================================
% Layout helpers (local functions, not class methods)
% =====================================================================
function [slider, valueLabel] = addSliderRow(parent, labelText, row, limits, value, valueText, changedFcn, changingFcn)
    label = uilabel(parent, "Text", labelText);
    label.Layout.Row = row;
    label.Layout.Column = 1;
    label.VerticalAlignment = "center";

    slider = uislider(parent, ...
        "Limits", limits, ...
        "Value", value, ...
        "ValueChangedFcn", changedFcn, ...
        "ValueChangingFcn", changingFcn);
    slider.Layout.Row = row;
    slider.Layout.Column = 2;

    valueLabel = uilabel(parent, ...
        "Text", valueText, ...
        "HorizontalAlignment", "right");
    valueLabel.Layout.Row = row;
    valueLabel.Layout.Column = 3;
end

function label = addLabel(parent, text, row, column)
    label = uilabel(parent, "Text", text);
    label.Layout.Row = row;
    label.Layout.Column = column;
end

function label = addHeaderLabel(parent, text, row)
    label = uilabel(parent, "Text", text, "FontWeight", "bold");
    label.Layout.Row = row;
    label.Layout.Column = [1 3];
end
