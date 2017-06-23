function newContourList =  colorGroup(contourList,I)

[H,W,~] = size(I);      % image dimensions
I = reshape(I, H*W,3);  % reshape image into a matrix for easier indexing

numGroups = numel(contourList);
colorList = zeros(numGroups,3); % numGroups * RGB
for i=1:numGroups
    % Turn x,y indices to linear indices for this group
    y = contourList{i}(:,1);    % MAKE SURE THESE ARE CORRECT
    x = contourList{i}(:,2);
    inds = sub2ind([H,W],y,x);
    colorList(i,:) = mean(I(inds,:));
end

% Compute Difference
diffMatrix = zeros(numGroups*numGroups,3);

flag = 1;
for i=1:numGroups
    for j=1:numGroups
        diffMatrix((i-1)*numGroups+j,:) = [i j double(sqrt((colorList(i,1)-colorList(j,1))^2 + ...
            (colorList(i,2)-colorList(j,2))^2 +...
            (colorList(i,3)-colorList(j,3))^2))];
        
        % if diffMatrix(i,j) < 0.1 * sqrt((255)^2+(255)^2+(255)^2)
        %    newContourList = {newContourList{:} vertcat(ContourList{1,i},ContourList{1,j})};
        % else
        %    newContourList = {newContourList{:} ContourList{1,i}};
        % end
    end
end

% diffMatrix = diffMatrix < 0.01 * sqrt((255)^2+(255)^2+(255)^2);
% excludeIndex = zeros(numGroups);

newContourList = {};
flagList = zeros(numGroups,1);
flagList(1)=1;
for i=1:numGroups
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % mergeList = ContourList{1,i};
    for j = i+1:numGroups
        
        if flagList(j)==0
            if diffMatrix((i-1)*numGroups+j,3) <= 0.02 * sqrt((255)^2+(255)^2+(255)^2);
                flagList(j)=i;
            else
                flagList(j)=j;
            end
        else
            if diffMatrix((i-1)*numGroups+j,3) <= 0.02 * sqrt((255)^2+(255)^2+(255)^2);
                flagList(j)=flagList(i);
            end
        end
    end
end

uniqueFlagList = unique(flagList);
for i= 1:size(uniqueFlagList)
    index = flagList==uniqueFlagList(i);
    newContourList = {newContourList{:} vertcat(contourList{1,index})};
end
end