classdef Barometro < handle
    properties
        sp
        SAD
        SUB
        vals_out
        vals_in
        msg
    end
    methods
        function obj = I2Cdevice(spname,address)
            obj.sp = serialport(spname,2e6);
            obj.SAD = address;
            % Facciamo un po' di pulizia...
            obj.sp.writeline('*IDN?');
            pause(0.1);
            while(obj.sp.NumBytesAvailable>0)
                obj.sp.readline();
            end
        end
        function startReading(obj)
            CTRL_REG1 = 0x20;
            CTRL_REG1_val = 0b11100000; % acensionie in modalità 12.5Hz
            dev.write(CTRL_REG1,[CTRL_REG1_val]);
        end
        function available(obj)
            STATUS_REG = 0x27;
            bytes = dev.read(STATUS_REG, 1);
            byte_val = bytes(1);
        end
        function [press, temp] = read(obj)
            
        end
        function [press, temp] = conversion(obj, press_b, tmp_b)
            if press_b>2^23
                press_b = press_b-2^24;
            end
            press = press_b / 4096;
            if tmp_b>2^15
                tmp_b = tmp_b-2^16;
            end
            tmp = 42.5+tmp_b/480;
            
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