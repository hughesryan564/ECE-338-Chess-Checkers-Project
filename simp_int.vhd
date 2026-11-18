library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simp_int is
Port(clk, reset: in std_logic;
	 enter, lefta, righta, upa, downa: in std_logic;
	 e_a, l_a, r_a, u_a, d_a: out std_logic);
	 
end simp_int;

architecture beh of simp_int is

signal e_next, l_next, r_next, u_next, d_next: std_logic;

begin

	process(clk, reset)
	begin
		if (reset = '1') then
			e_a <= '0';
			l_a <= '0';
			r_a <= '0';
			u_a <= '0';
			d_a <= '0';
			
		elsif(rising_edge(clk)) then
			e_a <= e_next;
			l_a <= l_next;
			r_a <= r_next;
			u_a <= u_next;
			d_a <= d_next; 
			
		end if;
	end process;

	process(enter, lefta, righta, upa, downa)
	begin
			e_next <= enter;
			l_next <= lefta;
			r_next <= righta;
			u_next <= upa;
			d_next <= downa;
			
		if (enter = '1') then
			e_next <= '1';
		
		elsif (lefta = '1') then
			l_next <= '1';
			
		elsif (righta = '1') then
			r_next <= '1';
		
		elsif (upa = '1') then
			u_next <= '1';
			
		elsif (downa = '1') then
			d_next <= '1';
		
		end if;
	end process;
	

	
end beh;
