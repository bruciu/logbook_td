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
        
        function [info_str] = getInfo(obj)
            %GETINFO chiede alla scheda di identificarsi, ritorna l'output
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            % manda il comando *IDN? che chiede di identificarsi
            obj.writeline('*IDN?');
            
            % leggi la riga di risposta
            info_str = obj.readline();
        end
        
        function setADC(obj, value)
            %SETADC_ON avvia o spegni l'ADC
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            if (value)
                % manda il comando di attivazione
                obj.writeline('ADC ON');
            else
                % manda il comando di spegnimento
                obj.writeline('ADC OFF');
            end
        end
        
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
        
        function setDAC(obj, value)
            %SETADC_ON avvia o spegni l'ADC
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            if (value)
                % manda il comando di attivazione
                obj.writeline('DAC ON');
            else
                % manda il comando di spegnimento
                obj.writeline('DAC OFF');
            end
        end
        
        function [val] = isDAC_ON(obj)
            %ISADC_ON controlla se l'ADC è attivo
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            obj.writeline('DAC?');
            risposta = obj.readline()
            
            if (risposta(2) == 'N')% ON
                val = true;
            else
                val = false;
            end
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

