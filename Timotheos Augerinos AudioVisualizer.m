classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        GridLayout                  matlab.ui.container.GridLayout
        LeftPanel                   matlab.ui.container.Panel
        Image                       matlab.ui.control.Image
        Chooseanmp3fileButton       matlab.ui.control.Button
        playpauseButton             matlab.ui.control.StateButton
        TextArea                    matlab.ui.control.TextArea
        chooseButtonLABEL           matlab.ui.control.Label
        Label                       matlab.ui.control.Label
        RightPanel                  matlab.ui.container.Panel
        TimeScopeVisualizerButton   matlab.ui.control.Button
        TimeScopeVisualizer2Button  matlab.ui.control.Button
        SpectrumVisualiserButton    matlab.ui.control.Button
        Label_2                     matlab.ui.control.Label
        Label_3                     matlab.ui.control.Label
        Label_4                     matlab.ui.control.Label
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = private)
        player% Description
        gurdian = 1 ;% metabliti frouros gia to stateButton
        filename
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: Chooseanmp3fileButton
        function Chooseanmp3fileButtonPushed(app, event)
          
            [file, path]=uigetfile('*.mp3');
            app.filename = [path file];      
            
            [data, fs] = audioread(app.filename);
            
            
            app.player = audioplayer(data, fs);
            
            
            app.TextArea.Value = app.filename;
            
            
            
        end

        % Value changed function: playpauseButton
        function playpauseButtonValueChanged(app, event)
               
            if app.player.Running() == "off"
                if app.gurdian == 1
                    play(app.player);
                    app.gurdian =0;
                else
                    resume(app.player);
                end
            elseif app.player.Running() == "on"
                pause(app.player);
                
            end                    
        end

        % Button pushed function: TimeScopeVisualizerButton
        function TimeScopeVisualizerButtonPushed(app, event)
            frameLength = 1024;

            fileReader = dsp.AudioFileReader( ...
             app.filename, ...
            'SamplesPerFrame',frameLength);

             deviceWriter = audioDeviceWriter( ...
                  'SampleRate',fileReader.SampleRate);

             scope = timescope( ...    
                  'SampleRate',fileReader.SampleRate,...    
                  'TimeSpan',2, ...       
                  'YLimits',[-1,1], ... 
                  'Title',app.filename,...
                  'ChannelNames',{'channel 1','channel 2'},...
                  'TimeSpanOverrunAction',"Scroll");

             while ~isDone(fileReader)
                  signal = fileReader();
                  deviceWriter(signal);
                  scope(signal)
             end

            release(fileReader);
            release(deviceWriter);
            release(scope);    
        end

        % Button pushed function: TimeScopeVisualizer2Button
        function TimeScopeVisualizer2ButtonPushed(app, event)
            frameLength = 1024;
            
            fileReader = dsp.AudioFileReader( ...
                app.filename, ...
                'SamplesPerFrame',frameLength);
            
            deviceWriter = audioDeviceWriter( ...
                'SampleRate',fileReader.SampleRate);
            
            scope = dsp.TimeScope('SampleRate',fileReader.SampleRate, ...
                'TimeSpan',1, ...
                'Title',app.filename,...
                'TimeSpanOverrunAction','Scroll', ...
                'AxesScaling','Manual', ...
                'BufferLength',4*fileReader.SampleRate, ...
                'ShowLegend',true, ...
                'ChannelNames',{'Channel 1','Channel 2'}, ...
                'ShowGrid',true, ...
                'YLimits',[-1 1]);
            
            
            while ~isDone(fileReader)
                signal = fileReader();
                deviceWriter(signal);
                scope(signal)
            end
            
            release(fileReader);
            release(deviceWriter);
            release(scope);    
        end

        % Button pushed function: SpectrumVisualiserButton
        function SpectrumVisualiserButtonPushed(app, event)
            frameLength = 1024;

            fileReader = dsp.AudioFileReader( ...
                app.filename, ...
                'SamplesPerFrame',frameLength);
            
            deviceWriter = audioDeviceWriter( ...
                'SampleRate',fileReader.SampleRate);
            
            scope = dsp.SpectrumAnalyzer('SampleRate',fileReader.SampleRate, ...
                'PlotAsTwoSidedSpectrum',true, ...
                'FrequencyScale','Linear', ...
                'ShowLegend',true, ... 
                'ChannelNames',{'Channel 1','Channel 2'}, ...
                'Title',app.filename,...
                'YLimits',[-100 100]);
            
            
            while ~isDone(fileReader)
                signal = fileReader();
                deviceWriter(signal);
                scope(signal)
            end
            
            release(fileReader);
            release(deviceWriter);
            release(scope);    
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {472, 472};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {311, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Color = [0.149 0.149 0.149];
            app.UIFigure.Colormap = [0.2431 0.149 0.6588;0.2431 0.1529 0.6745;0.2471 0.1569 0.6863;0.2471 0.1608 0.698;0.251 0.1647 0.7059;0.251 0.1686 0.7176;0.2549 0.1725 0.7294;0.2549 0.1765 0.7412;0.2588 0.1804 0.749;0.2588 0.1843 0.7608;0 0 1;0.2627 0.1922 0.7843;0.2627 0.1961 0.7922;0.2667 0.2 0.8039;0.2667 0.2039 0.8157;0.2706 0.2078 0.8235;0.2706 0.2157 0.8353;0.2706 0.2196 0.8431;0.2745 0.2235 0.851;0.2745 0.2275 0.8627;0.2745 0.2314 0.8706;0.2745 0.2392 0.8784;0.2784 0.2431 0.8824;0.2784 0.2471 0.8902;0.2784 0.2549 0.898;0.2784 0.2588 0.902;0.2784 0.2667 0.9098;0.2784 0.2706 0.9137;0.2784 0.2745 0.9216;0.2824 0.2824 0.9255;0.2824 0.2863 0.9294;0.2824 0.2941 0.9333;0.2824 0.298 0.9412;0.2824 0.3059 0.9451;0.2824 0.3098 0.949;0.2824 0.3137 0.9529;0.2824 0.3216 0.9569;0.2824 0.3255 0.9608;0.2824 0.3294 0.9647;0.2784 0.3373 0.9686;0.2784 0.3412 0.9686;0.2784 0.349 0.9725;0.2784 0.3529 0.9765;0.2784 0.3569 0.9804;0.2784 0.3647 0.9804;0.2745 0.3686 0.9843;0.2745 0.3765 0.9843;0.2745 0.3804 0.9882;0.2706 0.3843 0.9882;0.2706 0.3922 0.9922;0.2667 0.3961 0.9922;0.2627 0.4039 0.9922;0.2627 0.4078 0.9961;0.2588 0.4157 0.9961;0.2549 0.4196 0.9961;0.251 0.4275 0.9961;0.2471 0.4314 1;0.2431 0.4392 1;0.2353 0.4431 1;0.2314 0.451 1;0.2235 0.4549 1;0.2196 0.4627 0.9961;0.2118 0.4667 0.9961;0.2078 0.4745 0.9922;0.2 0.4784 0.9922;0.1961 0.4863 0.9882;0.1922 0.4902 0.9882;0.1882 0.498 0.9843;0.1843 0.502 0.9804;0.1843 0.5098 0.9804;0.1804 0.5137 0.9765;0.1804 0.5176 0.9725;0.1804 0.5255 0.9725;0.1804 0.5294 0.9686;0.1765 0.5333 0.9647;0.1765 0.5412 0.9608;0.1765 0.5451 0.9569;0.1765 0.549 0.9529;0.1765 0.5569 0.949;0.1725 0.5608 0.9451;0.1725 0.5647 0.9412;0.1686 0.5686 0.9373;0.1647 0.5765 0.9333;0.1608 0.5804 0.9294;0.1569 0.5843 0.9255;0.1529 0.5922 0.9216;0.1529 0.5961 0.9176;0.149 0.6 0.9137;0.149 0.6039 0.9098;0.1451 0.6078 0.9098;0.1451 0.6118 0.9059;0.1412 0.6196 0.902;0.1412 0.6235 0.898;0.1373 0.6275 0.898;0.1373 0.6314 0.8941;0.1333 0.6353 0.8941;0.1294 0.6392 0.8902;0.1255 0.6471 0.8902;0.1216 0.651 0.8863;0.1176 0.6549 0.8824;0.1137 0.6588 0.8824;0.1137 0.6627 0.8784;0.1098 0.6667 0.8745;0.1059 0.6706 0.8706;0.102 0.6745 0.8667;0.098 0.6784 0.8627;0.0902 0.6824 0.8549;0.0863 0.6863 0.851;0.0784 0.6902 0.8471;0.0706 0.6941 0.8392;0.0627 0.698 0.8353;0.0549 0.702 0.8314;0.0431 0.702 0.8235;0.0314 0.7059 0.8196;0.0235 0.7098 0.8118;0.0157 0.7137 0.8078;0.0078 0.7176 0.8;0.0039 0.7176 0.7922;0 0.7216 0.7882;0 0.7255 0.7804;0 0.7294 0.7765;0.0039 0.7294 0.7686;0.0078 0.7333 0.7608;0.0157 0.7333 0.7569;0.0235 0.7373 0.749;0.0353 0.7412 0.7412;0.051 0.7412 0.7373;0.0627 0.7451 0.7294;0.0784 0.7451 0.7216;0.0902 0.749 0.7137;0.102 0.7529 0.7098;0.1137 0.7529 0.702;0.1255 0.7569 0.6941;0.1373 0.7569 0.6863;0.1451 0.7608 0.6824;0.1529 0.7608 0.6745;0.1608 0.7647 0.6667;0.1686 0.7647 0.6588;0.1725 0.7686 0.651;0.1804 0.7686 0.6471;0.1843 0.7725 0.6392;0.1922 0.7725 0.6314;0.1961 0.7765 0.6235;0.2 0.7804 0.6157;0.2078 0.7804 0.6078;0.2118 0.7843 0.6;0.2196 0.7843 0.5882;0.2235 0.7882 0.5804;0.2314 0.7882 0.5725;0.2392 0.7922 0.5647;0.251 0.7922 0.5529;0.2588 0.7922 0.5451;0.2706 0.7961 0.5373;0.2824 0.7961 0.5255;0.2941 0.7961 0.5176;0.3059 0.8 0.5059;0.3176 0.8 0.498;0.3294 0.8 0.4863;0.3412 0.8 0.4784;0.3529 0.8 0.4667;0.3686 0.8039 0.4549;0.3804 0.8039 0.4471;0.3922 0.8039 0.4353;0.4039 0.8039 0.4235;0.4196 0.8039 0.4118;0.4314 0.8039 0.4;0.4471 0.8039 0.3922;0.4627 0.8 0.3804;0.4745 0.8 0.3686;0.4902 0.8 0.3569;0.5059 0.8 0.349;0.5176 0.8 0.3373;0.5333 0.7961 0.3255;0.5451 0.7961 0.3176;0.5608 0.7961 0.3059;0.5765 0.7922 0.2941;0.5882 0.7922 0.2824;0.6039 0.7882 0.2745;0.6157 0.7882 0.2627;0.6314 0.7843 0.251;0.6431 0.7843 0.2431;0.6549 0.7804 0.2314;0.6706 0.7804 0.2235;0.6824 0.7765 0.2157;0.698 0.7765 0.2078;0.7098 0.7725 0.2;0.7216 0.7686 0.1922;0.7333 0.7686 0.1843;0.7451 0.7647 0.1765;0.7608 0.7647 0.1725;0.7725 0.7608 0.1647;0.7843 0.7569 0.1608;0.7961 0.7569 0.1569;0.8078 0.7529 0.1529;0.8157 0.749 0.1529;0.8275 0.749 0.1529;0.8392 0.7451 0.1529;0.851 0.7451 0.1569;0.8588 0.7412 0.1569;0.8706 0.7373 0.1608;0.8824 0.7373 0.1647;0.8902 0.7373 0.1686;0.902 0.7333 0.1765;0.9098 0.7333 0.1804;0.9176 0.7294 0.1882;0.9255 0.7294 0.1961;0.9373 0.7294 0.2078;0.9451 0.7294 0.2157;0.9529 0.7294 0.2235;0.9608 0.7294 0.2314;0.9686 0.7294 0.2392;0.9765 0.7294 0.2431;0.9843 0.7333 0.2431;0.9882 0.7373 0.2431;0.9961 0.7412 0.2392;0.9961 0.7451 0.2353;0.9961 0.7529 0.2314;0.9961 0.7569 0.2275;0.9961 0.7608 0.2235;0.9961 0.7686 0.2196;0.9961 0.7725 0.2157;0.9961 0.7804 0.2078;0.9961 0.7843 0.2039;0.9961 0.7922 0.2;0.9922 0.7961 0.1961;0.9922 0.8039 0.1922;0.9922 0.8078 0.1922;0.9882 0.8157 0.1882;0.9843 0.8235 0.1843;0.9843 0.8275 0.1804;0.9804 0.8353 0.1804;0.9765 0.8392 0.1765;0.9765 0.8471 0.1725;0.9725 0.851 0.1686;0.9686 0.8588 0.1647;0.9686 0.8667 0.1647;0.9647 0.8706 0.1608;0.9647 0.8784 0.1569;0.9608 0.8824 0.1569;0.9608 0.8902 0.1529;0.9608 0.898 0.149;0.9608 0.902 0.149;0.9608 0.9098 0.1451;0.9608 0.9137 0.1412;0.9608 0.9216 0.1373;0.9608 0.9255 0.1333;0.9608 0.9333 0.1294;0.9647 0.9373 0.1255;0.9647 0.9451 0.1216;0.9647 0.949 0.1176;0.9686 0.9569 0.1098;0.9686 0.9608 0.1059;0.9725 0.9686 0.102;0.9725 0.9725 0.0941;0.9765 0.9765 0.0863;0.9765 0.9843 0.0824];
            app.UIFigure.Position = [100 100 661 472];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {311, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.ForegroundColor = [1 0.4118 0.1608];
            app.LeftPanel.BackgroundColor = [0.149 0.149 0.149];
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create Image
            app.Image = uiimage(app.LeftPanel);
            app.Image.Position = [6 324 292 142];
            app.Image.ImageSource = '2cf20e0618ae6f3536d3bd344e1234b6.jpg';

            % Create Chooseanmp3fileButton
            app.Chooseanmp3fileButton = uibutton(app.LeftPanel, 'push');
            app.Chooseanmp3fileButton.ButtonPushedFcn = createCallbackFcn(app, @Chooseanmp3fileButtonPushed, true);
            app.Chooseanmp3fileButton.BackgroundColor = [0.851 0.3255 0.098];
            app.Chooseanmp3fileButton.FontColor = [0.8 0.8 0.8];
            app.Chooseanmp3fileButton.Position = [56 282 200 22];
            app.Chooseanmp3fileButton.Text = 'Choose an mp3 file';

            % Create playpauseButton
            app.playpauseButton = uibutton(app.LeftPanel, 'state');
            app.playpauseButton.ValueChangedFcn = createCallbackFcn(app, @playpauseButtonValueChanged, true);
            app.playpauseButton.Text = 'play/pause';
            app.playpauseButton.BackgroundColor = [0.851 0.3255 0.098];
            app.playpauseButton.FontColor = [0.8 0.8 0.8];
            app.playpauseButton.Position = [84 104 138 22];

            % Create TextArea
            app.TextArea = uitextarea(app.LeftPanel);
            app.TextArea.HorizontalAlignment = 'center';
            app.TextArea.BackgroundColor = [1 0.4118 0.1608];
            app.TextArea.Position = [56 237 200 35];

            % Create chooseButtonLABEL
            app.chooseButtonLABEL = uilabel(app.LeftPanel);
            app.chooseButtonLABEL.HorizontalAlignment = 'center';
            app.chooseButtonLABEL.Visible = 'off';
            app.chooseButtonLABEL.Tooltip = {'Choose an .mp3 file from your PC'};
            app.chooseButtonLABEL.Position = [110 284 85 18];
            app.chooseButtonLABEL.Text = '';

            % Create Label
            app.Label = uilabel(app.LeftPanel);
            app.Label.HorizontalAlignment = 'center';
            app.Label.Tooltip = {'At this area you can see the song that you have select.'};
            app.Label.Position = [56 237 200 35];
            app.Label.Text = '';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.ForegroundColor = [1 1 1];
            app.RightPanel.TitlePosition = 'centertop';
            app.RightPanel.BackgroundColor = [0.502 0.502 0.502];
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create TimeScopeVisualizerButton
            app.TimeScopeVisualizerButton = uibutton(app.RightPanel, 'push');
            app.TimeScopeVisualizerButton.ButtonPushedFcn = createCallbackFcn(app, @TimeScopeVisualizerButtonPushed, true);
            app.TimeScopeVisualizerButton.BackgroundColor = [0.851 0.3294 0.102];
            app.TimeScopeVisualizerButton.FontColor = [0.8 0.8 0.8];
            app.TimeScopeVisualizerButton.Position = [79 313 183 42];
            app.TimeScopeVisualizerButton.Text = 'TimeScope Visualizer';

            % Create TimeScopeVisualizer2Button
            app.TimeScopeVisualizer2Button = uibutton(app.RightPanel, 'push');
            app.TimeScopeVisualizer2Button.ButtonPushedFcn = createCallbackFcn(app, @TimeScopeVisualizer2ButtonPushed, true);
            app.TimeScopeVisualizer2Button.BackgroundColor = [0.851 0.3294 0.102];
            app.TimeScopeVisualizer2Button.FontColor = [0.8 0.8 0.8];
            app.TimeScopeVisualizer2Button.Position = [79 239 186 44];
            app.TimeScopeVisualizer2Button.Text = 'TimeScope Visualizer 2';

            % Create SpectrumVisualiserButton
            app.SpectrumVisualiserButton = uibutton(app.RightPanel, 'push');
            app.SpectrumVisualiserButton.ButtonPushedFcn = createCallbackFcn(app, @SpectrumVisualiserButtonPushed, true);
            app.SpectrumVisualiserButton.BackgroundColor = [0.851 0.3294 0.102];
            app.SpectrumVisualiserButton.FontColor = [0.8 0.8 0.8];
            app.SpectrumVisualiserButton.Position = [79 165 186 43];
            app.SpectrumVisualiserButton.Text = 'Spectrum Visualizer';

            % Create Label_2
            app.Label_2 = uilabel(app.RightPanel);
            app.Label_2.Tooltip = {'You can visualize the song that you have select. Axe-Y as Amplitude, Axe-X as Time'};
            app.Label_2.Position = [138 250 72 22];
            app.Label_2.Text = '';

            % Create Label_3
            app.Label_3 = uilabel(app.RightPanel);
            app.Label_3.Tooltip = {'You can visualize the song that you have select. Axe-Y as dBm, Axe-X as Frequency(kHZ)'};
            app.Label_3.Position = [144 175 56 22];
            app.Label_3.Text = '';

            % Create Label_4
            app.Label_4 = uilabel(app.RightPanel);
            app.Label_4.Tooltip = {'You can visualize the song that you have select. Axe-Y as Amplitude, Axe-X as Time'};
            app.Label_4.Position = [144 323 56 22];
            app.Label_4.Text = '';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end