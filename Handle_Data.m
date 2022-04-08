% Get all samples in order
A = current_state;
All_State = zeros(10, 100, 5, 50);
for k = 1:50
    for i = 1:5
        for j = 1:100
            All_State(:,j,i,k) = A(:,((k-1)*500)+((j-1)*5)+i);
        end
    end
end

% Draw DoF
figure(1);
set(gcf,'Renderer','OpenGL');
set(gcf, 'position', [500 500 600 500]);
axis([-1.2,1.2,-1.2,1.2]);hold on;

for k = 1:50
    for i = 1:5
        Draw_DOF(All_State(:,1:25:end,i,k),color(k,:));
    end
    fprintf('END_ITER: %d\n', k);
end