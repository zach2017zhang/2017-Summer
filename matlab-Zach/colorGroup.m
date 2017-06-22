function newContourList =  colorGroup(ContourList,I)
 numGroups = size(ContourList,2);
 newContourList = {};
 
 colorList = zeros(numGroups,3); % numGroups * RGB
 
 for i=1:numGroups
     numPixels = size(ContourList{1,i},1);
     R = double(0);
     G = double(0);
     B = double(0);
     
     for j=1:numPixels
         R = R + double(I(ContourList{1,i}(j,1),ContourList{1,i}(j,2),1));
         G = G + double(I(ContourList{1,i}(j,1),ContourList{1,i}(j,2),2));
         B = B + double(I(ContourList{1,i}(j,1),ContourList{1,i}(j,2),3));
         %try   
         %B = B + I(ContourList{1,i}(j,2),ContourList{1,i}(j,1),3)+...
         %        I(ContourList{1,i}(j,2)-1,ContourList{1,i}(j,1),3)+...
         %       I(ContourList{1,i}(j,2)+1,ContourList{1,i}(j,1),3)+...
         %       I(ContourList{1,i}(j,2),ContourList{1,i}(j,1)-1,3)+...
         %       I(ContourList{1,i}(j,2),ContourList{1,i}(j,1)+1,3)+...
         %       I(ContourList{1,i}(j,2)-1,ContourList{1,i}(j,1)-1,3)+...
         %       I(ContourList{1,i}(j,2)-1,ContourList{1,i}(j,1)+1,3)+...
         %       I(ContourList{1,i}(j,2)+1,ContourList{1,i}(j,1)-1,3)+...
         %       I(ContourList{1,i}(j,2)+1,ContourList{1,i}(j,1)+1,3);
         %catch
         %    B = B + int32(I(ContourList{1,i}(j,1),ContourList{1,i}(j,2),3));
         %end
         
     end
     
     colorList(i,1) = double(R/numPixels); % avg value of R
     colorList(i,2) = double(G/numPixels); % avg value of G
     colorList(i,3) = double(B/numPixels); % avg value of B
     % if i==1
     %    fprintf('R is %.6f \n G is %.6f \n B is %.6f \n',colorList(i,1),colorList(i,2),colorList(i,3));
     %    fprintf('R is %.6f \n G is %.6f \n B is %.6f \n numPixels is %.6f\n',R,G,B,numPixels);
     % end
 end
 
 % Compute Difference
 diffMatrix = zeros(numGroups*numGroups,3);
 flag = 1;
 for i=1:numGroups
     for j=1:numGroups
         diffMatrix((i-1)*numGroups+j,:) = [i j double(sqrt((colorList(i,1)-colorList(j,1))^2 + ...
                                (colorList(i,2)-colorList(j,2))^2 +...
                                (colorList(i,3)-colorList(j,3))^2))];
                            
         % if diffMatrix(i,j) < 0.1 * sqrt((255)^2+(255)^2+(255)^2)
         %    newContourList = {newContourList{:} vertcat(ContourList{1,i},ContourList{1,j})};
         % else
         %    newContourList = {newContourList{:} ContourList{1,i}};
         % end
     end
 end
 
 % diffMatrix = diffMatrix < 0.01 * sqrt((255)^2+(255)^2+(255)^2);
 % excludeIndex = zeros(numGroups);
 
 flagList = zeros(numGroups,1);
 flagList(1)=1;
 for i=1:numGroups
     
       %%%%%%%%%%%%%%%%%%%%%%%%%%%
         % mergeList = ContourList{1,i};
     for j = i+1:numGroups
         
         if flagList(j)==0
             if diffMatrix((i-1)*numGroups+j,3) <= 0.02 * sqrt((255)^2+(255)^2+(255)^2);
                 flagList(j)=i;
             else
                 flagList(j)=j;
             end
         else
             if diffMatrix((i-1)*numGroups+j,3) <= 0.02 * sqrt((255)^2+(255)^2+(255)^2);
                 flagList(j)=flagList(i);
             end
         end         
     end
 end
 
 uniqueFlagList = unique(flagList);
 for i= 1:size(uniqueFlagList)
     index = flagList==uniqueFlagList(i);
     newContourList = {newContourList{:} vertcat(ContourList{1,index})};
 end
end