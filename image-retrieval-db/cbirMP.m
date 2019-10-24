function varargout = cbirMP(varargin)
%CBIRMP M-file for cbirMP.fig
%      CBIRMP, by itself, creates a new CBIRMP or raises the existing
%      singleton*.
%
%      H = CBIRMP returns the handle to a new CBIRMP or the handle to
%      the existing singleton*.
%
%      CBIRMP('Property','Value',...) creates a new CBIRMP using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to cbirMP_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CBIRMP('CALLBACK') and CBIRMP('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CBIRMP.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cbirMP

% Last Modified by GUIDE v2.5 01-Apr-2008 11:47:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cbirMP_OpeningFcn, ...
                   'gui_OutputFcn',  @cbirMP_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before cbirMP is made visible.
function cbirMP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for cbirMP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cbirMP wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%----- loading the database -----
string = 'LOADING DATABASE FILES...';
set(handles.info_box,'String',string); 
pause(1)

load databaseInfo.mat

string = 'DATABASE FILES LOADED.';
set(handles.info_box,'String',string);

handles.META_DATA = META_DATA; 
handles.filenames = LIST;
guidata(hObject,handles)

clear META_DATA filenames clases;

%----- initialize RF weighting matrix -----
W = eye(size(handles.META_DATA,1));
handles.W = W;
guidata(hObject,handles);

%----- display a random image -----
h2=handles.axes1;
axes(h2); 

imgInd = randint(1,1,size(handles.META_DATA,2))+1;
handles.currentfilename = strcat('IMAGES/',handles.filenames(imgInd,:));
handles.posInds = imgInd;
guidata(hObject,handles);

imshow(handles.currentfilename)

handles.currentTopInds = [];

guidata(hObject,handles);

% --- Outputs from this function are returned to the command line.
function varargout = cbirMP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in query_button.
function query_button_Callback(hObject, eventdata, handles)
% hObject    handle to query_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

string = 'RETRIEVING IMAGES';
set(handles.info_box,'String',string); 
pause(1)

%get the feedback information
for i=1:20
    feedback(i) = eval(strcat('get(handles.rfRadio',num2str(i),',''Value'')'));
end
handles.feedback = feedback;
handles.posInds = unique([handles.posInds,handles.currentTopInds(find(feedback))]);
guidata(hObject,handles);

% Compute the mean image-feature vector 
%for images that represent the user's intended interest (given as the indices in handles.posInds)
means = mean(handles.META_DATA(:,handles.posInds),2);

% call RF
W = RF(handles.META_DATA, handles.posInds, handles.feedback);
handles.W = W;
guidata(hObject,handles);

% Using the relevance feedback weighting matrix returned from the call RF(handles), 
% compute the Mahalanobis distance between the mean query-image(s) vector to each of the database image feature-vectors
% where qc is the mean query-image(s) feature vector and xj is the j-th database image's feature-vector.
dist = zeros(0,1400);
for img = 1:length(handles.META_DATA)
    dist(img) = (means - handles.META_DATA(:,img))' * handles.W * (means - handles.META_DATA(:,img));
end

% Rank sort the distances in D(j) from smallest to largest, 
% and return the indices of the smallest distances to handles.currentTopInds
num_rel = 20;
[~,indices] = sort(dist);
handles.currentTopInds = indices(1:num_rel);
guidata(hObject,handles);

%plot outputs
if ~isempty(handles.currentTopInds)
    for i=1:20
        h=eval(strcat('handles.',sprintf('axes%d',i+1)));   
        axes(h); 

        handles.currentfilename = strcat('IMAGES/',handles.filenames(handles.currentTopInds(i),:));

        imshow(handles.currentfilename)
    end
end

%set the feedback information to zero
for i=1:20
    eval(strcat('set(handles.rfRadio',num2str(i),',''Value'',0)'));
end

string = 'PLEASE PROVIDE FEEDBACK...';
set(handles.info_box,'String',string); 
pause(1)

guidata(hObject,handles);

% --- Computes the weighting matrix for Relevance Feedback
function W = RF(META_DATA, posInds, feedback)

% Handles used for sharing data among call-back functions globally.
% In general, call-back functions manipulate data locally.

% initial feedback round = 0, else
if (isempty(feedback))
    W = eye(47,47);
else 
    W = zeros(47,47);
    for feat_dim = 1:47
        feat = META_DATA(feat_dim,:);
        samp = feat(posInds);
        samp_var = var(samp) + .0222;
        W(feat_dim,feat_dim) = 1/samp_var;
    end
end


% --- Executes on button press in random_button.
function random_button_Callback(hObject, eventdata, handles)
% hObject    handle to random_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----- display a random image -----
h=handles.axes1;
axes(h); 

imgInd = randint(1,1,size(handles.META_DATA,2))+1;
handles.currentfilename = strcat('IMAGES/',handles.filenames(imgInd,:));
handles.posInds = imgInd;
guidata(hObject,handles);

set(handles.info_box,'String',handles.filenames(imgInd,:)); 

imshow(handles.currentfilename)

%----- re-initialize data structures -----
handles.W = eye(size(handles.META_DATA,1));;
handles.currentTopInds = [];

%set the feedback information to zero
for i=1:20
    eval(strcat('set(handles.rfRadio',num2str(i),',''Value'',0)'));
end

guidata(hObject,handles);

% --- Executes on button press in filenameDropDown.
function fileget_button_Callback(hObject, eventdata, handles)
% hObject    handle to filenameDropDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----- get the image from the drop-down-----
fileNum = get(handles.filenameDropDown,'Value');
allNames = get(handles.filenameDropDown,'String');
handles.currentfilename = strcat('IMAGES/',allNames{fileNum});

imgInd = find(sum((handles.filenames == repmat(allNames{fileNum},size(handles.META_DATA,2),1))') == 10);
handles.currentfilename = strcat('IMAGES/',handles.filenames(imgInd,:));
handles.posInds = imgInd;

guidata(hObject,handles);

h=handles.axes1;
axes(h); 

imshow(handles.currentfilename)

%----- re-initialize data structures -----
handles.W = eye(size(handles.META_DATA,1));;
handles.currentTopInds = [];

%set the feedback information to zero
for i=1:20
    eval(strcat('set(handles.rfRadio',num2str(i),',''Value'',0)'));
end

guidata(hObject,handles);



function rfRadio1_Callback(hObject, eventdata, handles)
function rfRadio2_Callback(hObject, eventdata, handles)
function rfRadio3_Callback(hObject, eventdata, handles)
function rfRadio4_Callback(hObject, eventdata, handles)
function rfRadio5_Callback(hObject, eventdata, handles)
function rfRadio6_Callback(hObject, eventdata, handles)
function rfRadio7_Callback(hObject, eventdata, handles)
function rfRadio8_Callback(hObject, eventdata, handles)
function rfRadio9_Callback(hObject, eventdata, handles)
function rfRadio10_Callback(hObject, eventdata, handles)
function rfRadio11_Callback(hObject, eventdata, handles)
function rfRadio12_Callback(hObject, eventdata, handles)
function rfRadio13_Callback(hObject, eventdata, handles)
function rfRadio14_Callback(hObject, eventdata, handles)
function rfRadio15_Callback(hObject, eventdata, handles)
function rfRadio16_Callback(hObject, eventdata, handles)
function rfRadio17_Callback(hObject, eventdata, handles)
function rfRadio18_Callback(hObject, eventdata, handles)
function rfRadio19_Callback(hObject, eventdata, handles)
function rfRadio20_Callback(hObject, eventdata, handles)
function filenameDropDown_Callback(hObject, eventdata, handles)