function IOUScore = IOUScore(bbs,ContourList,spb,rect)

x = bbs(1);
y = bbs(2);
w = bbs(3);
h = bbs(4);

[pic,labelContour] = spbMaskReconstruct(spb,ContourList,bbs,rect);
% get the reconsructed picture
pic = pic>0;
unionPic = zeros(size(spb.orientMap,1),size(spb.orientMap,2));
for i=find(labelContour)
   [contourPic,~] = spbMaskReconstruct(spb,{ContourList{1,i}},bbs,rect);
   % reconstruct all the contours inside and add them up
   unionPic = unionPic + contourPic;   
end

unionPic = unionPic > 0;
unionPic(y:y+h,x:x+w) = 1;
unionArea = sum(unionPic(:));

interPic = pic; % find out the intersection part of box and contours
% exclude the part of contours outside the boox 
interPic(:,1:x)=0;
interPic(1:y,:)=0;
interPic(:,x+w:end)=0;
interPic(y+h:end,:)=0;
interArea = sum(interPic(:));
IOUScore = interArea/unionArea; % count the pixels to represent area
end