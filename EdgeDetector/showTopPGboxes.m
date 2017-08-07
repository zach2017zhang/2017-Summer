function bbs = showTopPGboxes(bbs,I,m)
    
    numBoxes = size(bbs,1);
    figure(7),im(I);
    hold on;
    title('paper PG bbs');
    
    for i=1:m           
     figure(7),drawBoxes(bbs(numBoxes+1-i,:)+[0 0 bbs(numBoxes+1-i,1) ...
          bbs(numBoxes+1-i,2) 0],'lineWidth',1,...% 'scores',Normbbs(m+1-i),...
          'color','red'); % Draw the boxes
    end
    
    
end