hfdv_BWG = zeros(1,size(fields_BWG,1));
hfdv_C = zeros(1,size(fields_C,1));
hfdv_G = zeros(1,size(fields_G,1));

for i = 1:size(fields_BWG,1)
kmax = find_kmax(click_proc_BWG.(fields_BWG{i}).sig, k);
hfdv_BWG(i) = hfd(click_proc_BWG.(fields_BWG{i}).sig, 1:k(find(k==kmax)));
end
for i = 1:size(fields_C,1)
kmax = find_kmax(click_proc_C.(fields_C{i}).sig, k(1:17));
hfdv_C(i) = hfd(click_proc_C.(fields_C{i}).sig, 1:k(find(k==kmax)));
end
for i = 1:size(fields_G,1)
kmax = find_kmax(click_proc_G.(fields_G{i}).sig, k(1:17));
hfdv_G(i) = hfd(click_proc_G.(fields_G{i}).sig, 1:k(find(k==kmax)));
end

std_hfdBWG = std(hfdv_BWG);
std_hfdC = std(hfdv_C);
std_hfdG = std(hfdv_G);
mean_hfdBWG = mean(hfdv_BWG);
mean_hfdC = mean(hfdv_C);
mean_hfdG = mean(hfdv_G);