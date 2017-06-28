function IOUScore = boxScore(bbs,ContourList,spb,rect)

x = bbs(1);
y = bbs(2);
w = bbs(3);
h = bbs(4);



% 1/3. precalculate the mask % 2. find contour groups inside

[pic,labelContour] = spbMaskReconstruct(spb,ContourList,bbs,rect);
pic = pic>0;
unionPic = zeros(size(spb.orientMap,1),size(spb.orientMap,2));
for i=find(labelContour)
   [contourPic,~] = spbMaskReconstruct(spb,{ContourList{1,i}},bbs,rect);
   unionPic = unionPic + contourPic;   
end

unionPic = unionPic > 0;
unionPic(y:y+h,x:x+w) = 1;
unionArea = sum(unionPic(:));

interPic = pic;
interPic(:,1:x)=0;
interPic(1:y,:)=0;
interPic(:,x+w:end)=0;
interPic(y+h:end,:)=0;
interArea = sum(interPic(:));
IOUScore = interArea/unionArea;