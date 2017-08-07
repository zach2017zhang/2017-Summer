function m = markPG(ContourList,I)

figure(),im(I);
hold on;
for i=1:size(ContourList,2)
    plot(ContourList{1,i}(:,2),ContourList{1,i}(:,1),'x');
end
m=1;
end