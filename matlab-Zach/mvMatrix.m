function J = mvMatrix(X,dx,dy)
    [h w]= size(X);
    
    XaddMatrix = zeros(h,abs(dx));
    if dx>0
        J = [XaddMatrix X(:,1:w-dx)];
    else
        dx = abs(dx);
        J = [X(:,dx+1:w) XaddMatrix];
    end
    size(J);
    
    YaddMatrix = zeros(abs(dy),w);
    if dy>0
        J = [YaddMatrix;J(1:h-dy,:)];
    else
        dy = abs(dy);
        J = [J(dy+1:h,:);YaddMatrix];
    end
        

end