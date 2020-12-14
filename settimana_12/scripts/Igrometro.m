classdef Igrometro< handle
    properties
        sp
        SAD = 0x44
        SUB
        vals_out
        vals_in
        msg
    end
    methods
        function obj = Igrometro(spname)
            obj.sp = serialport(spname,2e6);
            % Facciamo un po' di pulizia...
            obj.sp.writeline('*IDN?');
            pause(0.1);
            while(obj.sp.NumBytesAvailable>0)
                obj.sp.readline();
            end
            obj.startReading();
        end
        function startReading(obj, MSB, LSB)
            if nargin < 2
                obj.write(0x27, 0x37);
            else
                obj.write(MSB, LSB);
            end
        end
        
        function [U, T] = readValue(obj)
            bytes = [];
            NBYTES = 6;
            while (length(bytes) < 1)
                bytes = obj.read(0xE000,NBYTES);
            end
            St = bytes(1)*256 + bytes(2);
            Su = bytes(4)*256 + bytes(5);
            
            U = 100*Su/(2^16 - 1);
            T = -45 + 175*St/(2^16 - 1);
        end
        function res = write(obj,SUB,values)
            obj.SUB = SUB;
            command = sprintf('I2CWRITE %d,%d',obj.SAD,obj.SUB);
            for ii=1:length(values)
                command = [command ',' num2str(values(ii))];
            end
            obj.sp.writeline(command);
            tmp = obj.sp.readline();
            if (tmp(1)=='E')
                res = -1;
                obj.msg = 'KO';
            else
                res = length(values);
                obj.msg = 'Ok';
                obj.vals_out = values;
            end
        end
        function res = read(obj,SUB,nvals)
            obj.SUB = SUB;
            command = sprintf('I2CREAD? %d,%d,%d',obj.SAD,obj.SUB,nvals);
            obj.sp.writeline(command);
            pause(0.01);
            tmp = char(obj.sp.readline());
            if (tmp(1)=='E')
                res = [];
                obj.msg = 'KO';
            else
                obj.msg = 'Ok';
                res = str2num(tmp(1:end-1));
            end
            obj.vals_in = res;
        end
    end
end

