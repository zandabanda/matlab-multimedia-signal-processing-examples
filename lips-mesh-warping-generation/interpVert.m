%function to generate mesh vertices changes according lip width and height
%input parameters
%			inVertX: x coordinates of neutral mesh vertices
%			inVertY: y coordinates of neutral mesh vertices
%			neutral_w: w value (width) or neutral lips 
%			neutral_h1: h1 value or neutral lips 
%			neutral_h2: h2 value or neutral lips 
%			w:			new value of w;
%			h1:		new value of h1;
%			h2:		new value of h2;
%			fScale:	control the scale of the deformation, should be adjusted so that 
%						the displacements of lip vertices are reasonable. (For example, don't 
%						go outside of the boundary of the mesh.)
%output parameters
%			retVertX: x of deformed mesh vertices
%			retVertY: y of deformed mesh vertices

function [retVertX, retVertY] = interpVert(inVertX, inVertY, neutral_w, neutral_h1, neutral_h2, w, h1, h2, fScale)

retVertX = inVertX;
retVertY = inVertY;
% upper mid
retVertY(4) = inVertY(4) - (h1 - neutral_h1)*fScale;
% inner upper mid
retVertY(26) = inVertY(26) - (h1 - neutral_h1)*fScale;
% inner lower mid
retVertY(31) = inVertY(31) + (h2 - neutral_h2)*fScale;
% left
retVertX(1) = inVertX(1) - (w - neutral_w)/2*fScale;
% right
retVertX(7) = inVertX(7) + (w - neutral_w)/2*fScale;

% interpolate lower mid
lowmid(1) = (inVertX(9) + inVertX(10))/2;
lowmid(2) = (inVertY(9) + inVertY(10))/2;
retlowmid = lowmid;
retlowmid(2) = retlowmid(2) + (h2 - neutral_h2)*fScale;


idx = [2 3 24 25];
for ii = 1:4
   retVertX(idx(ii)) = retVertX(idx(ii)) + (retVertX(1)-inVertX(1))*(inVertX(idx(ii))-inVertX(1))/(inVertX(4)-inVertX(1));
   %   retVertY(idx(ii)) = retVertY(idx(ii)) + (retVertY(4)-inVertY(4))*(inVertY(1)-inVertY(idx(ii)))/(inVertY(1)-inVertY(4));
   retVertY(idx(ii)) = retVertY(idx(ii)) + (retVertY(4)-inVertY(4))*(inVertX(idx(ii))-inVertX(1))/(inVertX(4)-inVertX(1));
end

idx = [5 6 27 28];
for ii = 1:4
   retVertX(idx(ii)) = retVertX(idx(ii)) + (retVertX(7)-inVertX(7))*(inVertX(idx(ii))-inVertX(7))/(inVertX(4)-inVertX(7));
   %   retVertY(idx(ii)) = retVertY(idx(ii)) + (retVertY(4)-inVertY(4))*(inVertY(7)-inVertY(idx(ii)))/(inVertY(7)-inVertY(4));
   retVertY(idx(ii)) = retVertY(idx(ii)) + (retVertY(4)-inVertY(4))*(inVertX(idx(ii))-inVertX(7))/(inVertX(4)-inVertX(7));
end

idx = [8 9 29 30];
for ii = 1:4
   retVertX(idx(ii)) = retVertX(idx(ii)) + (retVertX(1)-inVertX(1))*(inVertX(idx(ii))-inVertX(1))/(lowmid(1)-inVertX(1));
   %   retVertY(idx(ii)) = retVertY(idx(ii)) + (retlowmid(2)-lowmid(2))*(inVertY(1)-inVertY(idx(ii)))/(inVertY(1)-lowmid(2));
   retVertY(idx(ii)) = retVertY(idx(ii)) + (retlowmid(2)-lowmid(2))*(inVertX(idx(ii))-inVertX(1))/(lowmid(1)-inVertX(1));
end

idx = [10 11 32 33];
for ii = 1:4
   retVertX(idx(ii)) = retVertX(idx(ii)) + (retVertX(7)-inVertX(7))*(inVertX(idx(ii))-inVertX(7))/(lowmid(1)-inVertX(7));
   %   retVertY(idx(ii)) = retVertY(idx(ii)) + (retlowmid(2)-lowmid(2))*(inVertY(7)-inVertY(idx(ii)))/(inVertY(7)-lowmid(2));
   retVertY(idx(ii)) = retVertY(idx(ii)) + (retlowmid(2)-lowmid(2))*(inVertX(idx(ii))-inVertX(7))/(lowmid(1)-inVertX(7));
end

if (h1 - neutral_h1 < 0)
   idx = [24 25 26 27 28];
   for ii = 1:5;
      %retVertX(idx(ii)) = inVertX(idx(ii));
      retVertY(idx(ii)) = inVertY(idx(ii));      
   end   
end

if (h2 - neutral_h2 < 0)
   idx = [29 30 31 32 33];
   for ii = 1:5;
      retVertX(idx(ii)) = inVertX(idx(ii));
      retVertY(idx(ii)) = inVertY(idx(ii));      
   end   
end
