function [output_img] = warping_sing(frame, test_Visuals, retVertX, retVertY, neu_mouth, neu_mesh, neu_tri_coord, num_tri)

% visuals are the 456 generated test visual features [h,w1,w2]
% neu_tri_vert is a matrix identifying the vertices (v1,v2,v3) associated each
    % triangle (rows)
% neu_tri_coord is a cell specifying the the neutral coordinates ((x1,y1),(x2,y2),(x3,y3) of every
    % vertex associated with every triangle
% neu_mouth is the neutral mouth image to be deformed, (79x130) = 10270
    % pixels

size_mouth = size(neu_mouth);
fScale = 1;

            output_img = uint8(zeros(size_mouth(1),size_mouth(2)));
            %output_img = uint8(zeros(200,200));
            % interpolate visual features into mesh
            [new_vertx,new_verty] = interpVert(retVertX, retVertY, 0, 0, 0, test_Visuals(1,frame), test_Visuals(2,frame), test_Visuals(3,frame), fScale);
            [new_tri_coord] = tri_coord(neu_mesh,num_tri,new_vertx,new_verty);
    
    for row = 1:size_mouth(1)
        for col = 1:size_mouth(2) % loop over image pixels            
            
            count = 0;
            for triangle = 1:num_tri
                % determine lambda for each triangle

                        %T = [[neu_tri_coord{triangle,1},
                        %1]',[neu_tri_coord{triangle,2}, 1]',[neu_tri_coord{triangle,3}, 1]'];
                        x = [row; col; 1]; % image position vector
                        lamb = [[neu_tri_coord{triangle,1}, 1]',[neu_tri_coord{triangle,2}, 1]',[neu_tri_coord{triangle,3}, 1]']\x; % Barycentric coordiantes for every triange - point pair
                        x_new = [new_tri_coord{triangle,1}',new_tri_coord{triangle,2}',new_tri_coord{triangle,3}']*lamb;

                        % Nearest Neighbor
                        x_new_NN = [floor(x_new(1)+.5),floor(x_new(2)+.5)];
                        
                        if (min(lamb) >= 0 && max(lamb) <= 1)
                            % if the point lies within the triangle in Barycentric
                            % Coordinates, apply transformation to pixel.
                            %x_new = [new_tri_coord{triangle,1}',new_tri_coord{triangle,2}',new_tri_coord{triangle,3}']*lamb;

                            % Nearest Neighbor
                            %x_new_NN = [floor(x_new(1)+.5),floor(x_new(2)+.5)];
                    
                            % Bilinear Interpolation
                            %x1 = floor(x_new);
                            %x2 = ceil(x_new);
                            %p1 = neu_mouth(x1(1),x1(2))*(x1(2) - x_new(1))*(x2(2) - x_new(2));
                            %p2 = neu_mouth(x2(1),x1(2))*(x_new(1) - x1(1))*(x2(2) - x_new(2));
                            %p3 = neu_mouth(x1(1),x2(1))*(x2(1) - x_new(1))*(x_new(2) - x1(2));
                            %p4 = neu_mouth(x2(1),x2(2))*(x_new(1) - x1(1))*(x_new(2) - x1(2));
                            %f = (1/((x2(1) - x1(1))*(x2(2) - x1(2))))*(p1 + p2 + p3 + p4);
                
                            %output_img(x_new_NN(1),x_new_NN(2)) = f;
                            %output_img(row,col) = neu_mouth(x_new_NN(1),x_new_NN(2));
                            output_img(x_new_NN(1),x_new_NN(2)) = neu_mouth(row,col);
                        elseif (min(lamb) < 0 || max(lamb) > 1 || x_new(1) < 0 || x_new(2) < 0)
                            count = count +1;
                            %x_new = [new_tri_coord{triangle,1}',new_tri_coord{triangle,2}',new_tri_coord{triangle,3}']*lamb;
                            %x_new_NN = [floor(x_new(1)+.5),floor(x_new(2)+.5)];
                            % leave pixel black?
                            %output_img(x_new_NN(1),x_new_NN(2)) = 0;
                            %output_img(row,col) = 0;
                        elseif ((min(lamb) < 0 || max(lamb) > 1) && (x_new(1) > 0 && x_new(2) > 0))
                            output_img(x_new_NN(1),x_new_NN(2)) = 0;
                        end
            end
            if (count == 42)
            %output_img(row,col) = 0;
            end
        end
    end
            
        
end
