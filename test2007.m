

for i = 5:9963
    
    A = ['0' '0' '0' '0' '0' '0'];
    name = strcat(A(1:6-length(int2str(i))),int2str(i));
    path = '/h/42/zhan2212/Desktop/2007/VOCdevkit/VOC2007/JPEGImages/';
    filename = strcat(name,'.jpg');
    fullname = strcat(path,filename);
    if exist(fullname, 'file')
    
        I = imread(fullname);

        savePath = '/h/42/zhan2212/Desktop/2007/MilResult/';
        img = im2double(I);
        spb = spbMIL(img);
        save(strcat(savePath,name,'.mat'),'spb');
    end
    
end
%% 
i =1;
    A = ['0' '0' '0' '0' '0' '0'];
    name = strcat(A(1:6-length(int2str(i))),int2str(i));
    path = '/h/42/zhan2212/Desktop/2007/VOCdevkit/VOC2007/JPEGImages/';
    filename = strcat(name,'.jpg');
    fullname = strcat(path,filename);
    I = imread(fullname);

    savePath = '/h/42/zhan2212/Desktop/2007/MilResult/';
    img = im2double(I);
    spb = spbMIL(img);
    save(strcat(savePath,name,'.mat'),'spb');
    