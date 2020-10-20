classdef Nucleo < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sp = 0 %porta seriale - quando non è un numero, allora è aperta la comunicazione
        
        m_nSkip = 0;
        m_prescaler = 0;
        m_nSamples = 0;
    end
    
    methods
        
        function apri_comunicazione(obj, porta)
            if obj.isOpen()
                obj.close();
            end
            obj.sp = serialport(porta, 2e6);
            
            obj.assertOpen();
            obj.m_nSkip = obj.getNSkip();
            obj.m_prescaler = obj.getPrescaler();
            obj.m_nSamples = obj.getNSamples();
        end
        
        function [aperto] = isOpen(obj)
            aperto = ~isnumeric(obj.sp);
        end
        
        function close(obj)
            obj.sp = 0;
        end
        
        % ================================
        %             COMANDI
        % ================================
        
        % ================================
        function [info_str] = getInfo(obj)
            %GETINFO chiede alla scheda di identificarsi, ritorna l'output
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            % manda il comando *IDN? che chiede di identificarsi
            obj.writeline('*IDN?');
            
            % leggi la riga di risposta
            info_str = obj.readline();
        end
        
        % ================================
        function setADC(obj, value)
            %SETADC_ON avvia o spegni l'ADC
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            if (value)
                % manda il comando di attivazione
                obj.writeline('ADC ON');
                obj.readline();
            else
                % manda il comando di spegnimento
                obj.writeline('ADC OFF');
                obj.readline();
            end
        end
        
        % ================================
        function [val] = isADC_ON(obj)
            %ISADC_ON controlla se l'ADC è attivo
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            obj.writeline('ADC?');
            risposta = obj.readline();
            
            if (risposta(2) == 'N')% ON
                val = true;
            else
                val = false;
            end
        end
        
        % ================================
        function setDAC(obj, value)
            %SETADC_ON avvia o spegni l'ADC
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            if (value)
                % manda il comando di attivazione
                obj.writeline('DAC ON');
                obj.readline();
            else
                % manda il comando di spegnimento
                obj.writeline('DAC OFF');
                obj.readline();
            end
        end
        
        % ================================
        function [val] = isDAC_ON(obj)
            %ISADC_ON controlla se l'ADC è attivo
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            obj.writeline('DAC?');
            risposta = obj.readline();
            
            if (risposta(2) == 'N')% ON
                val = true;
            else
                val = false;
            end
        end
        
        % ================================
        function setNSkip(obj, value)
            obj.assertOpen();
            
            linea = sprintf('NSKIP %d', value);
            
            obj.writeline(linea);
            obj.readline();
            
            value = obj.getNSkip();
            obj.m_nSkip = value;
        end
        
        function rea = getNSkip(obj)
            obj.assertOpen();
            obj.writeline('NSKIP?');
            rea = obj.readline();
            rea = str2num(rea);
        end
        % ================================
        function setNSamples(obj, value)
            obj.assertOpen();
            
            linea = sprintf('NSAMPLES %d', value);
            
            obj.writeline(linea);
            obj.readline();
            
            value = obj.getNSamples();
            obj.m_nSamples = value;
        end
        
        function rea = getNSamples(obj)
            obj.assertOpen();
            obj.writeline('NSAMPLES?');
            rea = obj.readline();
            rea = str2num(rea);
        end
        % ================================
        function [value] = setPrescaler(obj, value)
            if (value < 120)
                warning("prescaler deve essere 120 o maggiore")
            end
            
            obj.assertOpen();
            
            linea = sprintf('PRESCALER %d', value);
            
            obj.writeline(linea);
            obj.readline();
            
            value = obj.getPrescaler();
            obj.m_prescaler = value;
        end
        
        function rea = getPrescaler(obj)
            obj.assertOpen();
            obj.writeline('PRESCALER?');
            rea = obj.readline();
            rea = str2num(rea);
        end
        % ================================
        %            DAC&&ACD
        % ================================
        function [tt, yy0, yy1] = getValues(obj)
            
            obj.writeline('ADCVALUES?');
            
            out = obj.readline();
            
            
            yy = sscanf(char(out), '%f,');
            
            yy0 = mod(yy, 65536);
            yy1 = (yy - yy0) / 65536;
            
            tt = (0:(numel(yy)-1)) * obj.m_prescaler/120e6 ;
        end
        
        function nVals = setWaveValues(obj, values)
            obj.assertOpen();
            
            values = round(values);
            valori_chars = char(sprintf("%d,", values));
            obj.writeline(['WAVEFUNC ', valori_chars(1:end-1)]);
            
            nVals = str2num(obj.readline());
        end
        
        function nVals = setWaveFun(obj, func, Npts)
            obj.assertOpen();
            if obj.isDAC_ON()
                error("il DAC deve essere spento prima di impostare wavefunc")
            end
            
            xx = (0:(Npts - 1))/Npts;
            nVals = obj.setWaveValues(func(xx));
        end
        
        function [tt, yy0, yy1] = DACADC(obj)
            obj.assertOpen();
            
            obj.setDAC(true);
            obj.setADC(true);
            
            tempo_attesa = (obj.m_prescaler / 120e6) * obj.m_nSamples *...
                (obj.m_nSkip + 1);
            tempo_attesa = tempo_attesa * 1.5 + 0.01;
            pause(tempo_attesa);
            
            obj.setADC(false);
            obj.setDAC(false);
            
            [tt, yy0, yy1] = obj.getValues();
        end
        
        % ================================
        %       COMUNICAZIONE SERIALE
        % ================================
        
        function linea = readline(obj)
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            % leggi una riga
            linea = obj.sp.readline();
            
            % converti in vettore di char
            linea = char(linea);
        end
        
        function writeline(obj, riga)
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            % manda la riga
            obj.sp.writeline(riga);
            
            % aspetta un decimo per essere sicuri che sia arrivato e cha
            % abbia risposto
            %pause(0.1);
            
            %disp(riga);
        end
        
        function assertOpen(obj)
            if ~obj.isOpen()
                error("la comunicazione non è aperta");
            end
        end
    end
end

