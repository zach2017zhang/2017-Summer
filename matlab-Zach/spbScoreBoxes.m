function Sortedbbs = spbScoreBoxes(ContourList,bbs,I,spb,num)
% I will layout the steps that you have to code to make it easier for you.
% It's better if you (at least try to) do it yourself for practice.

numBoxes = size(bbs,1); % Get the number of boxes proposed
scores = zeros(numBoxes,1);

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


rect = getMask(spb);
% rect{s,o} is a picture of a rectangle, whose center is also at (100,100)
% (1.rect{s,o})


% precalcualte the reconstructed image
%(2. find contour groups inside & 3. label the contour groups inside(not entirely)
[pic,axisGroupMap,axisReCell] = spbMaskReconstruct(spb,ContourList,rect);

% precalcualte the reconstructed image for each contour group
%numContours = size(ContourList,2); 
%axisReCell=cell(1,numContours); % store the precalculated reconstructed medial axises
%picCenterY = int16(size(I,1)/2);
%picCenterX = int16(size(I,2)/2);

%for i=1:numContours
%    numPixels = size(ContourList{1,i},1);
%    axisPic = zeros(size(I,1),size(I,2));
%    for j=1:numPixels
%        X = ContourList{1,i}(j,2);
%        Y = ContourList{1,i}(j,1);
%        mask = rect{spb.scalesMap(Y,X),spb.orientMap(Y,X)};
%        % extract the correct rectangle from precalculated rect{}
%        axisPic = axisPic + mvMatrix(mask,X-picCenterX,Y-picCenterY);
%        % move the pattern from (100,100) to (X,Y) and add up every pixels    
%    end
%    axisReCell{i}=axisPic; % store into axisReCell{}
%end

% rescore bbs
for i=1:numBoxes

    
    [n,labelContour] = numGroupsBoxCover(axisGroupMap,bbs(i,:));

    if n > 0
        scores(i) = boxScore(bbs(i,:),pic,labelContour,axisReCell,n);
    end
end
bbs(:,end) = scores;
Sortedbbs = sortrows(bbs,5); % Sort the matrix in terms of the score

    
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
function Score = boxScore(bbs,pic,labelContour,axisReCell,n)

x = bbs(1);
y = bbs(2);
w = bbs(3);
h = bbs(4);


pic = pic>0;
unionPic = zeros(size(pic,1),size(pic,2));

% find out the union picture 
for i= labelContour
   if i~= 0
    unionPic = unionPic + axisReCell{i};
   end
end

unionPic = unionPic > 0;
unionPic(y:y+h,x:x+w) = 1;
unionArea = sum(unionPic(:));% count the pixels to represent area

interPic = pic; % find out the intersection part of box and contours
% exclude the part of contours outside the boox 
interPic(1:x,:)=0; 
interPic(:,1:y)=0;
interPic(x+w:end,:)=0;
interPic(:,y+h:end)=0;

interArea = sum(interPic(:));% count the pixels to represent area
IOUScore = interArea/unionArea;


if n~=0
    Score = IOUScore/n;%/n*interArea/(w*h)^2;
else
    Score = 0;
    
end

end
    
