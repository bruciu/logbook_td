classdef Barometro < handle
    properties
        sp
        SAD = 93;
        SUB
        vals_out
        vals_in
        msg
    end
    methods
        function obj = Barometro(spname)
            obj.sp = serialport(spname,2e6);
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
            obj.write(CTRL_REG1,[CTRL_REG1_val]);
            
            RES_CONF = 0x10;
            RES_CONF_val = 0b01111010;
            obj.write(RES_CONF,[RES_CONF_val]);
        end
        function value = temperatureAvailable(obj)
            STATUS_REG = 0x27;
            bytes = obj.read(STATUS_REG, 1);
            byte_val = uint8(bytes(1));
            value = bitand(byte_val, 0b00000001) > 0;
        end
        function value = pressureAvailable(obj)
            STATUS_REG = 0x27;
            bytes = obj.read(STATUS_REG, 1);
            byte_val = uint8(bytes(1));
            value = bitand(byte_val, 0b00000010) > 0;
        end
        function value = available(obj)
            value = obj.temperatureAvailable() & obj.pressureAvailable();
        end
        function [press, temp] = readValue(obj, bool_conv)
            while(~obj.available())
            end
        
            if nargin < 2
                bool_conv = true;
            end
            obj.lockfree(true);
            bytes = obj.read(0x2B + 0x80, 2);
            tmp_b = bytes(2)*256 + bytes(1);
            bytes = obj.read(0x28 + 0x80, 3);
            obj.lockfree(false);
            press_b = bytes(3)*2^16 + bytes(2)*256 + bytes(1);
            if tmp_b>2^15
                tmp_b = tmp_b-2^16;
            end
            if press_b>2^23
                press_b = press_b-2^24;
            end
            press = press_b;
            temp = tmp_b;
            if bool_conv
                [press, temp] = obj.conversion(press_b, tmp_b);
            end
        end
        %function [dpress, dtemp] = noise(obj, address)
        %end
        function [press, temp] = conversion(obj, press_b, temp_b)
            press = press_b / 4096;
            temp = 42.5+temp_b/480;
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
        function lockfree(obj, val)
            CTRL_REG1 = 0x20;
            res = obj.read(CTRL_REG1,1);
            mask_v_orig = uint8(0b00000100);
            mask_v = uint8(bitcmp(mask_v_orig));
            res = bitand(uint8(res), mask_v);
            if (val)
                res = bitor(uint8(res), mask_v_orig);
            end
            obj.write(CTRL_REG1, [res]);
        end
    end
end