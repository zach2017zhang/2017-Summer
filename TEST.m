gt=[122 248 92 65; 193 82 71 53; 410 237 101 81; 204 160 114 95; ...
  9 185 86 90; 389 93 120 117; 253 103 107 57; 81 140 91 63];
if(0), 
    gt='Please select an object box.'; disp(gt); figure(1); imshow(I);
    title(gt); [~,gt]=imRectRot('rotate',0); gt=gt.getPos(); 
end
gt(:,5)=0; [gtRes,dtRes]=bbGt('evalRes',gt,double(bbs),.7);
figure(1); bbGt('showRes',I,gtRes,dtRes(dtRes(:,6)==1,:));
title('green=matched gt  red=missed gt  dashed-green=matched detect');
%% 
gt(:,5)=0; [gtRes,dtRes]=bbGt('evalRes',gt,double(bbs),.6);
figure; bbGt('showRes',I,gtRes,dtRes(dtRes(:,6)==1,:));

%% 

gt=[122 248 92 65; 193 82 71 53; 410 237 101 81; 204 160 114 95; ...
  9 185 86 90; 389 93 120 117; 253 103 107 57; 700 100 730 80]; % 0.2047


gt(:,5)=0; [gtRes,dtRes]=bbGt('evalRes',gt,double(bbs),.7);
figure; bbGt('showRes',I,gtRes,dtRes(dtRes(:,6)==1,:));

%% 
