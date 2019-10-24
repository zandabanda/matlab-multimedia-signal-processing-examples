function [output_imgs] = warping(test_Visuals, retVertX, retVertY, neu_mouth, neu_mesh, neu_tri_vert, neu_tri_coord, num_tri)

% visuals are the 456 generated test visual features [h,w1,w2]
% neu_tri_vert is a matrix identifying the vertices (v1,v2,v3) associated each
    % triangle (rows)
% neu_tri_coord is a cell specifying the the neutral coordinates ((x1,y1),(x2,y2),(x3,y3) of every
    % vertex associated with every triangle
% neu_mouth is the neutral mouth image to be deformed, (79x130) = 10270
    % pixels

size_mouth = size(neu_mouth);
fScale = 1;

num_frames = length(test_Visuals);
output_imgs = cell(num_frames,1);


        for frame = 1:num_frames % loop over all visual frames
            output_img = zeros(size_mouth(1),size_mouth(2));
            % interpolate visual features into mesh
            [new_vertx,new_verty] = interpVert(retVertX, retVertY, 0, 0, 0, test_Visuals(1,frame), test_Visuals(2,frame), test_Visuals(3,frame), fScale);
            [new_tri_coord] = tri_coord(neu_mesh,num_tri,new_vertx,new_verty);
            
            for triangle = 1:length(neu_tri_vert)
                % determine lambda for each triangle
                T = [[neu_tri_coord{triangle,1}, 1]',[neu_tri_coord{triangle,2}, 1]',[neu_tri_coord{triangle,3}, 1]'];
                %T_inv = pinv(T); % pseudo inverse
                
                
                for row = 1:size_mouth(1)
                    for col = 1:size_mouth(2) % loop over image pixels 
                        x = [row; col; 1]; % image vector
                
                        lamb = T\x;
                        if (min(lamb) >= 0 && max(lamb) <= 1)
                            % if the point lies within the triangle in Barycentric
                            % Coordinates, apply transformation to pixel.
                            x_new = [new_tri_coord{triangle,1}',new_tri_coord{triangle,2}',new_tri_coord{triangle,3}']*lamb;

                            % Nearest Neighbor
                            x_new_NN = [floor(x_new(1)+.5),floor(x_new(2)+.5)];
                    
                            % Bilinear Interpolation
                
                            %output_img(x_new_NN(1),x_new_NN(2)) = neu_mouth(row,col);
                            output_img(row,col) = neu_mouth(x_new_NN(1),x_new_NN(2));
                        else
                            % leave pixel black?
                            %output_img(row,col) = 0;
                            
                            % or not
                            %output_img(row,col) = neu_mouth(row,col);
                   
                        end
                    end
                end
            end
            
            %interp2(X,Y,f,P,Q,'linear',0);
            output_imgs{frame,1} = output_img;
            
        end
        
end

    
   
    






