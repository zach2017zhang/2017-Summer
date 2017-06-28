function sortedbbs = spbScoreBoxes(ContourList,bbs,I,spb,num)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rect = getMask(spb); %%%%% 1.rect{s,o}%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rect{s,o} is a picture of a rectangle, whose center is also at (50,50)


for i=1:numBoxes
    n = numGroupsInsideBox(ContourList,bbs(i,:)); % calculate n
    if n > 0
        scores(i) = boxScore(bbs,ContourList,spb,rect);
    end
end
bbs(:,end) = scores;
Sortedbbs = sortrows(bbs,5); % Sort the matrix in terms of the score

    
    % Selectedbbs = Sortedbbs(numBoxes+1-m:numBoxes,5); % Extract the top m score
    % Normbbs = (Selectedbbs - min(Selectedbbs))/(max(Selectedbbs) - ...
    %     min(Selectedbbs)); % Normalize the selected score for drawBoxes function
    
    figure(),im(I);
    hold on;
    title('axis bbs');
    
    for i=1:m           
      figure(),drawBoxes(Sortedbbs(numBoxes+1-i,:)+[0 0 Sortedbbs(numBoxes+1-i,1) ...
          Sortedbbs(numBoxes+1-i,2) 0],'lineWidth',1,...% 'scores',Normbbs(m+1-i),...
          'color','red'); % Draw the boxes
    end
end


% -------------------------------------------------------------------------
function IOUScore = boxScore(bbs,contourList,spb,rect)

x = bbs(1);
y = bbs(2);
w = bbs(3);
h = bbs(4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. find contour groups inside & 3. label the contour groups inside(not entirely)
[pic,labelContour] = spbMaskReconstruct(spb,contourList,bbs,rect);%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pic = pic>0;
unionPic = zeros(size(spb.orientMap,1),size(spb.orientMap,2));
% find out the union picture 
for i=find(labelContour) 
    % trace the inside groups of contour
   [contourPic,~] = spbMaskReconstruct(spb,{contourList{1,i}},bbs,rect);
   unionPic = unionPic + contourPic; 
   % trace each group of contours one by one and add up their reconstructed
   % patterns
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




end
    
