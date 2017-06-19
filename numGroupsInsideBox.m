function n = numGroupsInsideBox(ContourList,sbbs)

% New version
n = zeros(size(sbbs,1)); % vector of number of contours in each box
for i=1:numel(ContourList)  % for each contour
    c = ContourList{i};
    % find min and max coordinates
    ymin = min(c(:,1)); 
    ymax = max(c(:,1));
    xmin = min(c(:,2));
    xmax = max(c(:,2));
    % Check what boxes fully enclose the contour
    insideBox = ymin >= sbbs(:,2) & ymax <= sbbs(:,4)+sbbs(:,2) & ...
                xmin >= sbbs(:,1) & xmax <= sbbs(:,3)+sbbs(:,1);
    % Increase counter by 1
    n(insideBox) = n(insideBox) + 1;
end


end