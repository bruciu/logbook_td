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
            %METHOD1 chiede alla scheda di identificarsi, ritorna l'output
            
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            % manda il comando *IDN? che chiede di identificarsi
            obj.writeline('*IDN?');
            
            % leggi la riga di risposta
            info_str = obj.readline();
        end
        
        % ================================
        %       COMUNICAZIONE SERIALE
        % ================================
        
        function linea = readline(obj)
            % controlla che la porta sia aperta
            obj.assertOpen();
            
            % leggi una riga
            linea = obj.sp.readline();
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

