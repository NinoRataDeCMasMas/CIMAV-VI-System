classdef Amperimeter < handle
    properties
        COM_port; % string
        file; % file
    end
    
    methods
        %% --- CONSTRUCTOR
        function obj = Amperimeter(COM_port)
            obj.COM_port = COM_port;
        end
        %% --- connecting the amperimeter
        function connect(obj)
            % connect device with computer
            obj.file = serial(obj.COM_port, 'BaudRate', 9600);
            % open device
            fopen(obj.file);
            % config the port
            fprintf(obj.file, 'SYSTEM:REMOTE');
            fprintf(obj.file, '*RST');
        end
        %% --- measuring current
        function current_measured = measure(obj)
            fprintf(obj.file, 'MEAS:CURR:DC?');
            tmp = fscanf(obj.file);
            current_measured = str2double(tmp);
        end
        %% -- disconnecting the amperimeter
        function disconnect(obj)
            fclose(obj.file);
        end
    end
end

