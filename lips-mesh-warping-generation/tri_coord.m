function [ tri_coordinates ] = tri_coord( neu_mesh,num_tri,vertx,verty )
% takes neutral mesh,

tri_coordinates = cell(num_tri,3);
% each row represents the 3 coordinates of the vertices of that triangle

for row = 1:num_tri
    for col = 1:3
        vert_indices = neu_mesh(row+35,col);
        coord_x = vertx(vert_indices);
        coord_y = verty(vert_indices);
        tri_coordinates{row,col} = [coord_x,coord_y];
    end
end

end

