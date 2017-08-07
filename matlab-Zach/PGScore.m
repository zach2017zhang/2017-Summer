function Pb = PGScore(ContourList, sbbs,E,n)

m = sbbs(1);
k = sbbs(2);
w = sbbs(3);
h = sbbs(4);

MerContour = vertcat(ContourList{:}); % Merge ContourList

% Find the index of the pixel arrays outside the box
XIndicesmin = find(MerContour(:,2)<= m); 
XIndicesmax = find(MerContour(:,2)>= m+w);
YIndicesmin = find(MerContour(:,1)<= k);
YIndicesmax = find(MerContour(:,1)>= k+h);

RemoveIndex = vertcat(XIndicesmin,XIndicesmax,YIndicesmin,YIndicesmax); % Combined the pixels need to be removed

MerContour(RemoveIndex,:) = []; % Remove the pixels outside the box 

% Calculate convex hull of the contours inside the box
xx = MerContour(:,2);
yy = MerContour(:,1);
k = convhull(xx,yy);

A = polyarea(xx(k),yy(k)); % calculate the area of convex hull

Pb =A/(w*h)^2/n; % Equation 5
    
end