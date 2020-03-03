classdef Power_Supply < handle
    properties
        file; % file
    end
    
    methods
        %% --- CONSTRUCTOR
        function obj = Power_Supply()
            try
                obj.file = visa('ni', 'USB0::0x05E6::0x2200::9200671::INSTR');
            catch
                msgID = 'MYFUN:DriverNotFoud';
                msg = 'Power supply driver not found.';
                power_supply_exception = MException(msgID,msg);
                throw(power_supply_exception);
            end
        end
        %% --- connecting the supply
        function connect(obj)
            % open device
            fopen(obj.file);
            % check the port
            fprintf(obj.file, '*IDN?');
            fprintf(obj.file,'OUTP:STAT 1');
        end
        %% --- setting voltage
        function set(obj, voltage)
            str = strcat('SOUR:VOLT', 32, num2str(voltage));
            fprintf(obj.file, str);
        end
        %% -- disconnecting the supply
        function disconnect(obj)
            fprintf(obj.file, 'SOUR:VOLT 0.0');
            fclose(obj.file);
        end
    end    
end