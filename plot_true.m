function [] = plot_true( mat_C, idx_true)

clf;
hold on

k = max(idx_true);
c = cool(k);

if size(mat_C,2)>2
    for i = 1:k
        scatter3(mat_C(idx_true==i,1), mat_C(idx_true==i,2), mat_C(idx_true==i,3),'MarkerEdgeColor',c(i,:));
    end
else

    for i = 1:k
        scatter(mat_C(idx_true==i,1), mat_C(idx_true==i,2),'MarkerEdgeColor',c(i,:));
    end
end

grid on
    

end