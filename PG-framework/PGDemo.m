clear all; close all;
addpath(genpath('./'));
load modelBsds.mat;


% initialize parameters, you need to change the relative importance of
% gestalt principles here.
opt = initialopt;

% read input image
imgpath = 'paperplanes.jpg';
I = imread(imgpath);


% edge detection
[E,O]=edgesDetect(I,model); 
E=edgesNmsMex(E,O,2,0,1,4);

% get curve segments
I = E>0.1;
edges_fname = './edge.png';
imwrite(I, edges_fname, 'png');
SegList  = GetConSeg( I );

%% perceptual edge grouping

% obtain perceptual grouping result by graph-cuts
labels = GestaltGroupRsvm( SegList,[18 -0.0011],0.7);
% show grouping result
showGrouping(SegList,labels,edges_fname); 

ContourList = GroupBB(labels, SegList);
%% 
hold on;
markPG(ContourList);


