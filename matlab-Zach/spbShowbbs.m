function Sortedbbs = spbShowbbs(ContourList,bbs,I,spb) 
    
    numBoxes = size(bbs,1); % Get the number of boxes proposed
    
    % Replace Edgebox score with PGframework score
    scores = zeros(numBoxes,1);
    for i=1:numBoxes
       n = numGroupsInsideBox(ContourList,bbs(i,:)); % calculate n
       if n > 0
           scores(i) =   ... %PGScore(ContourList,bbs(i,:), I, n)+... 
                           axisScore(ContourList,bbs(i,:),spb,n); % Calculate PG score
                      
       end
    end
    bbs(:,end) = scores;
    Sortedbbs = sortrows(bbs,5); % Sort the matrix in terms of the score
    Sortedbbs = flipud(Sortedbbs);% flip, from large to small
    
    
    % Selectedbbs = Sortedbbs(numBoxes+1-m:numBoxes,5); % Extract the top m score
    % Normbbs = (Selectedbbs - min(Selectedbbs))/(max(Selectedbbs) - ...
    %     min(Selectedbbs)); % Normalize the selected score for drawBoxes function
    
    % figure(),im(I);
    % hold on;
    % title('axis bbs');
    
    % for i=1:num          
    %     drawBoxes(Sortedbbs(numBoxes+1-i,:)+[0 0 Sortedbbs(numBoxes+1-i,1) ...
    %    Sortedbbs(numBoxes+1-i,2) 0],'lineWidth',1,...% 'scores',Normbbs(m+1-i),...
    %    'color','red'); % Draw the boxes
    % end
  
end