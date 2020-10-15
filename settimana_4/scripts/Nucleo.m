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
        function linea = readline(obj)
            if ~obj.isOpen()
                error("la comunicazione non è aperta");
            end
            linea = obj.sp.readline();
        end
    end
end

