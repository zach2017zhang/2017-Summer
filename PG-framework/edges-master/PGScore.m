function Pb = PGScore(ContourList, sbbs,E,n)

m = sbbs(1);
k = sbbs(2);
w = sbbs(3);
h = sbbs(4);

MerContour = vertcat(ContourList{:}); % Merge ContourList

% Find the index of the pixel arrays outside the box
outsideBox = MerContour(:,2)<=m | MerContour(:,2)>= m+w | ...
             MerContour(:,1)<=k | MerContour(:,1)>= k+h;
MerContour(outsideBox,:) = []; % Remove the pixels outside the box 

% Calculate convex hull of the contours inside the box
xx = MerContour(:,2);
yy = MerContour(:,1);
[k,cvhullArea] = convhull(xx,yy);
boxArea = w*h;
closure = cvhullArea/boxArea;

Pb = cvhullArea/boxArea^2/n; % Equation 5
% Pb =(closure/n)*boxArea; % Equation 5    
end


% XIndicesmin = find(MerContour(:,2)<= m); 
% XIndicesmax = find(MerContour(:,2)>= m+w);
% YIndicesmin = find(MerContour(:,1)<= k);
% YIndicesmax = find(MerContour(:,1)>= k+h);
% RemoveIndex = vertcat(XIndicesmin,XIndicesmax,YIndicesmin,YIndicesmax); % Combined the pixels need to be removed
