function [pic,axisGroupMap,axisReCell] = spbMaskReconstruct(spb,ContourList,rect)
% pic: Return the reconctructed binary picture from spb, using spb.scales,
% spb.orient
% labelContour: labels the contour group, which is contained by bounding
% box(not entirely)

numContours = size(ContourList,2); % # of contour groups
% labelContour =zeros(1,numContours);
axisReCell=cell(1,numContours); % store the precalculated reconstructed medial axises

Ysize = size(spb.orientMap,1);
Xsize = size(spb.orientMap,2);

pic = zeros(Ysize,Xsize);
axisGroupMap = zeros(Ysize,Xsize); % show each pixel belong to which group

picCenterY = int16(Ysize/2);
picCenterX = int16(Xsize/2);



for i=1:numContours
    numPixels = size(ContourList{1,i},1);
    axisPic = zeros(Ysize,Xsize);
    for j=1:numPixels
        X = ContourList{1,i}(j,2);
        Y = ContourList{1,i}(j,1);
        
        mask = rect{spb.scalesMap(Y,X),spb.orientMap(Y,X)};
        % extract the correct rectangle from precalculated rect{}
        
        %pic = pic + modMask;
        % move the pattern from (100,100) to (X,Y)
        axisPic = axisPic + mvMatrix(mask,X-picCenterX ,Y-picCenterY);
        % move the pattern from (100,100) to (X,Y) and add up every pixels 
        axisGroupMap(Y,X) = i; 
              
    end
    axisReCell{i}=axisPic; % store into axisReCell{}
    pic = pic + axisPic;
end




end