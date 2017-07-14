function [n,labelContour] = numGroupsBoxCover(axisGroupMap,sbbs)

    xmin = sbbs(1);
    xmax = sbbs(1)+sbbs(3);
    ymin = sbbs(2); 
    ymax = sbbs(2)+sbbs(4);
    
    axisGroupMap(1:xmin,:)=0; 
    axisGroupMap(:,1:ymin)=0;
    axisGroupMap(xmax:end,:)=0;
    axisGroupMap(:,ymax:end)=0;
    
    axisArray = reshape(axisGroupMap,1,[]);
    
    labelContour = unique(axisArray);
    
    n = size(labelContour,2)-1;



end