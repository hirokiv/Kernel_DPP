%   This is the main script of Kernel DPP_TD algorithm for 10 DOF
%   Manipulator Reaching for Neural Networks Paper
%   Ver 0.5 by Y.D. CUI, ISC lab, NAIST, Japan 2016/9/4
%   clear dbstop if error
clc;
clear all;
%profile on
%   random seed
ctime = datestr(now, 30);
tseed = str2num(ctime((end - 5) : end)) ;
rand('seed', tseed) ;
%   global structure
global CSt;
%   sample number
sample_num = 100;
%   Initialization
alpha     =   0.01;
eta       =   0.015;
gamma     =   0.95;
NUM_SAMPLES   =   5;
NUM_LENGTH = sample_num;
sample_iteration = NUM_SAMPLES*NUM_LENGTH;

StateDim= 10; %   state's dim 4 Dim
UDim = 10;    %   control's dim 1 Dim: 4 Torque
USz = 5;    %   control's size, 3 discrete actions

%   number of experiments and iterations
NUM_EXP = 1;
NUM_ITERATION = 5e1;

%   the range of state and control
MinU = -5*0.0175*ones(UDim,1);
MaxU = 5*0.0175*ones(UDim,1);
% MinU = -0.5*ones(UDim,1);
% MaxU = 0.5*ones(UDim,1);

j = 0;
U_=zeros(10,41);
for i = 1:10
    j = j+1;
    U_(j,i)= -1*0.0175;
end
j=0;
for i = 11:20
    j = j+1;
    U_(j,i)= 1*0.0175;
    
end
j=0;
for i = 21:30
    j = j+1;
    U_(j,i)= -5*0.0175;
end
j=0;
for i = 31:40
    j = j+1;
    U_(j,i)= 5*0.0175;
end

CSt.StDim       = StateDim;
CSt.BFs         = 0;
CSt.Weights     = [];
CSt.gamma       = gamma;
CSt.eta         = eta;
CSt.BMeanMat    = [];
CSt.UTable      = U_;
CSt.nsamples    =NUM_SAMPLES;
CSt.length      =NUM_LENGTH;
CSt.alpha       =alpha;
CSt.WMax        =5e20;

RCWeights = {};
RCCSt = {};
%   something for training & data writing
error=  zeros(NUM_EXP,NUM_ITERATION);

sub_CS = zeros(StateDim, NUM_SAMPLES, NUM_LENGTH);
sub_NS = zeros(StateDim, NUM_SAMPLES, NUM_LENGTH);
sub_R = zeros(1, NUM_SAMPLES, NUM_LENGTH);
sub_A = zeros(UDim, NUM_SAMPLES, NUM_LENGTH);

error=  zeros(NUM_EXP,NUM_ITERATION);
% Exp_Target
Target = [0.6830; 0];

