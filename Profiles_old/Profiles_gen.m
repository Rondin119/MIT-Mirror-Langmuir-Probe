

T_e = [ones(1,2048)*60 ones(1,6144)*100] ;
V_f = [ones(1,6144)*0 ones(1,2048)*-10] ;
I_sat = [ones(1,4096)*-2  ones(1,4096)*-1] ; 

csvwrite('Te.coe',T_e);
csvwrite('Vf.coe',V_f);
csvwrite('Isat.coe',I_sat);







