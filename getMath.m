% ---------------------------------------- MATH ----------------------------------------

% return the mathematics submodule
function math = getMath
    math.vdist = @vdist;
end

% return the Euclidean distance (distance between two vectors)
function d = vdist(u,v)
   s = u-v;
   d = sqrt(s*s');
end
