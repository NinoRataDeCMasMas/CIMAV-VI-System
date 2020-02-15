function varargout = graph_plot(varargin)
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @graph_plot_OpeningFcn, ...
                       'gui_OutputFcn',  @graph_plot_OutputFcn, ...
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

% --- CONSTRUCTOR:
% --- Executes just before graph_plot is made visible.
function graph_plot_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);     
end

% --- DESTRUCTOR:
% --- Outputs from this function are returned to the command line.
function varargout = graph_plot_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;
end

% --- Executes on button press in measure_bttn.
function measure_bttn_Callback(hObject, eventdata, handles)
    % plot the calculated axis
    axis(handles.graph);
  
    x = linspace(0,10,10); % vector created by from-steps-to
    y = [];
    for i = 1:100 % number of steps
        y = [y, x(i)];
        plot(x(1:i), y(1:i), '.r');
        pause(1);
    end
end
