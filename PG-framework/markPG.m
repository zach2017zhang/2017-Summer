function m = markPG(ContourList)

for i=1:size(ContourList,2)
hold on;
figure(3),plot(ContourList{1,i}(:,2),ContourList{1,i}(:,1),'x');
end
m=1;
end