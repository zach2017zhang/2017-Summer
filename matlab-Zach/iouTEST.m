%%

%%

path = '/u/zhan2212/Desktop/2012/VOCdevkit/VOC2012/SegmentationObject';
fileList = dir(path);
fileCell=cell(2913);
for i=3:size(fileList,1)
    fileCell{i-2}=fileList(i).name(6:11);
    %disp(fileList(i).name(6:11));
end

for i=1:size(fileCell)
    num = str2num(fileCell{i});
    disp(num+2);
    %disp(fileCell{i});
end


%%

path = '/u/zhan2212/Desktop/2012/VOCdevkit/VOC2012/SegmentationObject/';
file = '2007_000032.png';
fullname=strcat(path,file);

pic = imread(fullname);

picPath ='/u/zhan2212/Desktop/2017-Summer-master/EdgeDetector/boxes/VOCdevkit/VOC2007/JPEGImages/000032.jpg';
I = imread(picPath);


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
%%
num=100;
Sortedbbs = groundTruthTest(bbs,I,pic,num); 






