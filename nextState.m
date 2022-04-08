function [xp, r] = nextState(x, a, target)
%   2 DOF Manipulator delta_time = 0.1s

bar_length =1;
%deTime = 0.1;
length = bar_length/10;
size_x = size(x);
%   how to calculate reward/cost
xp = x + a*(1);
xp(1,:)=min(max(xp(1,:),-pi/2),pi/2);
xp(2,:)=min(max(xp(2,:),-pi/2),pi/2);
xp(3,:)=min(max(xp(3,:),-pi/2),pi/2);
xp(4,:)=min(max(xp(4,:),-pi/2),pi/2);
xp(5,:)=min(max(xp(5,:),-pi/2),pi/2);
xp(6,:)=min(max(xp(6,:),-pi/2),pi/2);
xp(7,:)=min(max(xp(7,:),-pi/2),pi/2);
xp(8,:)=min(max(xp(8,:),-pi/2),pi/2);
xp(9,:)=min(max(xp(9,:),-pi/2),pi/2);
xp(10,:)=min(max(xp(10,:),-pi/2),pi/2);

end_point = zeros(2, size_x(2));
theta = cumsum(xp,1);
for i = 1:10
    end_point = end_point + [length*sin(theta(i,:));length*cos(theta(i,:))];
end
r = -1000* sum((end_point - target*ones(1,size_x(2))).^2,1);

return;
