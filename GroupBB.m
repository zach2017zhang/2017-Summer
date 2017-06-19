function ContourList = GroupBB(labels, SegList)

ContourList ={};
Nlabels = [];

for k=1:size(labels,1)
    [tf, n] = ismember(labels(k),Nlabels);
    if(~tf)
        Nlabels = [Nlabels labels(k)];
        ContourList ={ContourList{:} SegList{1,k}};
    else
        ContourList{1,n} = [ContourList{1,n};SegList{1,k}];
    end
end

end