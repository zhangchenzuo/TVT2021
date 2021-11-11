function output = segselect(segNum, alloMS, resiSegs)
output = [];
for i = 1 : length(alloMS)
    output = [output segNum*alloMS(i) - resiSegs(alloMS(i)) + 1: segNum*alloMS(i)];
end