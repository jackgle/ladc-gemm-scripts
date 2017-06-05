function [ struct_out ] = get_matches( struct, max_corrs, thresh )

if ~exist('thresh', 'var')
    thresh = 0.8;
end

% fields = fieldnames(struct);
match_ix = find(max_corrs>thresh);
for i = 1: length(match_ix)
    struct_out(i)=struct(match_ix(i));
end
end

