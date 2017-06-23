function sortedbbs = spbScoreBoxes(contourList,bbs,I,spb)
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


for i=1:numBoxes
    n = numGroupsInsideBox(contourList,bbs(i,:)); % calculate n
    if n > 0
        scores(i) = boxScore(bbs,contourList);
    end
    bbs(:,end) = scores;
    sortedbbs = sortrows(bbs,5); % Sort the matrix in terms of the score
    
    
    % Selectedbbs = Sortedbbs(numBoxes+1-m:numBoxes,5); % Extract the top m score
    % Normbbs = (Selectedbbs - min(Selectedbbs))/(max(Selectedbbs) - ...
    %     min(Selectedbbs)); % Normalize the selected score for drawBoxes function
    
    %figure(),im(I);
    % hold on;
    %title('axis bbs');
    
    %for i=1:num
    %     Sortedbbs(numBoxes+1-i,2) 0],'lineWidth',1,...% 'scores',Normbbs(m+1-i),...
    %    'color','red'); % Draw the boxes
    %end
    
end


% -------------------------------------------------------------------------
function boxScore(bbs,contourList)
axisMatrix = spb.thin>0.3;
y = bbs(1);
x = bbs(2);
w = bbs(3);
h = bbs(4);

axisMatrix(1:y,:)=0;
axisMatrix(:,1:x)=0;
axisMatrix(y+w:end,:)=0;
axisMatrix(:,x+h:end)=0;

boxArea = w*h;
ScalesMap = spb.scalesMap;
axisScalesArray = spb.scales(ScalesMap(logical(axisMatrix)));
axisArea = 2 * sum(axisScalesArray);
if n==1
    s = axisArea/boxArea^2/n;
else
    s = 0;
end

% calculate IoU
IoU = IoUCalculation(contourList,y,x,w,h,spb);
s = s*IoU;
