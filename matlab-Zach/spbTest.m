%% 
%% Load the Picture and Spb
I = imread('/u/zhan2212/Desktop/2007/VOCdevkit/VOC2007/JPEGImages/000616.jpg');
load('/u/zhan2212/Desktop/2007/MilResult/000616.mat');
%% load models for bbs

% load pre-trained edge detection model and set opts (see edgesDemo.m)
model=load('models/forest/modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;

% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .65;     % step size of sliding window search
opts.beta  = .75;     % nms threshold for object proposals
opts.minScore = .01;  % min score of boxes to detect
opts.maxBoxes = 1e4;  % max number of boxes to detect

%% 

opt = initialopt;
% edge detection
[E,O]=edgesDetect(I,model); 
E=edgesNmsMex(E,O,2,0,1,4);
edges_fname = './edge.png';
imwrite(E, edges_fname, 'png');


bbs=edgeBoxes(I,model,opts); % get bbs
E = spb.thin>0.1;


%% Get PG Grouping Result

SegList  = GetConSeg(E);
% obtain perceptual grouping result by graph-cuts
labels = GestaltGroupRsvm(SegList,[1.1007 -0.0011],0.5000); %  SegList,opt.RelativeImp,opt.C

% show grouping result
% showGrouping(SegList,labels,edges_fname); 
ContourList = GroupBB(labels, SegList);
% bbs = Showbbs(ContourList,bbs,I,200,spb);
% newContourList =  colorGroup(ContourList,I);

%% IOU Score by reconstruct symmetry box
sortedbbs = spbScoreBoxes2(ContourList,bbs,I,spb,100);

%% Axis Score by tracing each pixel
Sortedbbs = spbShowbbs(ContourList,bbs,I,spb,E,100);



