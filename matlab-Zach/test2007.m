

for i = 4863:9963
    
    A = ['0' '0' '0' '0' '0' '0'];
    name = strcat(A(1:6-length(int2str(i))),int2str(i));
    path = '/h/42/zhan2212/Desktop/2017-Summer-master/EdgeDetector/boxes/VOCdevkit/VOC2007/JPEGImages/';
    filename = strcat(name,'.jpg');
    fullname = strcat(path,filename);
    
    
    savePath = '/h/42/zhan2212/Desktop/2007/MilResult/';
    filename2 = strcat(name,'.mat');
    fullname2 = strcat(savePath,filename2);
    
    if (exist(fullname, 'file')) && (~exist(fullname2,'file'))
        fprintf('%d\n',i);
    
        I = imread(fullname);

        
        img = im2double(I);
        spb = spbMIL(img);
        save(strcat(savePath,name,'.mat'),'spb');
    end
    
end
%% 
i =5;
    A = ['0' '0' '0' '0' '0' '0'];
    name = strcat(A(1:6-length(int2str(i))),int2str(i));
    path = '/h/42/zhan2212/Desktop/2017-Summer-master/EdgeDetector/boxes/VOCdevkit/VOC2007/JPEGImages/';
    filename = strcat(name,'.jpg');
    fullname = strcat(path,filename);
    
    
    savePath = '/h/42/zhan2212/Desktop/2007/MilResult/';
    filename2 = strcat(name,'.mat');
    fullname2 = strcat(savePath,filename2);
    
    if (exist(fullname, 'file')) && (~exist(fullname2,'file'))
    
        I = imread(fullname);

        
        img = im2double(I);
        spb = spbMIL(img);
        save(strcat(savePath,name,'.mat'),'spb');
    end
    