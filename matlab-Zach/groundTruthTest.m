function Sortedbbs = groundTruthTest(bbs,I,E) 
    
    numBoxes = size(bbs,1); % Get the number of boxes proposed
    
    objectAreaCell={};
    %precalculate the full area for each object
    Object = unique(E);
    numObject = size(Object);
    for i=1:numObject
       m = Object(i);
       if (~isequal(m,0)) &&(~isequal(m,255))
           objectAreaCell{m} = size(find(E==m),1);
       end        
    end
    
    % Replace Edgebox score with PGframework score
    scores = zeros(numBoxes,1);
    for i=1:numBoxes
       scores(i) =   groundTruthScore(bbs(i,:),E,objectAreaCell); % Calculate PG score
    end
    bbs(:,end) = scores;
    Sortedbbs = sortrows(bbs,5); % Sort the matrix in terms of the score
    Sortedbbs = flipud(Sortedbbs);% flip, from large to small
 
    
     %figure(),im(I);
     %hold on;
     %title('axis bbs');
    
     %for i=1:num          
     %    drawBoxes(Sortedbbs(numBoxes+1-i,:)+[0 0 Sortedbbs(numBoxes+1-i,1) ...
     %   Sortedbbs(numBoxes+1-i,2) 0],'lineWidth',1,...% 'scores',Normbbs(m+1-i),...
     %   'color','red'); % Draw the boxes
     %end
  
end

function score = groundTruthScore(sbbs,E,objectAreaCell)
    interPic = E;
    unionPic = double(zeros(size(E,1),size(E,2)));
    m = sbbs(1);
    k = sbbs(2);
    w = sbbs(3);
    h = sbbs(4);
    
   
    interPic(:,1:m)=0;
    interPic(1:k,:)=0;
    interPic(:,m+w:end)=0;
    interPic(k+h:end,:)=0;

    interArea = 0;
    unionArea = 0;
    n = 0;
    
    Object = unique(interPic);
    numObject = size(Object);
    
    
    
    for i=1:numObject
        ob=Object(i);
        if (~isequal(ob,0))&&(~isequal(ob,255))
            area = size(find(interPic==ob),1);
            if area >= 0.05 *(w*h) % 5% threshold
                n = n+1;
                interArea = interArea + area;
                % unionArea = unionArea + objectAreaCell{m};
                unionPic = unionPic + double(E==ob).*double(E);
            end
            
        end
    end
    
    unionPic(k+1:k+h,m+1:m+w)= 1;
    unionArea = size(find(unionPic),1);
    
    IOU = interArea/unionArea;
    
    if n~=0
        score = IOU*(w*h)/unionArea;% interArea/(w*h)^2/n;%;IOU/n
    else
        score =0;
    end
end