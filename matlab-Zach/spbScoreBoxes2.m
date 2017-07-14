function Sortedbbs = spbScoreBoxes2(ContourList,bbs,I,spb,num)
%cut the axes outside!!!!!!!!!!

Ysize = size(I,1);
Xsize = size(I,2);
picCenterY = int16(Ysize/2);
picCenterX = int16(Xsize/2);

numBoxes = size(bbs,1); % Get the number of boxes proposed
scores = zeros(numBoxes,1);

rect = getMask(spb);

maskReCell = cell(Ysize,Xsize);
for i=1:size(ContourList,2)
    numPixels = size(ContourList{1,i},1);    
    for j=1:numPixels
        X = ContourList{1,i}(j,2);
        Y = ContourList{1,i}(j,1);
        mask = rect{spb.scalesMap(Y,X),spb.orientMap(Y,X)};
        maskReCell{Y,X} = mvMatrix(mask,X-picCenterX,Y-picCenterY);        
    end
end

% rescore bbs
for i=1:numBoxes
    scores(i) = boxScore(bbs(i,:),ContourList,maskReCell,Ysize,Xsize);
end
bbs(:,end) = scores;
Sortedbbs = sortrows(bbs,5); % Sort the matrix in terms of the score

    
%plot the result    
figure(),im(I);
hold on;
title('axis bbs');

for i=1:num           
  drawBoxes(Sortedbbs(numBoxes+1-i,:)+[0 0 Sortedbbs(numBoxes+1-i,1) ...
      Sortedbbs(numBoxes+1-i,2) 0],'lineWidth',1,...% 'scores',Normbbs(m+1-i),...
      'color','red'); % Draw the boxes

end
end


% -------------------------------------------------------------------------
function Score = boxScore(sbbs,ContourList,maskReCell,Ysize,Xsize)

x = sbbs(1);
y = sbbs(2);
w = sbbs(3);
h = sbbs(4);


unionPic = zeros(Ysize,Xsize);

numAxisInside = 0;

for i=1:size(ContourList,2)
    inside = 0;
    numPixels = size(ContourList{1,i},1);
    
    for j=1:numPixels
        X = ContourList{1,i}(j,2);
        Y = ContourList{1,i}(j,1);

        if (x+w>X)&&(X>x)&&(h+y>Y)&&(Y>y)
            unionPic = unionPic + maskReCell(Y,X);   
            inside=1; 
        end
        
    end
   
    numAxisInside =numAxisInside+inside;
end

interPic = unionPic;
interPic(1:y,:)=0; 
interPic(:,1:x)=0;
interPic(:,x+w:end)=0;
interPic(y+h:end,:)=0;

unionPic = unionPic > 0;
unionPic(y:y+h,x:x+w) = 1;
unionArea = sum(unionPic(:));% count the pixels to represent area

 


interArea = sum(interPic(:));% count the pixels to represent area
IOUScore = interArea/unionArea;


if numAxisInside~=0
    Score = IOUScore/numAxisInside;%/n*interArea/(w*h)^2;
else
    Score = 0;
    
end

end