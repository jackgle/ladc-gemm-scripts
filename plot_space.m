function [] = plot_space( mat_C, idx, outliers, norm, cent)

clf;
hold on

if exist('outliers','var') && strcmp(outliers,'outliers')
    od = 1;
else
    od=[];
end

if exist('norm','var') && strcmp(norm, 'norm')
    mat_c_norm = normalizeData(mat_C')';
else
    mat_c_norm = mat_C;
end

if ~exist('idx','var')
    idx = ones(size(mat_C,1),1);
end

k=length(unique(idx));
c = cool(k);

shg

if size(mat_C,2)>2
    if isempty(od)
        for i = 1:k
            scatter3(mat_c_norm(idx==i,1), mat_c_norm(idx==i,2), mat_c_norm(idx==i,3),'MarkerEdgeColor',c(i,:));
        end
    else
        for i = 1:k-1
            scatter3(mat_c_norm(idx==i,1), mat_c_norm(idx==i,2), mat_c_norm(idx==i,3),'MarkerEdgeColor',c(i,:));
        end
        for i = k
            scatter3(mat_c_norm(idx==i,1), mat_c_norm(idx==i,2), mat_c_norm(idx==i,3),'kx');
        end
    end
else
    if isempty(od)
        for i = 1:k
            scatter(mat_c_norm(idx==i,1), mat_c_norm(idx==i,2),'MarkerEdgeColor',c(i,:));
        end
    else
        for i = 1:k-1
            scatter(mat_c_norm(idx==i,1), mat_c_norm(idx==i,2),'MarkerEdgeColor',c(i,:));
        end
        for i = k
            scatter(mat_c_norm(idx==i,1), mat_c_norm(idx==i,2),20,'kx');
        end
    end
end

grid on

if nargin == 5
    hold on
    if size(mat_C,2)>2
        scatter3(cent(:,1),cent(:,2),cent(:,3),'r*');
    else
        scatter(cent(:,1),cent(:,2),'r*');
    end
    hold off
end
    

end

   