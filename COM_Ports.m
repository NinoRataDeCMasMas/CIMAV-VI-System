classdef COM_Ports < handle
    properties
        ports;
    end
    
    methods
        %% --- CONSTRUCTOR
        function obj = COM_Ports
            [~,res] = system('mode');
            obj.ports = regexp(res,'COM\d+','match')';
        end        
    end
end