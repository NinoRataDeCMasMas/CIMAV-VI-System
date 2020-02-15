classdef Voltimeter < handle
    properties
        COM_port; % string
        file; % file
    end
    
    methods
        %% --- CONSTRUCTOR
        function obj = Voltimeter(COM_port)
            obj.COM_port = COM_port;
        end
        %% --- connecting the voltimeter
        function connect(obj)
            % connect device with computer
            obj.file = serial(obj.COM_port, 'BaudRate', 115200);
            % open device
            fopen(obj.file);
            % config the port
            fprintf(obj.file, '*RST');
            fprintf(obj.file, 'CONF:VOLT');
        end
        %% --- measuring voltage
        function voltage_measured = measure(obj)
            fprintf(obj.file, 'MEAS:VOLT?');
            tmp = fscanf(obj.file);
            idx = find(tmp == ',');
            voltage_measured = str2double(tmp(1:idx(1) - 4));
        end
        %% -- disconnecting the voltimeter
        function disconnect(obj)
            fclose(obj.file);
        end        
    end
end

