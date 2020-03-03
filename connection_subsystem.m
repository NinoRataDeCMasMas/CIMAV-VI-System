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
    
    % blocking the buttons for process
    set(handles.disconnect_button,'Enable','off');
    set(handles.calibrate_button, 'Enable','off');
    set(handles.measure_button,   'Enable','off');
    % generating measure options
    set(handles.measure_menu,'String',{'measure res';
                                       'measure cell';
                                       'measure const-V';
                                       'measure inv-res';
                                       'measure inv-cell'});
    % creating com port object
    com_ports = COM_Ports;
    com_ports.checking_ports();
    % setting readed com ports into menus
    if(~isempty(com_ports.ports))
        set(handles.volt_com_list, 'String', com_ports.ports);
        set(handles.amp_com_list,  'String', com_ports.ports);
    end
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

    % getting the selected indeces from menus 
    v_idx = get(handles.volt_com_list, 'Value');
    i_idx = get(handles.amp_com_list,  'Value');
    % creating measurement objects
    if v_idx ~= i_idx
        voltimeter  = Voltimeter( handles.com_ports.ports(v_idx));
        amperimeter = Amperimeter(handles.com_ports.ports(i_idx));
        % creating, connecting and settig power supply
        supply = Power_Supply();
        % connecting measurement objects
        supply.connect();
        voltimeter.connect();
        amperimeter.connect();
        % unlocking the buttons for process
        set(handles.disconnect_button,'Enable','on');
        set(handles.calibrate_button, 'Enable','on');         
        % exporting measurement and supply objects
        handles.voltimeter  = voltimeter;
        handles.amperimeter = amperimeter;
        handles.supply = supply;
        guidata(hObject,handles);
    else
        pop_up_same_port;
    end
end

%% --- CHECK_PORT_BUTTON
% --- Executes on button press in check_ports_button.
function check_ports_button_Callback(hObject, eventdata, handles)

    % creating com port object
    handles.com_ports.checking_ports();
    % setting readed com ports into menus
    if(~isempty(handles.com_ports.ports))
        set(handles.volt_com_list, 'String', handles.com_ports.ports);
        set(handles.amp_com_list,  'String', handles.com_ports.ports);
        guidata(hObject,handles);
    else
        pop_up_checking_ports;
    end
end

%% --- CALIBRATE_BUTTON
% --- Executes on button press in calibrate_button.
function calibrate_button_Callback(hObject, eventdata, handles)

    % reading the voltage input for calibration
    offset = str2double(get(handles.voltage_input_str,'String'));
    % reading the number of iterations
    it = str2double(get(handles.iterations_str,'String'));    
    % valid conditions for adjusting algorithm
    if ~isnan(offset)
        % setting error and setpoint
        setpoint = 0.0;
        % adjusting algorithm
        for i = 1:it
            handles.supply.set(offset);
            measure = handles.voltimeter.measure( );
            offset  = offset + (setpoint - measure);
        end
        % setting the new value of calibration
        handles.supply.set(offset);
        % setting the new value of calibration in str
        set(handles.voltage_input_str,'String', num2str(offset));
        guidata(hObject,handles);
    end
end

%% --- RESISTANCE_MEASURE_ALGORITHM
function resistance_measure(handles, lo, hi, stp, cls)
    delta = (hi - lo)/stp;
    disp(delta);
end

%% --- MEASURE_BUTTON
% --- Executes on button press in measure_button.
function measure_button_Callback(hObject, eventdata, handles)
    
    % reading params from measure menu boxes
    lo  = str2double(get(handles.from_voltage_str,'String')); % from
    hi  = str2double(get(handles.to_voltage_str,  'String')); % to
    stp = str2double(get(handles.steps_str,       'String')); % steps
    cls = str2double(get(handles.cycles_str,      'String')); % cycles
    % retriving offset
    offset = str2double(get(handles.voltage_input_str,'String'));
    % adjusting bounds with calculated offset
    lo = lo + offset;
    hi = hi + offset;
    
    if ~isnan(lo) && ~isnan(hi) && ~isnan(stp) && ~isnan(cls)
        resistance_measure(handles, lo, hi, stp, cls);
    end
end

%% --- DISCONNECT_BUTTON
% --- Executes on button press in disconnect_button.
function disconnect_button_Callback(hObject, eventdata, handles)
    handles.voltimeter.disconnect();
    handles.amperimeter.disconnect();
    handles.supply.disconnect();
    guidata(hObject,handles);
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

%% --- VOLTAGE_INPUT_STR
function voltage_input_str_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function voltage_input_str_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% --- FROM_VOLTAGE_STR
function from_voltage_str_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function from_voltage_str_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% --- TO_VOLTAGE_STR
function to_voltage_str_Callback(hObject, eventdata, handles)
end
% --- Executes during object creation, after setting all properties.
function to_voltage_str_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% --- STEPS_STR
function steps_str_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function steps_str_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% --- CYCLES_STR
function cycles_str_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function cycles_str_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% --- MEASURE_MENU
% --- Executes on selection change in measure_menu.
function measure_menu_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function measure_menu_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% --- ITERATIONS_STR
function iterations_str_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function iterations_str_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
