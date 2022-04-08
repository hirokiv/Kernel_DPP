function [error]=GetErr( W , CSt)
%Target = [1; 0];
%Target = [0.866; 0.5];
%Target = [0.433; 0.75];
%Target = [-0.866; 0.5];
%Target = [-0.433; 0.75];
%Target = [0.6830; 0.6830];
%Target = [-0.6830; 0.6830];
%Target = [0.183;0.683];
%Target = [0;0.7];
Target = [0.6830; 0];
current_state = [0;0;0;0;0;0;0;0;0;0];
%current_state =  [(2*pi/2*rand(2,1) - pi/2*ones(2,1))];

for i = 1:50
    action = calculate_policy_greedy(current_state, W , CSt);
    [next_state, reward] = nextState( current_state, action, Target); 
    current_state = next_state;
end

error = reward;


return;
