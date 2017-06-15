function n = Getn(ContourList,sbbs)
m = sbbs(1);
k = sbbs(2);
w = sbbs(3);
h = sbbs(4);
[~, a] = size(ContourList);
n = 0;

for i=1:a 
    XArray = ContourList{1,i}(:,2);
    YArray = ContourList{1,i}(:,1);
    Xmax = max(XArray);
    Xmin = min(XArray);
    Ymax = max(YArray);
    Ymin = min(YArray);
    if m<=Xmin & Xmax<=m+w & k<=Ymin & Ymax<=k+h
        n = n+1;
    end
end

end