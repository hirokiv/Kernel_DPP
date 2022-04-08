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
%Target = [0.6667; 0.5773];
%Target = [0.716507; 0.125001];
%Target = [0.676      15; 0.2752];
TimeLength = 50;
bar_length =1;
length = bar_length/10;

Initial_state = [0;0;0;0;0;0;0;0;0;0];
CSt = RCCSt{end};
%   initialize figure
figure();
set(gcf, 'position', [500 500 600 500]);
axis([-1.2,1.2,-1.2,1.2]);hold on;
set(gcf,'DoubleBuffer','on');

P1 = [ 0; 0 ];
P2 = [length*sin(0);length*cos(0)];
P3 = P2 + [length*sin(0);length*cos(0)];
P4 = P3 + [length*sin(0);length*cos(0)];
P5 = P4 + [length*sin(0);length*cos(0)];
P6 = P5 + [length*sin(0);length*cos(0)];
P7 = P6 + [length*sin(0);length*cos(0)];
P8 = P7 + [length*sin(0);length*cos(0)];
P9 = P8 + [length*sin(0);length*cos(0)];
P10 = P9 + [length*sin(0);length*cos(0)];
P11 = P10 + [length*sin(0);length*cos(0)];

Point_T =  plot(Target(1),Target(2),'color', 'g','marker','.','markersize',30,'erasemode','normal');hold on;


Line_1 = line([P1(1);P2(1)],[P1(2);P2(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;
Line_2 = line([P2(1);P3(1)],[P2(2);P3(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;
Line_3 = line([P3(1);P4(1)],[P3(2);P4(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;
Line_4 = line([P4(1);P5(1)],[P4(2);P5(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;
Line_5 = line([P5(1);P6(1)],[P5(2);P6(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;
Line_6 = line([P6(1);P7(1)],[P6(2);P7(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;
Line_7 = line([P7(1);P8(1)],[P7(2);P8(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;
Line_8 = line([P8(1);P9(1)],[P8(2);P9(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;
Line_9 = line([P9(1);P10(1)],[P9(2);P10(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;
Line_10 = line([P10(1);P11(1)],[P10(2);P11(2)],'color','r','linestyle','-','linewidth',2,'erasemode','normal');hold on;

Point_1 =  plot(P1(1),P1(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_2 =  plot(P2(1),P2(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_3 =  plot(P3(1),P3(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_4 =  plot(P4(1),P4(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_5 =  plot(P5(1),P5(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_6 =  plot(P6(1),P6(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_7 =  plot(P7(1),P7(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_8 =  plot(P8(1),P8(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_9 =  plot(P9(1),P9(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_10 =  plot(P10(1),P10(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;
Point_11 =  plot(P11(1),P11(2),'color', 'b','marker','.','markersize',20,'erasemode','normal');hold on;


xp = Initial_state;

for i = 1:TimeLength
    action = calculate_policy_greedy( xp, CSt.Weights , CSt);
    xp = xp + action;
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
    
    end_point = zeros(2, 1);
    theta = cumsum(xp,1);
    
    P1 = [ 0; 0 ];
    P2 = P1 + [length*sin(theta(1,:));length*cos(theta(1,:))];
    P3 = P2 + [length*sin(theta(2,:));length*cos(theta(2,:))];
    P4 = P3 + [length*sin(theta(3,:));length*cos(theta(3,:))];
    P5 = P4 + [length*sin(theta(4,:));length*cos(theta(4,:))];
    P6 = P5 + [length*sin(theta(5,:));length*cos(theta(5,:))];
    P7 = P6 + [length*sin(theta(6,:));length*cos(theta(6,:))];
    P8 = P7 + [length*sin(theta(7,:));length*cos(theta(7,:))];
    P9 = P8 + [length*sin(theta(8,:));length*cos(theta(8,:))];
    P10 = P9 + [length*sin(theta(9,:));length*cos(theta(9,:))];
    P11 = P10 + [length*sin(theta(10,:));length*cos(theta(10,:))];
    
    set(Line_1,'xdata',[P1(1);P2(1)],'ydata',[P1(2);P2(2)]);
    set(Line_2,'xdata',[P2(1);P3(1)],'ydata',[P2(2);P3(2)]);
    set(Line_3,'xdata',[P3(1);P4(1)],'ydata',[P3(2);P4(2)]);
    set(Line_4,'xdata',[P4(1);P5(1)],'ydata',[P4(2);P5(2)]);
    set(Line_5,'xdata',[P5(1);P6(1)],'ydata',[P5(2);P6(2)]);
    set(Line_6,'xdata',[P6(1);P7(1)],'ydata',[P6(2);P7(2)]);
    set(Line_7,'xdata',[P7(1);P8(1)],'ydata',[P7(2);P8(2)]);
    set(Line_8,'xdata',[P8(1);P9(1)],'ydata',[P8(2);P9(2)]);
    set(Line_9,'xdata',[P9(1);P10(1)],'ydata',[P9(2);P10(2)]);
    set(Line_10,'xdata',[P10(1);P11(1)],'ydata',[P10(2);P11(2)]);
    
    set(Point_1,'xdata',P1(1),'ydata',P1(2));
    set(Point_2,'xdata',P2(1),'ydata',P2(2));
    set(Point_3,'xdata',P3(1),'ydata',P3(2));
    set(Point_4,'xdata',P4(1),'ydata',P4(2));
    set(Point_5,'xdata',P5(1),'ydata',P5(2));
    set(Point_6,'xdata',P6(1),'ydata',P6(2));
    set(Point_7,'xdata',P7(1),'ydata',P7(2));
    set(Point_8,'xdata',P8(1),'ydata',P8(2));
    set(Point_9,'xdata',P9(1),'ydata',P9(2));
    set(Point_10,'xdata',P10(1),'ydata',P10(2));
    set(Point_11,'xdata',P11(1),'ydata',P11(2));
    

    drawnow;



    hold on;
    pause(0.025);
    %xp = next_state;
end



































