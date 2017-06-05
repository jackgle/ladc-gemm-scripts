function [ S ] = s_concat( cell_array )

% merges structures into one
k=1;
for i = 1:length(cell_array)
   sName = evalin('base', cell_array{i});
   setGlobalx(sName);
%    fields = fieldnames(sName);
   for j = 1:length(sName)
%        field = strcat('c',num2str(k));
       S(k) = sName(j);
       k=k+1;
   end
end


end

function setGlobalx(val)
global x
x = val;
end
