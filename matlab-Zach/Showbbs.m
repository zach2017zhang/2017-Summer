function Sortedbbs = Showbbs(ContourList,bbs,I,m) %,m,p,spb) 
    
    numBoxes = size(bbs,1); % Get the number of boxes proposed
    
    % Replace Edgebox score with PGframework score
    scores = zeros(numBoxes,1);
    for i=1:numBoxes
       n = numGroupsInsideBox(ContourList,bbs(i,:)); % calculate n
       if n > 0
           scores(i) =  PGScore(ContourList,bbs(i,:), I, n); 
                         % axisScore(spb,bbs(i,:),I,n); % Calculate PG score
       end
    end
    bbs(:,end) = scores;
    Sortedbbs = sortrows(bbs,5); % Sort the matrix in terms of the score
    
    
    % Selectedbbs = Sortedbbs(numBoxes+1-m:numBoxes,5); % Extract the top m score
    % Normbbs = (Selectedbbs - min(Selectedbbs))/(max(Selectedbbs) - ...
    %     min(Selectedbbs)); % Normalize the selected score for drawBoxes function
    
    figure(6),im(I);
    title('Zach PG bbs');
    hold on;
    
    for i=1:m           
      figure(6),drawBoxes(Sortedbbs(numBoxes+1-i,:)+[0 0 Sortedbbs(numBoxes+1-i,1) ...
          Sortedbbs(numBoxes+1-i,2) 0],'lineWidth',1,...% 'scores',Normbbs(m+1-i),...
          'color','red'); % Draw the boxes
     end
  
end