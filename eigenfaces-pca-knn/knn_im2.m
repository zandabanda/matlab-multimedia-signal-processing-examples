function [acc_tot,acc_A,acc_B,acc_C,acc_D] = knn_im2(P,k_flag)

sze = size(P);
Pi = zeros(4,20,sze(1)); % create 3D arrays for logical indexing of data

for i=1:4 % Person, A=1, B=2, C=3, D=4
    for j=1:20 % Instance, 1=1, 2=2, and so on ... index maps directly to digit
          Pi(i,j,:) = P(:,(i-1)*20 + j);
    end
end

correct = zeros(80,1);
% perform 79 comparisons for each of the 80 images

if (k_flag == 5)
    
        for i=1:4 
        for j=1:20 

            y_tmp = zeros(80,1); 
            dist_tmp = zeros(80,1); 

                    for y=1:4 
                        for u=1:20 
                                    y_tmp((y-1)*20 + u,1) = y; % equal row indexes of dist and ind correspond to the SAME signal 
                                    dist_tmp((y-1)*20 + u,1) = sum((Pi(i,j,:)-Pi(y,u,:)).^2); % populate with distances
                        end
                    end
            
            yi = y_tmp(y_tmp ~= 0); 
            dist = dist_tmp(dist_tmp ~= 0); % remove the self-comparison

            [M1,I1] = min(dist); % find index of smallest distance and replace that value with a large value
            dist = dist(dist~=M1);
            [M2,I2] = min(dist);
            dist = dist(dist~=M2);
            [M3,I3] = min(dist);
            dist = dist(dist~=M3);
            [M4,I4] = min(dist);
            dist = dist(dist~=M4);
            [M5,I5] = min(dist);
            dist = dist(dist~=M5);
            
            n = zeros(5,1); % store the digits chosen 
            n(1,1) = yi(I1,1); % the yi's take values between 1 and 4
            n(2,1) = yi(I2,1);
            n(3,1) = yi(I3,1);
            n(4,1) = yi(I4,1);
            n(5,1) = yi(I5,1);
            
            num_faces = zeros(4,1); % vector of counts, where the index is the digit being counted
            
            for q = 1:5 % establish a count for digit 1-5 seen
                num_faces(n(q,1),1) = num_faces(n(q,1),1) + 1;
            end
            
            unique_faces = unique(num_faces);
            countOf_faces = hist(num_faces,unique_faces);
            indexToRepeatedValue = (countOf_faces ~= 1);
            repeatedValues = unique_faces(indexToRepeatedValue);
            [max_repeatedValues,ind_max_repeatedValues] = max(repeatedValues);

            while(countOf_faces(ind_max_repeatedValues) ~= 0)
                % add neighbor and replace min
                [Mn,In] = min(dist);
                dist = dist(dist~=Mn);
                
                % update the count
                num_faces(yi(In,1),1) = num_faces(yi(In,1),1) + 1;
                
                %redefine num_faces, unique, count, index, ...
                unique_faces = unique(num_faces);
                countOf_faces = hist(num_faces,unique_faces);
                indexToRepeatedValue = (countOf_faces ~= 1);
                repeatedValues = unique_faces(indexToRepeatedValue);
                [max_repeatedValues,ind_max_repeatedValues] = max(repeatedValues);
            end
            
            [M,I] = max(num_faces); % the index with the highest count IS what is recognized
                                     % DOES NOT HANDLE TIES
            
            if (i==I)
                correct((i-1)*20 + j) = 1;
            elseif (i~=I)
                correct((i-1)*20 + j) = 0;    
            end
            
        end
        end
        
    acc_tot = sum(correct)/length(correct);
    acc_A = (sum(correct(1:20)))/20;
    acc_B = (sum(correct(21:40)))/20;
    acc_C = (sum(correct(41:60)))/20;
    acc_D = (sum(correct(61:80)))/20;

  
elseif (k_flag == 1)

        for i=1:4 
        for j=1:20 
             
            y_tmp = zeros(80,1); 
            dist_tmp = zeros(80,1); 

                    for y=1:4 
                        for u=1:20 
                                y_tmp((y-1)*20 + u,1) = u; % equal row indexes of dist and ind correspond to the SAME signal 
                                dist_tmp((y-1)*20 + u,1) = sum((Pi(i,j,:)-Pi(y,u,:)).^2); % populate with distances
                        end
                        
                    end
            
            yi = y_tmp(y_tmp ~= 0); 
            dist = dist_tmp(dist_tmp ~= 0); 

            [M,I] = min(dist); 

            if (i == yi(I,1))
                correct((i-1)*20 + j) = 1;
            elseif (i ~= yi(I,1))
                correct((i-1)*20 + j) = 0;    
            end
           
        end
        end
        
    acc_tot = sum(correct)/length(correct);
    acc_A = (sum(correct(1:20)))/20;
    acc_B = (sum(correct(21:40)))/20;
    acc_C = (sum(correct(41:60)))/20;
    acc_D = (sum(correct(61:80)))/20;

end

end