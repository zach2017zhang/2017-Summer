function rect = getMask(spb)

    rect =cell(13,8); % rect{s,o}
    Y = size(spb.orientMap,1);
    X = size(spb.orientMap,2);
    Ycenter = int16(Y/2);
    Xcenter = int16(X/2);
    
    % orientation1 (0)
    for i=1:13
       
        spbMask = zeros(Y,X); 
        scales = spb.scales(i);
        if (Ycenter>int16(3/2*scales))&&(Xcenter>int16(3/2*scales))
        spbMask(Ycenter-int16(scales):Ycenter+int16(scales),Xcenter-int16(3/2*scales):Xcenter+int16(3/2*scales))=1;
        spbMask(Ycenter,Xcenter) = 1;
        
        end
        rect{i,1} = spbMask>0;
        
    end
    
    % orientation1 (22.5)
     for i=1:13
        spbMask = zeros(Y,X);    
        scales = spb.scales(i); %spb.scales(i);
        if (Ycenter>int16(3/2*scales))&&(Xcenter>int16(3/2*scales))
        spbMask(Ycenter-int16(scales):Ycenter+int16(scales),Xcenter-int16(3/2*scales):Xcenter+int16(3/2*scales))=1;
        spbMask(Ycenter,Xcenter) = 2;
        
        spbMask = imrotate(spbMask,22.5,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,Xcenter-b,Ycenter-a);
        % spbMask(a,b) = 1;
        end
        
        
        rect{i,2} = spbMask>0;
     end  
    
     % orientation1 (45)
     for i=1:13        
        spbMask = zeros(Y,X); 
        scales = spb.scales(i); %spb.scales(i);
        if (Ycenter>int16(3/2*scales))&&(Xcenter>int16(3/2*scales))
        spbMask(Ycenter-int16(scales):Ycenter+int16(scales),Xcenter-int16(3/2*scales):Xcenter+int16(3/2*scales))=1;
        spbMask(Ycenter,Xcenter) = 2;
        
        spbMask = imrotate(spbMask,45,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,Xcenter-b,Ycenter-a);
        
        end
        rect{i,3} = spbMask>0;
     end  
     
     % orientation1 (67.5)
     for i=1:13
        spbMask = zeros(Y,X);      
        scales = spb.scales(i);
        if (Ycenter>int16(3/2*scales))&&(Xcenter>int16(3/2*scales))
        spbMask(Ycenter-int16(scales):Ycenter+int16(scales),Xcenter-int16(3/2*scales):Xcenter+int16(3/2*scales))=1;
        spbMask(Ycenter,Xcenter) = 2;
        
        spbMask = imrotate(spbMask,67.5,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,Xcenter-b,Ycenter-a);
        spbMask(a,b) = 1;
        end
        rect{i,4} = spbMask>0;
    end 
    
     % orientation1 (90)
     for i=1:13
        spbMask = zeros(Y,X);
        scales = spb.scales(i);
        if (Ycenter>int16(3/2*scales))&&(Xcenter>int16(3/2*scales))
        spbMask(Ycenter-int16(3/2*scales):Ycenter+int16(3/2*scales),Xcenter-int16(scales):Xcenter+int16(scales))=1;
        spbMask(Ycenter,Xcenter) = 1;
        
        
        end
        rect{i,5} = spbMask>0;
     end 
    
     
     % orientation1 (115.5)
     for i=1:13
        spbMask = zeros(Y,X);       
        scales = spb.scales(i);
        if (Ycenter>int16(3/2*scales))&&(Xcenter>int16(3/2*scales))
        spbMask(Ycenter-int16(3/2*scales):Ycenter+int16(3/2*scales),Xcenter-int16(scales):Xcenter+int16(scales))=1;
        spbMask(Ycenter,Xcenter) = 2;
        
        spbMask = imrotate(spbMask,22.5,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,Xcenter-b,Ycenter-a);
        
        end
        rect{i,6} = spbMask>0;
     end 
    
     % orientation1 (135)
     for i=1:13
        spbMask = zeros(Y,X);       
        scales = spb.scales(i);
        if (Ycenter>int16(3/2*scales))&&(Xcenter>int16(3/2*scales))
        spbMask(Ycenter-int16(3/2*scales):Ycenter+int16(3/2*scales),Xcenter-int16(scales):Xcenter+int16(scales))=1;
        spbMask(Ycenter,Xcenter) = 2;
        
        spbMask = imrotate(spbMask,45,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,Xcenter-b,Ycenter-a);
        
        end
        rect{i,7} = spbMask>0;
     end 
    
     % orientation1 (157.5)
     for i=1:13
        spbMask = zeros(Y,X);      
        scales = spb.scales(i);
        if (Ycenter>int16(3/2*scales))&&(Xcenter>int16(3/2*scales))
        spbMask(Ycenter-int16(3/2*scales):Ycenter+int16(3/2*scales),Xcenter-int16(scales):Xcenter+int16(scales))=1;
        spbMask(Ycenter,Xcenter) = 2;
        
        spbMask = imrotate(spbMask,67.5,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,Xcenter-b,Ycenter-a);
        
        end
        rect{i,8} = spbMask>0;
    end 
        
    
    
    
    
    
 
    
    
end