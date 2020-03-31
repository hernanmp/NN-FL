
clear;
cd('/Users/oscar/Desktop/community detection')
addpath('/Users/oscar/Google Drive/back up/community_detection')

n_grid = [500 750 1000 1250 1500];
NMC =  50;
K_grid =   [6];


MSE_ns =   zeros(length(K_grid),length(n_grid),NMC  );
MSE_sas =    zeros(length(K_grid),length(n_grid),NMC  );
MSE_usvt =    zeros(length(K_grid),length(n_grid),NMC  );


average_MSE_ns  = zeros(length(K_grid),length(n_grid));
average_MSE_sas =  zeros(length(K_grid),length(n_grid)  );
average_MSE_usvt =  zeros(length(K_grid),length(n_grid));



for ind_K = 1:length(K_grid),
      K =  K_grid(ind_K);
      display('K')
      K
      
       for ind_n = 1:length(n_grid),
            n =  n_grid(ind_n);
            display('n')
             n
             
             for iter = 1:NMC,
                    file_A = ['/Users/oscar/Desktop/community detection/simulations/A_ind4n' num2str(n) 'K' num2str(K) 'iter' num2str(iter) '.txt'];     
                    file_P = ['/Users/oscar/Desktop/community detection/simulations/P_ind4n' num2str(n) 'K' num2str(K) 'iter' num2str(iter) '.txt'];     
                     
                    display('iter')
                    
                    
                    A =  dlmread(file_A);   
                    P  =  dlmread(file_P);
                    
                    %%% NS
                    [W_hat] = NeighborhoodSmoothing(A);       
                     W_hat(eye(n)==1) =0;
                     MSE_ns(ind_K,ind_n,iter) =  mean((mean((P- W_hat).^2)));
%                     
%                      %%%  SAS
%                      [west, pos]= sort_and_smooth(A);
%                      pos_inv = 1:n;
%                      pos_inv(pos) = 1:n;
%                      west =  west(pos_inv,pos_inv);
%        
%                      
%                      west(eye(n)==1) =0;
%                      MSE_sas(ind_K,ind_n,iter) =  mean((mean((P- west).^2)));
%                      
                     %%
                     [wusvt, pos]= usvt(A);
                     pos_inv = 1:n;
                     pos_inv(pos) = 1:n;
                     wusvt =  wusvt(pos_inv,pos_inv);
                     wusvt(eye(n)==1) =0;
                     
                     
                     MSE_usvt(ind_K,ind_n,iter) =  mean((mean((P- wusvt).^2)));
                     
             end
             
             average_MSE_ns(ind_K,ind_n)  =  mean(MSE_ns(ind_K,ind_n,:));
             average_MSE_sas(ind_K,ind_n)  =  mean(MSE_sas(ind_K,ind_n,:));
             average_MSE_usvt(ind_K,ind_n)  =  mean(MSE_usvt(ind_K,ind_n,:));             
             %%%%%%%%%%%%%%
             display('ns')
             average_MSE_ns(ind_K,ind_n)
             display('sas')
             average_MSE_sas(ind_K,ind_n)
             display('usvt')
             average_MSE_usvt(ind_K,ind_n)
             
       end
end

dlmwrite('ex4_average_MSE_ns.txt',average_MSE_ns);
dlmwrite('ex4_average_MSE_sas.txt',average_MSE_sas);
dlmwrite('ex4_average_MSE_usvt.txt',average_MSE_usvt);


dlmwrite('ex4_MSE_ns.txt',MSE_ns);
dlmwrite('ex4_MSE_sas.txt',MSE_sas);
dlmwrite('ex4_MSE_usvt.txt',MSE_usvt);