function s = axisScore(ContourList,spb,sbbs,E,n)
    axisMatrix = spb.thin>0.3;
    m = sbbs(1);
    k = sbbs(2);
    w = sbbs(3);
    h = sbbs(4);
    
    axisMatrix(1:m,:)=0;
    axisMatrix(:,1:k)=0;
    axisMatrix(m+w:end,:)=0;
    axisMatrix(:,k+h:end)=0;
    
    
    %  k = bwconvhull(axisMatrix);
    %  cvhullArea = sum(k(:));

    boxArea = w*h;
    %  closure = cvhullArea/boxArea;
    %  s = cvhullArea/boxArea^2/n; % Equation 5
    
    % axisLength = sum(axisMatrix(:));
    % if n==1
    %    s = axisLength/(2*w+w*h)^2;
    % else
    %    s = 0;
    % end
    ScalesMap = spb.scalesMap;
    axisScalesArray = spb.scales(ScalesMap(logical(axisMatrix)));
    axisArea = 2 * sum(axisScalesArray);
    if n~=0
        s = axisArea/boxArea^2/n;
    else
        s = 0;
    end
    
    % calculate IoU
    IoU = IoUCalculation(ContourList,m,k,w,h,spb);
    s = s*IoU;
    
end