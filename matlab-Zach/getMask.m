function rect = getMask(spb)

    rect ={}; % rect{s,o}
    Y = size(spb.orientMap,1);
    X = size(spb.orientMap,2);
    
    % orientation1 (0)
    for i=1:13
        spbMask = zeros(Y,X);     
        scales = spb.scales(i);
        spbMask(100-int8(scales):100+int8(scales),100-int8(3/2*scales):100+int8(3/2*scales))=1;
        spbMask(100,100) = 1;
        
        
        rect{i,1} = spbMask;
        
    end
    
    % orientation1 (22.5)
     for i=1:13
        spbMask = zeros(Y,X);     
        scales = spb.scales(i); %spb.scales(i);
        spbMask(100-int8(scales):100+int8(scales),100-int8(3/2*scales):100+int8(3/2*scales))=1;
        spbMask(100,100) = 2;
        
        spbMask = imrotate(spbMask,22.5,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,100-b,100-a);
        spbMask(100,100) = 1;
        
        
        rect{i,2} = spbMask;
     end  
    
     % orientation1 (45)
     for i=1:13
        spbMask = zeros(Y,X);       
        scales = spb.scales(i); %spb.scales(i);
        spbMask(100-int8(scales):100+int8(scales),100-int8(3/2*scales):100+int8(3/2*scales))=1;
        spbMask(100,100) = 2;
        
        spbMask = imrotate(spbMask,45,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,100-b,100-a);
        spbMask(100,100) = 1;
        
        
        rect{i,3} = spbMask>0;
     end  
     
     % orientation1 (67.5)
     for i=1:13
        spbMask = zeros(Y,X);      
        scales = spb.scales(i);
        spbMask(100-int8(scales):100+int8(scales),100-int8(3/2*scales):100+int8(3/2*scales))=1;
        spbMask(100,100) = 2;
        
        spbMask = imrotate(spbMask,67.5,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,100-b,100-a);
        spbMask(100,100) = 1;
        
        rect{i,4} = spbMask>0;
    end 
    
     % orientation1 (90)
     for i=1:13
        spbMask = zeros(Y,X);      
        scales = spb.scales(i);
        spbMask(100-int8(3/2*scales):100+int8(3/2*scales),100-int8(scales):100+int8(scales))=1;
        spbMask(100,100) = 1;
        
        
        
        rect{i,5} = spbMask>0;
     end 
    
     
     % orientation1 (115.5)
     for i=1:13
        spbMask = zeros(Y,X);       
        scales = spb.scales(i);
        spbMask(100-int8(3/2*scales):100+int8(3/2*scales),100-int8(scales):100+int8(scales))=1;
        spbMask(100,100) = 2;
        
        spbMask = imrotate(spbMask,22.5,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,100-b,100-a);
        spbMask(100,100) = 1;
        
        
        rect{i,6} = spbMask>0;
     end 
    
     % orientation1 (135)
     for i=1:13
        spbMask = zeros(Y,X);       
        scales = spb.scales(i);
        spbMask(100-int8(3/2*scales):100+int8(3/2*scales),100-int8(scales):100+int8(scales))=1;
        spbMask(100,100) = 2;
        
        spbMask = imrotate(spbMask,45,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,100-b,100-a);
        spbMask(100,100) = 1;
        
        
        rect{i,7} = spbMask>0;
     end 
    
     % orientation1 (157.5)
     for i=1:13
        spbMask = zeros(Y,X);      
        scales = spb.scales(i);
        spbMask(100-int8(3/2*scales):100+int8(3/2*scales),100-int8(scales):100+int8(scales))=1;
        spbMask(100,100) = 2;
        
        spbMask = imrotate(spbMask,67.5,'bilinear','crop');
        [a b]= find(spbMask==max(spbMask(:)));
        spbMask = mvMatrix(spbMask,100-b,100-a);
        spbMask(100,100) = 1;
        
        
        rect{i,8} = spbMask>0;
    end 
        
    
    
    
    
    
 
    
    
end