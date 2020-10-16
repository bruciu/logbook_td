classdef Nucleo < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sp = 0 %porta seriale - quando non è un numero, allora è aperta la comunicazione
    end
    
    methods
        
        function apri_comunicazione(obj, porta)
            if obj.isOpen()
                obj.close();
            end
            obj.sp = serialport(porta, 2e6);
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
                
                % aspetta che diventi ON
                while (~obj.isADC_ON())
                    pause(0.1);
                end
            else
                % manda il comando di spegnimento
                obj.writeline('ADC OFF');
                
                % aspetta che diventi OFF
                while (obj.isADC_ON())
                    pause(0.1);
                end
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
                
                % aspetta che diventi ON
                while (~obj.isDAC_ON())
                    pause(0.1);
                end
            else
                % manda il comando di spegnimento
                obj.writeline('DAC OFF');
                
                % aspetta che diventi OFF
                while (obj.isDAC_ON())
                    pause(0.1);
                end
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
            
            while(value ~= obj.getNSkip())
                pause(0.1);
                tmp = tmp + 0.1;
                if tmp >= 5
                    error("setNSkip: non terminato con successo");
                end
            end
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
            
            linea = sprintf('NSAMPLE %d', value);
            
            obj.writeline(linea);
            
            tmp = 0;
            
            while(value ~= obj.getNSamples())
                pause(0.1);
                tmp = tmp + 0.1;
                if tmp >= 5
                    error("setNsamples: non terminato con successo");
                end
            end
        end
        
        function rea = getNSamples(obj)
            obj.assertOpen();
            obj.writeline('NSAMPLES?');
            rea = obj.readline();
            rea = str2num(rea);
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
            pause(0.1);
        end
        
        function assertOpen(obj)
            if ~obj.isOpen()
                error("la comunicazione non è aperta");
            end
        end
    end
end

