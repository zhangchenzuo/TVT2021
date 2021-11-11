function output = repmatself(a)
output = [];
for i = 1:length(a)
    output = [output ones(1, a(i))*i];
end
