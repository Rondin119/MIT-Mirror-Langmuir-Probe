clear variables

% T_e = [ones(1,2048)*80 ones(1,2048)*80  ones(1,4096)*80] ;

T_e(8192) = 0;

j = 0;
k = 1;
for i = 1:length(T_e)
  T_e(i) = j;   
if k ==1;
   j=j+1;
else
    j = j - 1;
end
   
if j == 100
   k = -1;
elseif j == 0
   k = 1; 
end
    
    
end

V_f = [ones(1,6144)*0 ones(1,2048)*0] ;
I_sat = [ones(1,4096)*-2  ones(1,4096)*-2] ; 

csvwrite('Te.coe',T_e);
csvwrite('Vf.coe',V_f);
csvwrite('Isat.coe',I_sat);







