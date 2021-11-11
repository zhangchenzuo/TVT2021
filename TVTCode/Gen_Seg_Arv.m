% The function generates the segment arrival time from the request arrival time
% arvTime: request arrival time
% segNum: number of fragments requested
% segLen: Length of each fragment
% nMS: indicates the number of users who initiated the request
function segArvTime = Gen_Seg_Arv(arvTime,segNum,segLen,nMS)
segArvTime = kron(arvTime,ones(segNum,1));
tempmat = 0:segLen:segLen*(segNum-1);
tempmat1 = kron(tempmat.',ones(1,nMS));
segArvTime = segArvTime + tempmat1;
segArvTime = reshape(segArvTime,[1,numel(segArvTime)]);