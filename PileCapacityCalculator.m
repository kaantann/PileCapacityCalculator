function varargout = PileCapacityCalculator(varargin)
% CE461_FINAL_KAANTAN_2162824 MATLAB code for ce461_FINAL_KaanTan_2162824.fig
%      CE461_FINAL_KAANTAN_2162824, by itself, creates a new CE461_FINAL_KAANTAN_2162824 or raises the existing
%      singleton*.
%
%      H = CE461_FINAL_KAANTAN_2162824 returns the handle to a new CE461_FINAL_KAANTAN_2162824 or the handle to
%      the existing singleton*.
%
%      CE461_FINAL_KAANTAN_2162824('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CE461_FINAL_KAANTAN_2162824.M with the given input arguments.
%
%      CE461_FINAL_KAANTAN_2162824('Property','Value',...) creates a new CE461_FINAL_KAANTAN_2162824 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ce461_FINAL_KaanTan_2162824_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ce461_FINAL_KaanTan_2162824_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ce461_FINAL_KaanTan_2162824

% Last Modified by GUIDE v2.5 06-Jul-2021 10:53:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ce461_FINAL_KaanTan_2162824_OpeningFcn, ...
                   'gui_OutputFcn',  @ce461_FINAL_KaanTan_2162824_OutputFcn, ...
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


% --- Executes just before ce461_FINAL_KaanTan_2162824 is made visible.
function ce461_FINAL_KaanTan_2162824_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ce461_FINAL_KaanTan_2162824 (see VARARGIN)
handles.Ks = 0.5;
handles.Nc = 9;
handles.scale = 10;
handles.gama_water = 9.81; %defining initials
% Choose default command line output for ce461_FINAL_KaanTan_2162824
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ce461_FINAL_KaanTan_2162824 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ce461_FINAL_KaanTan_2162824_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function number_layer_Callback(hObject, eventdata, handles)
% hObject    handle to number_layer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number_layer as text
%        str2double(get(hObject,'String')) returns contents of number_layer as a double
handles.number_layer = str2double(get(hObject,'String')); %getting total number of layers
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function number_layer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number_layer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_number_layer.
function pushbutton_number_layer_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_number_layer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles.hidden.Visible = "on"; %to show red hidden message
if handles.number_layer > 1
    data = get(handles.table, 'data');
    for layer_number = 2:handles.number_layer
        layer_name = "Layer " + string(layer_number); %numbering of other layers
        handles.table.RowName{layer_number,1} = layer_name;%assigning to the rows
    end
    set(handles.table,'data',data);%inserting the changes into uitable
end
handles.table.Enable = "on"; %enabling to input data from user
% Update handles structure
guidata(hObject, handles);
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_calculate.
function pushbutton_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
handles.data_cell_soil_type = " "; %preallocation 
handles.data_cell_values = zeros(handles.number_layer,7);%preallocation
    %extracting data in two matrices which one contains soil type, other
    %includes other data
    
    for roww = 1:handles.number_layer
        handles.data_cell_soil_type(roww,1) = string(handles.data_cell{roww,1}); %assigning corresponding values (soil types)
    end
    for col = 1:7
        for row = 1:handles.number_layer
        handles.data_cell_values(row,col) = str2double(handles.data_cell{row,col+1});%assigning corresponding values (numerical values)
        end
    end
    
    %skin friction calculations
    handles.plot_stress = layer_above_effective_stress(handles); %stresses that are plotted are calculated and assigned
    Qs_total = 0; %preallocation
    for layer = 1:handles.number_layer
        if handles.data_cell_soil_type(layer,1) == "Cohesive" %selecting soil type
            Qs = pi * handles.diameter_pile * handles.data_cell_values(layer,4) * handles.data_cell_values(layer,5) * (handles.data_cell_values(layer,2) - handles.data_cell_values(layer,1));
			Qs_total = Qs_total + Qs;
        else %if it is noncohesive, there are a couple of probabilities. All probabilities are formulazed as below
            if handles.data_cell_values(layer,2) < handles.Zcr && handles.length_pile >= handles.data_cell_values(layer,2) %if bottom elevation of layer is less than critical depth and pile continuous
                Qs = pi * handles.diameter_pile * handles.Ks * ((handles.plot_stress(layer,1) + handles.plot_stress(layer+1,1))/2)  * tand(handles.data_cell_values(layer,6)*0.75) * (handles.data_cell_values(layer,2) - handles.data_cell_values(layer,1));   
                Qs_total = Qs_total + Qs;
            elseif handles.data_cell_values(layer,2) < handles.Zcr && handles.length_pile < handles.data_cell_values(layer,2)%if bottom elevation of layer is less than critical depth and pile ends in this layer
                Qs = pi * handles.diameter_pile * handles.Ks * ((handles.plot_stress(layer,1) + handles.plot_stress(layer+1,1))/2)  * tand(handles.data_cell_values(layer,6)*0.75) * (handles.length_pile - handles.data_cell_values(layer,1));   
                Qs_total = Qs_total + Qs;
            else %if bottom elevation is equal to or more than critical depth
                if (handles.data_cell_values(layer,1) + handles.data_cell_values(layer,2))/2 < handles.Zcr && handles.length_pile >= handles.data_cell_values(layer,2) %if bottom elevation of layer is more than critical depth and pile continuous
                    Qs = pi * handles.diameter_pile * handles.Ks * ((handles.plot_stress(layer,1) + handles.plot_stress(layer+1,1))/2)  * tand(handles.data_cell_values(layer,6)*0.75) * (handles.data_cell_values(layer,2) - handles.data_cell_values(layer,1));
                    Qs_total = Qs_total + Qs;
                elseif (handles.data_cell_values(layer,1) + handles.data_cell_values(layer,2))/2 < handles.Zcr && handles.length_pile < handles.data_cell_values(layer,2)%if bottom elevation of layer is more than critical depth and pile ends in this layer
                    Qs = pi * handles.diameter_pile * handles.Ks * ((handles.plot_stress(layer,1) + handles.plot_stress(layer+1,1))/2)  * tand(handles.data_cell_values(layer,6)*0.75) * (handles.length_pile - handles.data_cell_values(layer,1));
                    Qs_total = Qs_total + Qs;
                else 
                    handles.max_stress = handles.plot_stress(layer,1) + (handles.Zcr - handles.data_cell_values(layer,1)) * (handles.data_cell_values(layer,3) - handles.gama_water);
                    Qs = pi * handles.diameter_pile * handles.Ks * handles.max_stress * tand(handles.data_cell_values(layer,6)*0.75) * (handles.Zcr - handles.data_cell_values(layer,1));
                    Qs_total = Qs_total + Qs;
                    break;
                end
            end
        end
	
    end

for remaining_layers = layer+1:handles.number_layer %if an else statement is occured; skin friction will be calculated from this loop
	if handles.data_cell_soil_type(remaining_layer,1) == "Cohesive"
		Qs = pi * handles.diameter_pile * handles.data_cell_values(remaining_layers,4) * handles.data_cell_values(remaining_layers,5) * (handles.data_cell_values(remaining_layers,2) - handles.data_cell_values(remaining_layers,1));
		Qs_total = Qs_total + Qs;
	else
		Qs = pi * handles.diameter_pile * handles.Ks * handles.max_stress * tand(handles.data_cell_values(remaining_layers,6)) * (handles.data_cell_values(remaining_layers,2) - handles.data_cell_values(remaining_layers,1));
		Qs_total = Qs_total + Qs;
	end
	
end
%tip resistance calculation  
handles.area = pi * handles.diameter_pile^2 / 4;
if handles.data_cell_soil_type(layer,1) == "Cohesive"
	Qp = handles.Nc * handles.data_cell_values(handles.number_layer,4) * handles.area;
else
	Qp = handles.data_cell_values(handles.number_layer,7) * handles.plot_stress(end,1) * handles.area;

end

%total capacity calculation  
Qult = Qs_total + Qp;
%arrangement for GUI
handles.Qs.String = num2str(Qs_total);
handles.Qp.String = num2str(Qp);
handles.Qult.String = num2str(Qult);



%plotting part
handles.hidden2.Visible = "on"; %'effective stress (kPa)' becomes visible

for layer_end = 1:handles.number_layer
    y_values(layer_end) = -1 * handles.data_cell_values(layer_end,2); %obtaining depth inputs
end
y_values = [0 ; y_values']; %it should start with zero
for y = 1:length(y_values)-1
    yline(y_values(y), 'LineWidth', 1.5);
    text(25,(y_values(y)+y_values(y+1))/2,'Layer ');
    text(28,(y_values(y)+y_values(y+1))/2,string(y)); %writing Layers' names to the right side of plot
    hold on
end
yline(y_values(end), 'LineWidth', 1.5); %last layer's bottom line
hold on
rectangle('Position',[-7 -1*handles.length_pile handles.diameter_pile*2 handles.length_pile],'FaceColor',[0.859 0.855 0.843]); %pile plotting (dimaeter of pile is scaled to have a better view)
hold on
line(zeros(length(y_values),1) ,y_values,'LineWidth',2,'Color','k'); %drawing base line for stresses
hold on
plot_stress = handles.plot_stress ./ handles.scale; %scaling

ylim([y_values(end)-2 0]);
xlim([-10 30]);
handles.axes1.YTick = sort(y_values'); %arrangements for a better display

if handles.data_cell_values(end,2)>=handles.Zcr
    y_values = [-1 * handles.Zcr ;y_values];
    y_values = sort(y_values,'descend'); %reassigning of y values in case of critical depth included
end
yline(-1 * handles.length_pile,'-.',"Length = " + string(handles.length_pile) + "m",'LabelHorizontalAlignment','left','LabelVerticalAlignment','bottom','FontSize',10); %indicating pile length

line(plot_stress,y_values) %stress plotting
critical_string = sprintf("(Dcr = %.2f m)",handles.Zcr); %in critical depth, this string will be typed.
critical_depth_index = find(handles.data_cell_values(:,2) >= handles.Zcr,1) + 1; %finding the indice of critical depth
for printed_text = 1:length(plot_stress)
    if printed_text == 1
        text(0.5, -0.5,string(handles.plot_stress(printed_text)));
    elseif printed_text == critical_depth_index
        text(plot_stress(printed_text)+0.2 , y_values(printed_text)-0.5 ,string(handles.plot_stress(printed_text)) + " "+ critical_string);
    else
        text(plot_stress(printed_text)+0.2 , y_values(printed_text)+0.5 , string(handles.plot_stress(printed_text)));
    end
end

guidata(hObject, handles);

% handles    structure with handles and user data (see GUIDATA)



function length_pile_Callback(hObject, eventdata, handles)
% hObject    handle to length_pile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.length_pile = str2double(get(hObject,'String')); %getting length of pile
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of length_pile as text
%        str2double(get(hObject,'String')) returns contents of length_pile as a double


% --- Executes during object creation, after setting all properties.
function length_pile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to length_pile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function diameter_pile_Callback(hObject, eventdata, handles)
% hObject    handle to diameter_pile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.diameter_pile = str2double(get(hObject,'String'));
handles.Zcr = 15 * handles.diameter_pile; %obtaining critical depth
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of diameter_pile as text
%        str2double(get(hObject,'String')) returns contents of diameter_pile as a double


% --- Executes during object creation, after setting all properties.
function diameter_pile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diameter_pile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_export.
function pushbutton_export_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_export (see GCBO)
    global number_layer
    number_layer = handles.number_layer;
    global data_cell_soil_type
    data_cell_soil_type = handles.data_cell_soil_type;
    global data_cell_values
    data_cell_values = handles.data_cell_values;
    global diameter_pile
    diameter_pile = handles.diameter_pile;
    global length_pile
    length_pile = handles.length_pile;
    global Qs
    Qs = handles.Qs.String;
    global Qp
    Qp = handles.Qp.String;
    global Qult
    Qult = handles.Qult.String;
    save('ce461_FINAL_KaanTan_2162824.mat','number_layer','data_cell_soil_type','data_cell_values','diameter_pile','length_pile','Qs','Qp','Qult');
    %To be able to reach those values in export file, it is assigned to
    %their global variables.
    
    options.showCode = false;
    options.format = 'pdf';
    options.evalCode = true;%https://www.mathworks.com/matlabcentral/answers/92636-how-can-i-publish-to-html-without-the-matlab-code-being-automatically-inserted-as-comments-into-the
    options.codeToEvaluate = 'export'; %https://www.mathworks.com/matlabcentral/answers/553885-getting-the-error-unable-to-resolve-the-name-filename-m-while-trying-to-run-a-script
    
    publish('export.m',options);
 
% eventdata  reserved - to be defined in a future version of MATLAB
guidata(hObject, handles);
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in table.
function table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
handles.data_cell = get(handles.table, 'Data'); %getting and storing data_cell
guidata(hObject, handles);
% handles    structure with handles and user data (see GUIDATA)

function plot_stress = layer_above_effective_stress(handles)
    stress = zeros(handles.number_layer+1,1); %preallocation
	if handles.data_cell_values(1,2) < handles.Zcr %checking first stress value
		stress(1,1) = handles.data_cell_values(1,2) * (handles.data_cell_values(1,3) - handles.gama_water);
	else 
		max_stress = handles.Zcr * (handles.data_cell_values(1,3) - handles.gama_water);
		for katman = 2:handles.number_layer+1
			stress(katman,1) = max_stress;
		end
		plot_stress = [0 ; stress];
        return;
	end

	for katman = 2:handles.number_layer %for other layers, stress values are obtained as follows.
		if handles.data_cell_values(katman,2) < handles.Zcr
			stress(katman,1) = (handles.data_cell_values(katman,2) - handles.data_cell_values(katman,1)) * (handles.data_cell_values(katman,3) - handles.gama_water) + stress(katman-1,1);
		else
			max_stress = (handles.Zcr - handles.data_cell_values(katman,1)) * (handles.data_cell_values(katman,3) - handles.gama_water) + stress(katman-1,1);
			for devam = katman:handles.number_layer+1 %if a layer's depth is equal to or more than critical depth, maximum stress is calculated and remaining stress values are assigned this maximum value; then parent loop is broken
				stress(devam,1) = max_stress;
            end
			break;
		end
    end
    plot_stress = [0; stress]; %since plotting will start from 0, 0 is added for the sake of plotting

% --- Executes on button press in plot_reset.
function plot_reset_Callback(hObject, eventdata, handles)
% hObject    handle to plot_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
cla; %cleans plot to draw another stress graphs without closing the GUI
% handles    structure with handles and user data (see GUIDATA)
