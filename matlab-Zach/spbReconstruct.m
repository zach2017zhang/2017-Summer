function J = spbReconstruct(spb)
    axisMatrix = spb.thin>0.2;

    ScalesMap = spb.scalesMap;
    axisScalesMatrix = axisMatrix .* ScalesMap;
    
    
    OrientMap = spb.orientMap;
    axisOrientMatrix = axisMatrix .* OrientMap;
    
    
    
    
    J = axisMatrix;
    
    % orientation1 (0)
    scaleMatrix = (axisOrientMatrix==1) .* axisScalesMatrix;
    for i=1:13
        indexMatrix = (scaleMatrix==i) .* axisMatrix;
        for j=1:spb.scales(i)
            J = J + mvMatrix(indexMatrix,0,j);
            J = J + mvMatrix(indexMatrix,0,-j);
        end
    end
    
    % orientation2 (22.5)
    scaleMatrix = (axisOrientMatrix==2) .* axisScalesMatrix;
    for i=1:13
        indexMatrix = (scaleMatrix==i) .* axisMatrix;
        for j=1:fix(spb.scales(i)*cos(22.5/180*pi))
            if mod(j,5)<=2
                J = J + mvMatrix(indexMatrix,1+fix(j/5),j);
                J = J + mvMatrix(indexMatrix,-1-fix(j/5),-j);
            else
                J = J + mvMatrix(indexMatrix,-2-fix(j/5),-j);
                J = J + mvMatrix(indexMatrix,2+fix(j/5),j);
            end
        end
    end
    
    
    % orientation3 (45)
    scaleMatrix = (axisOrientMatrix==3) .* axisScalesMatrix;
    for i=1:13
        indexMatrix = (scaleMatrix==i) .* axisMatrix;
        for j=1:fix(spb.scales(i)*sin(45/180*pi))
            J = J + mvMatrix(indexMatrix,j,j);
            J = J + mvMatrix(indexMatrix,-j,-j);
        end
    end    
    
    % orientation4 (67.5)
    scaleMatrix = (axisOrientMatrix==4) .* axisScalesMatrix;
    for i=1:13
        indexMatrix = (scaleMatrix==i) .* axisMatrix;
        for j=1:fix(spb.scales(i)*cos(22.5/180*pi))
            if mod(j,5)<=2
                J = J + mvMatrix(indexMatrix,j,1+fix(j/5));
                J = J + mvMatrix(indexMatrix,-j,-1-fix(j/5));
            else
                J = J + mvMatrix(indexMatrix,j,2+fix(j/5));
                J = J + mvMatrix(indexMatrix,-j,-2-fix(j/5));
            end
        end
    end   
    
    % orientation5 (90)
    scaleMatrix = (axisOrientMatrix==5) .* axisScalesMatrix;
    for i=1:13
        indexMatrix = (scaleMatrix==i) .* axisMatrix;
        for j=1:spb.scales(i)
            J = J + mvMatrix(indexMatrix,j,0);
            J = J + mvMatrix(indexMatrix,-j,0);
        end
    end   
    
    % orientation6 (112.5)
    scaleMatrix = (axisOrientMatrix==6) .* axisScalesMatrix;
    for i=1:13
        indexMatrix = (scaleMatrix==i) .* axisMatrix;
        for j=1:fix(spb.scales(i)*cos(22.5/180*pi))
            if mod(j,5)<=2
                J = J + mvMatrix(indexMatrix,j,-1-fix(j/5));
                J = J + mvMatrix(indexMatrix,-j,1+fix(j/5));
            else
                J = J + mvMatrix(indexMatrix,j,-2-fix(j/5));
                J = J + mvMatrix(indexMatrix,-j,2+fix(j/5));
            end
        end
    end   
    
    % orientation7 (135)
    scaleMatrix = (axisOrientMatrix==7) .* axisScalesMatrix;
    for i=1:13
        indexMatrix = (scaleMatrix==i) .* axisMatrix;
        for j=1:fix(spb.scales(i)*sin(45/180*pi))
            J = J + mvMatrix(indexMatrix,j,-j);
            J = J + mvMatrix(indexMatrix,-j,j);
        end
    end  
    
    % orientation8 (157.5)
    scaleMatrix = (axisOrientMatrix==8) .* axisScalesMatrix;
    for i=1:13
        indexMatrix = (scaleMatrix==i) .* axisMatrix;
        for j=1:fix(spb.scales(i)*cos(22.5/180*pi))
            if mod(j,5)<=2
                J = J + mvMatrix(indexMatrix,-1-fix(j/5),j);
                J = J + mvMatrix(indexMatrix,1+fix(j/5),-j);
            else
                J = J + mvMatrix(indexMatrix,2+fix(j/5),-j);
                J = J + mvMatrix(indexMatrix,-2-fix(j/5),j);
            end
        end
    end   
    J = J>0;
end

