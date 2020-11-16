function miniScopeML()

    clear all;
    prescaler = 1200;
    npoints   = 100;
    baseline  = 2048;
    ampl      = 1500;
    % 1 sine
    % 2 square
    % 3 triangular
    % 4 sawtooth
    WFn       = 1;  
    nskip     = 10;
    nsamples  = 600;
    flagXY    = false;
    flagV     = false;
    flagDebug = false;
    COM       = serialportlist;
    
    hf = figure(100); clf; hold on;
    hf.Color = [1 1 1];
    hf.Name = 'Press ESC to stop';
    hf.NumberTitle = 'off';
    hf.WindowKeyPressFcn = @key;
    ha = subplot(5,1,1:3); hold on;
    
    hp1 = plot(1,1,'o','MarkerSize',3);
    hp2 = plot(1,1,'o','MarkerSize',3);
    hp3 = plot(1,1,'o','MarkerSize',3);
    box on;
    hl = legend('DAC','A0','A1');
    hl.Box = 'off';
    updatelabels();
    ht = title('starting');
    

    
    la1 = uicontrol('Style','text',...
        'String','prescaler',...
        'FontSize',12,...
        'Position', [50 130,100,20]);
    ps = uicontrol('Style','edit',...
        'String',num2str(prescaler),...
        'FontSize',12,...
        'Position', [160 130,80,20],...
        'Callback', @psedit);
    WFset = uicontrol('Style', 'popup',...
        'String', {'sine','square','triangular','sawtooth'},...
        'Value',WFn,...
        'Position', [160 62 80 50],...
        'Callback', @WFsel);
    la2 = uicontrol('Style','text',...
        'String','#points',...
        'FontSize',12,...
        'Position', [50 65,100,20]);
    np = uicontrol('Style','edit',...
        'String',num2str(npoints),...
        'FontSize',12,...
        'Position', [160 65,80,20],...
        'Callback', @npedit);
    la3 = uicontrol('Style','text',...
        'String','amplitude',...
        'FontSize',12,...
        'Position', [50 40,100,20]);
    aa = uicontrol('Style','edit',...
        'String',num2str(ampl),...
        'FontSize',12,...
        'Position', [160 40,80,20],...
        'Callback', @aaedit);
    la4 = uicontrol('Style','text',...
        'String','baseline',...
        'FontSize',12,...
        'Position', [50 15,100,20]);
    bl = uicontrol('Style','edit',...
        'String',num2str(baseline),...
        'FontSize',12,...
        'Position', [160 15,80,20],...
        'Callback', @bledit);
    
    XYset = uicontrol('Style', 'popup',...
        'String', {'A0/A1','XY'},...
        'Value',1,...
        'Position', [410 90 80 50],...
        'Callback', @XYsel);
    VVset = uicontrol('Style', 'popup',...
        'String', {'4096','Volts'},...
        'Value',1,...
        'Position', [410 65 80 50],...
        'Callback', @VVsel);
    la5 = uicontrol('Style','text',...
        'String','nsamples',...
        'FontSize',12,...
        'Position', [300 40,100,20]);
    nsam = uicontrol('Style','edit',...
        'String',num2str(nsamples),...
        'FontSize',12,...
        'Position', [410 40,80,20],...
        'Callback', @nsamedit);
    la6 = uicontrol('Style','text',...
        'String','nskip',...
        'FontSize',12,...
        'Position', [300 15,100,20]);
    nsk = uicontrol('Style','edit',...
        'String',num2str(nskip),...
        'FontSize',12,...
        'Position', [410 15,80,20],...
        'Callback', @nskipedit);
    
    sp = serialport(COM,2e6);
    
    flag_continue = true;
    while(flag_continue)
        % Flush
        flag_interruptable = false;
        while (sp.NumBytesAvailable>0)
            sp.readline();
        end
        % Debug
        if flagDebug
            sp.writeline('DEBUG ON'); 
        else
            sp.writeline('DEBUG OFF'); 
        end
        fprintf(sp.readline());
        % Prescaler
        sp.writeline(['PRESCALER ' num2str(prescaler)]);
        prescaler = str2num(sp.readline());
        ps.String = num2str(prescaler); 
        dt = prescaler/120e6;
        % Wavefunction
        switch(WFn)
            case 1 % sine
                angv = linspace(0,2*pi,npoints+1);
                angv = angv(1:end-1);
                WFv  = baseline+ampl*sin(angv);
            case 2 % square
                WFv(1:npoints)     = baseline-ampl;
                WFv(1:(npoints/2)) = baseline+ampl;
            case 3 % triangular
                WFv = linspace(-ampl,ampl,npoints/2+1);
                WFv = WFv(1:end-1);
                WFv = [WFv flip(WFv)+2*ampl/npoints];
                WFv = WFv+baseline;
            case 4 % sawtooth
                WFv = linspace(0,ampl,npoints/2+1);
                WFv = WFv(1:end-1);
                WFv = [WFv WFv-ampl]+baseline;
        end
        WFv = round(WFv);
        command = sprintf('%d,',WFv);
        command = command(1:end-1);
        command = ['WAVEFUNC ' command];
        nchar = 100;
        ntot = length(command);
        ntok = floor(ntot/nchar-1);
        for itok = 1:ntok
            sp.write(command((1:nchar)+(itok-1)*nchar),'char');
        end
        sp.writeline(command((nchar*ntok+1):end));
        truenpoints = str2num(sp.readline());
        t1v = (0:(npoints-1))*dt;
        t2v = (0:(nsamples-1))*dt;
        
        hp1.XData = t1v;
        if ~flagXY
            if flagV
                hp1.YData = WFv*3.3/4095;
            else
                hp1.YData = WFv;
            end
        else
            hp1.YData = hp1.XData*NaN;
        end
        
        % Timer
        sp.writeline('TIMER OFF');
        fprintf(sp.readline());
        % DAC
        sp.writeline('DAC ON');
        fprintf(sp.readline());
        % number of samples
        sp.writeline(['NSAMPLES ' num2str(nsamples)]);
        fprintf(sp.readline());
        % number of samples
        sp.writeline(['NSKIP ' num2str(nskip)]);
        fprintf(sp.readline());
        % ask ADC on
        sp.writeline('ADC ON');
        fprintf(sp.readline());
        % Timer...
        sp.writeline('TIMER ON');
        fprintf(sp.readline());
        
        pause((truenpoints+(nskip+1)*nsamples)*dt*1.2);
        
        sp.writeline('ADCVALUES?');
        data = str2num(sp.readline());
        % DAC
        sp.writeline('DAC OFF');
        fprintf(sp.readline());
        
        A0v = mod(data,65536);
        A1v = (data-A0v)/65536;
        
        if flagXY
            if flagV
                hp3.XData = A0v*3.3/4095;
                hp3.YData = A1v*3.3/4095;
            else
                hp3.XData = A0v;
                hp3.YData = A1v;
            end
            hp2.YData = hp2.XData*NaN;
        else
            hp2.XData = t2v;
            hp3.XData = t2v; 
            if flagV
                hp3.YData = A1v*3.3/4095;
                hp2.YData = A0v*3.3/4095;
            else
                hp3.YData = A1v;
                hp2.YData = A0v;
            end
        end
        
        ht.String = ['frequency = ' num2str(120e6/prescaler/npoints) 'Hz'];
        drawnow();
        flag_interruptable = true;
        
    end
    
    hf.Name = 'Stopped';
    
    sp.writeline('DAC OFF');
    fprintf(sp.readline());
    clear sp;
    
    function updatelabels()
        if flagXY
            if flagV
                xlabel('A0(V)');
                ylabel('A1(V)');
            else
                xlabel('A0(#)');
                ylabel('A1(#)');
            end
        else
            xlabel('time(s)');
            if flagV
                ylabel('signal(V)');
            else
                ylabel('signal(#)');
            end
        end
    end
    function key(src,event)
        switch event.Key
            case 'escape'
                flag_continue = false;
        end
    end
    function XYsel(source,callbackdata)
        val = get(source,'Value');
        if val==1 
            flagXY = false;
        else
            flagXY = true;
        end
        updatelabels();
    end
    function VVsel(source,callbackdata)
        val = get(source,'Value');
        if val==1 
            flagV = false;
        else
            flagV = true;
        end
    end
    function WFsel(source,callbackdata)
        WFn = get(source,'Value');
    end
    function psedit(source,callbackdata)
        prescaler = str2num(get(source,'String'));
    end
    function npedit(source,callbackdata)
        npoints = str2num(get(source,'String'));
    end
    function aaedit(source,callbackdata)
        ampl = str2num(get(source,'String'));
    end
    function bledit(source,callbackdata)
        baseline = str2num(get(source,'String'));
    end
    function nsamedit(source,callbackdata)
        nsamples = str2num(get(source,'String'));
    end
    function nskipedit(source,callbackdata)
        nskip = str2num(get(source,'String'));
    end
    
end