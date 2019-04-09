
function varargout = IVSystem(varargin)
% IVSYSTEM MATLAB code for IVSystem.fig
%      IVSYSTEM, by itself, creates a new IVSYSTEM or raises the existing
%      singleton*.
%
%      H = IVSYSTEM returns the handle to a new IVSYSTEM or the handle to
%      the existing singleton*.
%
%      IVSYSTEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVSYSTEM.M with the given input arguments.
%
%      IVSYSTEM('Property','Value',...) creates a new IVSYSTEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IVSystem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IVSystem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IVSystem

% Last Modified by GUIDE v2.5 28-Mar-2019 19:39:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IVSystem_OpeningFcn, ...
                   'gui_OutputFcn',  @IVSystem_OutputFcn, ...
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


% --- Executes just before IVSystem is made visible.
function IVSystem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IVSystem (see VARARGIN)

% Choose default command line output for IVSystem
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IVSystem wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = IVSystem_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in closeButton.
function closeButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    device = handles.device;
    supply = handles.supply;
    
    % Set the supply voltage 
    s = strcat('SOUR:VOLT', 32, num2str(0.0));
    fprintf(supply, s);
    
    fclose(supply);
    fclose(device);
    set(handles.consoleLog, 'String', '>> INSTRUMENTOS DESCONECTADOS');    
    % close all;

% --- Executes on button press in disconnectDeviceButton.
function disconnectDeviceButton_Callback(hObject, eventdata, handles)
% hObject    handle to disconnectDeviceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in connectDeviceButton.
function connectDeviceButton_Callback(hObject, eventdata, handles)
% hObject    handle to connectDeviceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %% Connect the device with computer
    device = serial('COM15','BaudRate',115200);
    % open device
    fopen(device);
    % check the port
    fprintf(device, '*RST');
    fprintf(device, 'CONF:VOLT');
    % fprintf(device, 'CONF?');
    
    %% Connect the power supply with computer
    supply = visa('ni', 'USB0::0x05E6::0x2200::9200671::INSTR');
    % open device
    fopen(supply);
    % check the port
    fprintf(supply, '*IDN?');
    fprintf(supply,'OUTP:STAT 1');
    
    set(handles.consoleLog, 'String', '>> INSTRUMENTOS CONECTADOS');    
    %% global variables
    handles.device = device;
    handles.supply = supply;
    guidata(hObject,handles);
    
    
% --- Executes on button press in sweepButton.
function sweepButton_Callback(hObject, eventdata, handles)
% hObject    handle to sweepButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    % set(handles.consoleLog, 'String', 'iniciando barrido');
    %
    % Reading the system values.
    %
    supply       = handles.supply;
    device       = handles.device;
    minVoltage   = str2double(get(handles.minEdit,   'String'));
    steps        = str2double(get(handles.deltaEdit, 'String'));
    maxVoltage   = str2double(get(handles.maxEdit,   'String'));

    if (minVoltage >= 0.0 && minVoltage <= 7.5) && (maxVoltage > minVoltage) && (steps > 0)
        % 
        % Do the mesure.
        %
        min   = minVoltage;
        delta = (maxVoltage - minVoltage)/steps;
        V0 = min;
        V1 = min;
        
        for i = 0:steps - 1
            
            if handles.abortMeasure.Value == 1
                set(handles.consoleLog, 'String', '>> BARRIDO INTERRUMPIDO');
                break;
            end
            set(handles.consoleLog, 'String', '>> INICIANDO BARRIDO');
            min = min + delta;
            % Set the supply voltage 
            s = strcat('SOUR:VOLT', 32, num2str(min));
            fprintf(supply, s);
            % Get the volage measure
            fprintf(device, 'MEAS:VOLT?');
            tmp = fscanf(device);
            disp(tmp);
            idx = find(tmp == ',');
            res = str2double(tmp(1:idx(1) - 4));
            disp(res);
            % Print values on table
            V0   = [V0; min];
            V1   = [V1; res];
            data = [V0, V1];
            set(handles.measureTable, 'data', data);
            pause(1);
        end
    else
        set(handles.consoleLog, 'String', '>> ERROR DE INTERVALO');
    end

    %% global variables
    handles.supply = supply;
    guidata(hObject,handles);

function minEdit_Callback(hObject, eventdata, handles)
% hObject    handle to minEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minEdit as text
%        str2double(get(hObject,'String')) returns contents of minEdit as a double

% --- Executes during object creation, after setting all properties.
function minEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function deltaEdit_Callback(hObject, eventdata, handles)
% hObject    handle to deltaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaEdit as text
%        str2double(get(hObject,'String')) returns contents of deltaEdit as a double


% --- Executes during object creation, after setting all properties.
function deltaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maxEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxEdit as text
%        str2double(get(hObject,'String')) returns contents of maxEdit as a double


% --- Executes during object creation, after setting all properties.
function maxEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in abortMeasure.
function abortMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to abortMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of abortMeasure


% --- Executes when entered data in editable cell(s) in measureTable.
function measureTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to measureTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
