function [x_vector y_vector z_vector] = findbasis3(x_vector)
% function basis = findbasis3(vector)
% findbasis3 finds two vectors that form an orthonormal basis together with
% the input x-vector.
% Ryan George 2009
% COMO 401

y_vector = [1 0 0]';  %transform an arbitrary vector into one perpendicular
y_vector = y_vector - sum(y_vector.*x_vector)*x_vector; %to the x_vector

if norm(y_vector) == 0  % in case the target coords are in the line of [1 0 0]'
    y_vector = [0 1 0]';
    y_vector = y_vector - (y_vector.*x_vector)*x_vector;
end
y_vector = y_vector/norm(y_vector); 
      
z_vector = cross(y_vector, x_vector); %third vector is the cross-product
                                      %of the first and second