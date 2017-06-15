function contourList = groupContours(labels, SegList)

% New version
labelsUnique = unique(labels);  % find unique labels
nLabels = numel(labelsUnique);
contourList = cell(nLabels,1);  % pre-allocate cell array
for i=1:nLabels 
    % Find which entries correspond to label i and concatenate all
    % coordinates
    contourList{i} = cat(1, SegList{labels == labelsUnique(i)});
end

end
