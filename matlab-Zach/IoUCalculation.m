function IoU = IoUCalculation(ContourList,m,k,w,h,spb)
    minX = m;
    maxX = m+w;
    minY = k;
    maxY = k+h;
    numContours = size(ContourList,2);
    labelContour =zeros(1,numContours);
    
    
    areaInside = 0;
    for i=1:numContours
        numPixels = size(ContourList{1,i},1);
        for j=1:numPixels
            X = ContourList{1,i}(j,2);
            Y = ContourList{1,i}(j,1);
            if (minX<=X && X<=maxX) && (minY<=Y && Y<=maxY) 
                labelContour(i)=1;
                areaInside = areaInside + 2*spb.scales(spb.scalesMap(Y,X));
            end 
        end
    end
    
    areaOutside = 0;
    for i=1:numContours
        numPixels = size(ContourList{1,i},1);
        for j=1:numPixels
            X = ContourList{1,i}(j,2);
            Y = ContourList{1,i}(j,1);
            if labelContour(i)==1 && ~((minX<=X && X<=maxX) && (minY<=Y && Y<=maxY))
                areaOutside = areaOutside + 2*spb.scales(spb.scalesMap(Y,X));
            end
        end
    end 
    
    IoU = areaInside/(areaOutside+w*h);
       
end