% Demo for Edge Boxes (please see readme.txt first).

%% load pre-trained edge detection model and set opts (see edgesDemo.m)
model=load('models/forest/modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;

%% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .65;     % step size of sliding window search
opts.beta  = .75;     % nms threshold for object proposals
opts.minScore = .01;  % min score of boxes to detect
opts.maxBoxes = 1e4;  % max number of boxes to detect

%% detect Edge Box bounding box proposals (see edgeBoxes.m)
I = imread('/u/zhan2212/Desktop/2007/VOCdevkit/VOC2007/JPEGImages/000319.jpg');
tic, bbs=edgeBoxes(I,model,opts); toc

%% show evaluation results (using pre-defined or interactive boxes)
gt=[122 248 92 65; 193 82 71 53; 410 237 101 81; 204 160 114 95; ...
  9 185 86 90; 389 93 120 117; 253 103 107 57; 81 140 91 63];
if(0), 
    gt='Please select an object box.'; disp(gt); figure(1); imshow(I);
    title(gt); [~,gt]=imRectRot('rotate',0); gt=gt.getPos(); 
end
gt(:,5)=0; [gtRes,dtRes]=bbGt('evalRes',gt,double(bbs),.7);
figure(5); bbGt('showRes',I,gtRes,dtRes(dtRes(:,6)==1,:));
title('green=matched gt  red=missed gt  dashed-green=matched detect');
%% 
%% 
%% 
%% 
%% Edge Detector
% I = spb.thin>0.5;
opt = initialopt;
% edge detection
[E,O]=edgesDetect(I,model); 
E=edgesNmsMex(E,O,2,0,1,4);
%% 

% get curve segments
% I = ((spb.thin>0.75)+(E>0.3))>0;
load('/u/zhan2212/Desktop/2007/MilResult/000319.mat');
E = spb.thin>0.1;

opt = initialopt;
% I = spb.thin>0.2;
edges_fname = './edge.png';
imwrite(E, edges_fname, 'png');

%% perceptual edge grouping
tic
SegList  = GetConSeg( E );
% obtain perceptual grouping result by graph-cuts
labels = GestaltGroupRsvm(SegList,[1.1007 -0.0011],0.7); %  SegList,opt.RelativeImp,opt.C
toc
% show grouping result
% showGrouping(SegList,labels,edges_fname); 
ContourList = GroupBB(labels, SegList);
bbs = Showbbs(ContourList,bbs,I);
toc
%% Color of Medial Axes
[newContourList diffMatrix flagList] =  colorGroup(ContourList,I);

%% 
figure(2),im(E);
for i=1:size(ContourList,2)
    ymax = max(ContourList{1,i}(:,1));
    ymin = min(ContourList{1,i}(:,1));
    xmax = max(ContourList{1,i}(:,2));
    xmin = min(ContourList{1,i}(:,2));
    figure(2),drawBoxes([xmin ymin xmax ymax],'lineWidth',1);
end    
%% 

% figure(2),im(I);

figure(5),im(I);
Sortedbbs = Showbbs(ContourList,spb,bbs,I,5); % Demonstrate the result, the 4th variable means top x boxes
%% 

figure(5),im(I);
hold on;
m = 400;
numBoxes = size(bbs,1)
for i=1:m         
   figure(5),drawBoxes(Sortedbbs(numBoxes+1-i,:)+[0 0 Sortedbbs(numBoxes+1-i,1) ...
       Sortedbbs(numBoxes+1-i,2) 0],'lineWidth',1,...
       'color','red'); % Draw the boxes
end

%% 
%% 
%% 
%% 
hold on;
markPG(ContourList(1:4));

%% 
hold on;
markPG(newContourList);