for index_exp = 1:NUM_EXP
    current_state =zeros(StateDim,NUM_SAMPLES * NUM_LENGTH*NUM_ITERATION);
    next_state =zeros(StateDim,NUM_SAMPLES * NUM_LENGTH*NUM_ITERATION);
    reward =zeros(1,NUM_SAMPLES * NUM_LENGTH*NUM_ITERATION);
    action =zeros(UDim,NUM_SAMPLES * NUM_LENGTH*NUM_ITERATION); 
    
   

    sub_CS = zeros(StateDim, NUM_SAMPLES, NUM_LENGTH);
    sub_NS = zeros(StateDim, NUM_SAMPLES, NUM_LENGTH);
    sub_R = zeros(1, NUM_SAMPLES, NUM_LENGTH);
    sub_A = zeros(UDim, NUM_SAMPLES, NUM_LENGTH);
    
    %sub_CS(:,:,1)= [-pi;0]* ones(1,CSt.nsamples) + [0.2;0]*rand(1,CSt.nsamples) - [0.1;0]*ones(1,CSt.nsamples);
    sub_CS(:,:,1)= [0;0;0;0;0;0;0;0;0;0] * ones(1,CSt.nsamples);
    %   The first time Running with random policy
    index_iteration = 1;
    for index_length = 1: NUM_LENGTH
        sub_A(:,:,index_length) = CSt.UTable(:,round((size(CSt.UTable,2)-1)*rand(1,CSt.nsamples))+1);
        [sub_NS(:,:,index_length), sub_R(:,:,index_length)] = nextState( sub_CS(:,:,index_length), sub_A(:,:,index_length), Target);
        if(index_length<NUM_LENGTH)
            sub_CS(:,:,index_length+1)=sub_NS(:,:,index_length);
        end
    end
    CX =reshape(sub_CS,StateDim,NUM_SAMPLES * NUM_LENGTH);
    NX=reshape(sub_NS,StateDim,NUM_SAMPLES * NUM_LENGTH);
    R=reshape(sub_R,1,NUM_SAMPLES * NUM_LENGTH);
    A=reshape(sub_A,UDim,NUM_SAMPLES * NUM_LENGTH);
    
    current_state(:,((((index_iteration-1)*NUM_SAMPLES * NUM_LENGTH)+1):((index_iteration)*NUM_SAMPLES * NUM_LENGTH))) =CX;
    next_state(:,((((index_iteration-1)*NUM_SAMPLES * NUM_LENGTH)+1):((index_iteration)*NUM_SAMPLES * NUM_LENGTH)))=NX;
    reward(:,((((index_iteration-1)*NUM_SAMPLES * NUM_LENGTH)+1):((index_iteration)*NUM_SAMPLES * NUM_LENGTH))) =R;
    action(:,((((index_iteration-1)*NUM_SAMPLES * NUM_LENGTH)+1):((index_iteration)*NUM_SAMPLES * NUM_LENGTH))) =A;
    
    Select_Kernel(CX, A);
    
    tic;
    [Weights]= DPPTDGen( current_state(:,(1:(index_iteration*NUM_SAMPLES * NUM_LENGTH))), next_state(:,(1:(index_iteration*NUM_SAMPLES * NUM_LENGTH))), action(:,(1:(index_iteration*NUM_SAMPLES * NUM_LENGTH))), reward(:,(1:(index_iteration*NUM_SAMPLES * NUM_LENGTH))), sample_iteration);    
    RCWeights{index_iteration ,index_exp}=Weights;
    CSt.Weights = Weights';
    toc;
    [error(index_exp, index_iteration)]=GetErr(Weights,CSt);
    fprintf('Experiment: %d \n', index_exp);
    fprintf('Iteration: %d \n', index_iteration);
    fprintf('Weights size: %d \n', size(Weights,1));
    fprintf('Error: %d \n', error(index_exp, index_iteration));    
    
    for index_iteration = 2:NUM_ITERATION
            %sub_CS(:,:,1)= [-pi;0]* ones(1,CSt.nsamples) + [0.2;0]*rand(1,CSt.nsamples) - [0.1;0]*ones(1,CSt.nsamples);
            sub_CS(:,:,1)= [0;0;0;0;0;0;0;0;0;0] * ones(1,CSt.nsamples);
            %   The later time Running with random policy
    
        for index_length = 1: NUM_LENGTH
            %sub_A(:,:,index_length) = CSt.UTable(:,round((size(CSt.UTable,2)-1)*rand(1,CSt.nsamples))+1);
            sub_A(:,:,index_length) =calculate_policy_no_greedy(sub_CS(:,:,index_length), CSt.Weights, CSt);
            [sub_NS(:,:,index_length), sub_R(:,:,index_length)] = nextState( sub_CS(:,:,index_length), sub_A(:,:,index_length), Target);
            if(index_length<NUM_LENGTH)
                sub_CS(:,:,index_length+1)=sub_NS(:,:,index_length);
            end
        end
        CX =reshape(sub_CS,StateDim,NUM_SAMPLES * NUM_LENGTH);
        NX=reshape(sub_NS,StateDim,NUM_SAMPLES * NUM_LENGTH);
        R=reshape(sub_R,1,NUM_SAMPLES * NUM_LENGTH);
        A=reshape(sub_A,UDim,NUM_SAMPLES * NUM_LENGTH);
    
        current_state(:,((((index_iteration-1)*NUM_SAMPLES * NUM_LENGTH)+1):((index_iteration)*NUM_SAMPLES * NUM_LENGTH))) =CX;
        next_state(:,((((index_iteration-1)*NUM_SAMPLES * NUM_LENGTH)+1):((index_iteration)*NUM_SAMPLES * NUM_LENGTH)))=NX;
        reward(:,((((index_iteration-1)*NUM_SAMPLES * NUM_LENGTH)+1):((index_iteration)*NUM_SAMPLES * NUM_LENGTH))) =R;
        action(:,((((index_iteration-1)*NUM_SAMPLES * NUM_LENGTH)+1):((index_iteration)*NUM_SAMPLES * NUM_LENGTH))) =A;
    
        Select_Kernel(CX, A);
        tic;
        [Weights]= DPPTDGen( current_state(:,(1:(index_iteration*NUM_SAMPLES * NUM_LENGTH))), next_state(:,(1:(index_iteration*NUM_SAMPLES * NUM_LENGTH))), action(:,(1:(index_iteration*NUM_SAMPLES * NUM_LENGTH))), reward(:,(1:(index_iteration*NUM_SAMPLES * NUM_LENGTH))), sample_iteration);    
        RCWeights{index_iteration ,index_exp}=Weights;
        CSt.Weights = Weights';
        toc;
        [error(index_exp, index_iteration)]=GetErr(Weights,CSt);
        if error(index_exp, index_iteration)>=-1
           break;
        end
        fprintf('Experiment: %d \n', index_exp);
        fprintf('Iteration: %d \n', index_iteration);
        fprintf('Weights size: %d \n', size(Weights,1));
        fprintf('Error: %d \n', error(index_exp, index_iteration));
    end
    Weights = [];
    RCCSt{index_exp}=CSt;
    CSt.StDim = StateDim;
    CSt.BFs = 0;
    CSt.Weights = [];
    CSt.gamma = gamma;
    CSt.eta   = eta;
    CSt.BMeanMat = [];
    CSt.UTable   = U_;
    CSt.nsamples=NUM_SAMPLES;
    CSt.length=NUM_LENGTH;
    CSt.alpha=alpha;
    CSt.WMax=5e20;
    
   
    meanErr =  mean( error(1:index_exp,:) , 1 )';
    stdErr  =   std( error(1:index_exp,:) ,[] ,1 ); 
end

save('Result');








