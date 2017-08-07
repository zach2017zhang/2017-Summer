function Sortedbbs = spbScoreBoxes(ContourList,bbs,I,spb,num)
% I will layout the steps that you have to code to make it easier for you.
% It's better if you (at least try to) do it yourself for practice.
%
% As we discussed, spb.scalesMap and spb.orientMap contain *indices* of the
% estimated scale and orientation at each point. spb.scales and spb.thetas
% contain the ranges of the actual values for rectangle sides and
% orientations that are used. As you can see there are 8 orientations and
% 13 scales used.
% 
% 1. The first step you should do is pre-allocating and pre-computing all
% the quantities that will be necessary for you. You have a fixed number of 
% scale-orientation combinations so you should pre-compute all these 
% rectangular masks and store them in a cell arraym where rect{s,o} will be
% a rectangle at scale s and orientation o.
% 
% Then, for each box:
% 2. Find which groups are contained (here you can try both fully contained 
% and not-fully contained groups).
% 
% 3. create the union of their rectangular masks (which will be easy to do 
% since you have precomputed everything)
% 
% 4. compute the IOU score. I have a function called iou() in my 
% matlab-utils toolkit that does exactly that thing, so you don't need to 
% rewrite the code yourself.
% 
% Do these steps and then I will take another look at the code. 

Ysize = size(I,1); % size of the picture in Y direction
Xsize = size(I,2); % size of the picture in X direction
picCenterY = int16(Ysize/2); % position of the midpoint in Y direction
picCenterX = int16(Xsize/2); % position of the midpoint in X direction

numBoxes = size(bbs,1); % the number of boxes proposed
IOUscores = zeros(numBoxes,1); 


rect = getMask(spb); % precalculate all the combinations, rect{s,o} 
                     % represents a rectangle at scale s and orientation o

maskReCell = cell(Ysize,Xsize);


for i=1:size(ContourList,2)
    numPixels = size(ContourList{1,i},1);    
    for j=1:numPixels
        X = ContourList{1,i}(j,2);
        Y = ContourList{1,i}(j,1);
        mask = rect{spb.scalesMap(Y,X),spb.orientMap(Y,X)};
        maskReCell{Y,X} = mvMatrix(mask,X-picCenterX,Y-picCenterY);
        % translate the precalculated rectangle to its original position
        % and store them into maskReCell{}
    end
end


for i=1:numBoxes
    % rescore bbs
    IOU = boxScore(bbs(i,:),ContourList,maskReCell,Ysize,Xsize);
    IOUscores(i) = IOU;
    
end
bbs(:,end) = IOUscores;
Sortedbbs = sortrows(bbs,5); % Sort the matrix in terms of the score
Sortedbbs = flipud(Sortedbbs);% flip, make the scores in descending order
    
%plot the result    
figure(),im(I);
hold on;
title('axis bbs');

for i=1:num           
  drawBoxes(Sortedbbs(numBoxes+1-i,:)+[0 0 Sortedbbs(numBoxes+1-i,1) ...
      Sortedbbs(numBoxes+1-i,2) 0],'lineWidth',1,...% 'scores',Normbbs(m+1-i),...
      'color','red'); % Draw the boxes

end

end


% -------------------------------------------------------------------------
function IOU = boxScore(sbbs,ContourList,maskReCell,Ysize,Xsize)


x = sbbs(1);
y = sbbs(2);
w = sbbs(3);
h = sbbs(4);


unionPic = zeros(Ysize,Xsize);

numAxisInside = 0;

for i=1:size(ContourList,2)
    inside = 0;
    numPixels = size(ContourList{1,i},1);
    
    for j=1:numPixels
        X = ContourList{1,i}(j,2);
        Y = ContourList{1,i}(j,1);

        if (x+w>X)&&(X>x)&&(h+y>Y)&&(Y>y)
            Recell = maskReCell{Y,X}; % load the precalculated mask, which 
                                      % is already in the right position
            
            % exclude the pixels outside the bbox
            NewRecell=Recell;
            NewRecell(1:y,:)=0; 
            NewRecell(:,1:x)=0;
            NewRecell(:,x+w:end)=0;
            NewRecell(y+h:end,:)=0;
            
            axisReArea = sum(NewRecell(:));% the area of a certain group of 
                                           % medial axis inside a bbox
                                           
            if axisReArea > 0.05*(w*h) % set the threshold of 5%
                unionPic = unionPic + Recell; % add up all the masks for reconstruction
                inside=1;
            end
        end
        
    end
   
    numAxisInside =numAxisInside+inside; % number of the groups of medial axes inside the bbox
end

interPic = unionPic;
interPic(1:y,:)=0; 
interPic(:,1:x)=0;
interPic(:,x+w:end)=0;
interPic(y+h:end,:)=0;

interPic = interPic > 0;
unionPic = unionPic > 0;
unionPic(y:y+h,x:x+w) = 1;
unionArea = sum(unionPic(:));% count the pixels to represent area



interArea = sum(interPic(:));% count the pixels to represent area
IOUScore = interArea/unionArea;


if numAxisInside~=0
    IOU = IOUScore;
else
    IOU = 0; 
end

end