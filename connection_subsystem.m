function varargout = connection_subsystem(varargin)
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @connection_subsystem_OpeningFcn, ...
                       'gui_OutputFcn',  @connection_subsystem_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
end
%% --- CONSTRUCTOR
% --- Executes just before connection_subsystem is made visible.
function connection_subsystem_OpeningFcn(hObject, eventdata, handles, varargin)
    
    % creating com port object
    com_ports = COM_Ports;
    % setting readed com ports into menus
    set(handles.volt_com_list, 'String', com_ports.ports);
    set(handles.amp_com_list,  'String', com_ports.ports);
    % exporting com port object
    handles.com_ports = com_ports;
    
    handles.output = hObject;
    guidata(hObject, handles);
end
%% --- DESTRUCTOR
% --- Outputs from this function are returned to the command line.
function varargout = connection_subsystem_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
end

%% --- CONNECT_BUTTON
% --- Executes on button press in connect_button.
function connect_button_Callback(hObject, eventdata, handles)

    % creating, connecting and settig power supply for first time
    supply = Power_Supply();
    supply.connect();
    supply.set_voltage(12.0);
    % getting the selected indeces from menus 
    v_idx = get(handles.volt_com_list, 'Value');
    i_idx = get(handles.amp_com_list,  'Value');
    % creating measurement objects
    if v_idx ~= i_idx
        voltimeter  = Voltimeter( handles.com_ports.ports(v_idx));
        amperimeter = Amperimeter(handles.com_ports.ports(i_idx));
    end
    % connecting measurement objects
    voltimeter.connect();
    amperimeter.connect();
    % exporting measurement and supply objects
    handles.supply = supply;
    handles.voltimeter  = voltimeter;
    handles.amperimeter = amperimeter; 
end

%% --- DISCONNECT_BUTTON
% --- Executes on button press in disconnect_button.
function disconnect_button_Callback(hObject, eventdata, handles)
end

%% --- AMP_COM_TEXT
function amp_com_text_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function amp_com_text_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% --- VOLT_COM_TEXT
function volt_com_text_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function volt_com_text_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% --- VOLT_COM_LIST
% --- Executes on selection change in volt_com_list.
function volt_com_list_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function volt_com_list_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% --- AMP_COM_LIST
% --- Executes on selection change in amp_com_list.
function amp_com_list_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function amp_com_list_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
