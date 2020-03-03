classdef COM_Ports < handle
    properties
        ports;
    end
    
    methods
        %% --- CONSTRUCTOR
        % function obj = COM_Ports...
        %% --- CHECKING PORTS
        function checking_ports(obj)
            obj.ports = {}; % clear the buffer before reading new values
            
            [~,res] = system('mode');
            obj.ports = unique(regexp(res,'COM\d+','match'))';            
        end
    end
end