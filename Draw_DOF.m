function [] = Draw_DOF(state_, color_line)
[Num_dim, Num_state] = size(state_);
length = 1/Num_dim;
Target = [0.6830; 0];
for i = 1:Num_state
    %figure(1);
    Position = zeros(Num_dim+1,2);
    %plot(Position(1,1),Position(1,2),'color', color_point,'marker','.','markersize',2.5);hold on;
    for j = 2:(Num_dim+1)
        Position(j,:) = Position(j-1,:) + [length*sin(state_(j-1,i)), length*cos(state_(j-1,i))];
        %plot(Position(j,1),Position(j,2),'color', color_point,'marker','.','markersize',2.5);hold on;
        line([Position(j-1,1);Position(j,1)],[Position(j-1,2);Position(j,2)],'color',color_line,'linestyle','-','linewidth',0.5);hold on;
    end
    %plot(Position(:,1),Position(:,2),'color', color_point,'marker','.','markersize',2.5);hold on;
end

%drawnow;
end

