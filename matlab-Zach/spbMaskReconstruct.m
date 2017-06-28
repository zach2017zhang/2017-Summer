function [pic,labelContour] = spbMaskReconstruct(spb,ContourList,bbs,rect)
% pic: Return the reconctructed binary picture from spb, using spb.scales,
% spb.orient
% labelContour: labels the contour group, which is contained by bounding
% box(not entirely)

m = bbs(1); % x value of top left corner of bbs
k = bbs(2); % y value of top left corner of bbs
w = bbs(3); % width of bbs
h = bbs(4); % height of bbs

minX = m;
maxX = m+w;
minY = k;
maxY = k+h;
numContours = size(ContourList,2); % # of contour groups
labelContour =zeros(1,numContours);

pic = zeros(size(spb.orientMap,1),size(spb.orientMap,2));

for i=1:numContours
    numPixels = size(ContourList{1,i},1);
    for j=1:numPixels
        X = ContourList{1,i}(j,2);
        Y = ContourList{1,i}(j,1);
        mask = rect{spb.scalesMap(Y,X),spb.orientMap(Y,X)};
        % extract the correct rectangle from precalculated rect{}
        pic = pic + mvMatrix(mask,X-50,Y-50);
        % move the pattern from (50,50) to (X,Y)
        
        if (minX<=X && X<=maxX) && (minY<=Y && Y<=maxY)&& (labelContour(i)~=1) % if inside and unlabeled
            labelContour(i)=1; % label the contours inside   
        end 
    end
end




end