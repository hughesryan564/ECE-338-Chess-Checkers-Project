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
signal btn_prev, btn_now: std_logic_vector(4 downto 0); --2 new signals to compare the current
                                                        --state of inputs to the previous one
begin

	process(clk, reset)
	begin
		if (reset = '1') then
			e_a <= '0';
			l_a <= '0';
			r_a <= '0';
			u_a <= '0';
			d_a <= '0';
			btn_prev <= "00000";
			btn_now <= "00000";
			
		elsif(rising_edge(clk)) then
		    btn_now <= enter & lefta & righta & upa & downa;  --make things look cleaner and 
		    btn_prev <= btn_now;                              --condensed  
			e_a <= e_next;
			l_a <= l_next;
			r_a <= r_next;
			u_a <= u_next;
			d_a <= d_next; 
			
		end if;
	end process;

	process(enter, lefta, righta, upa, downa, btn_now, btn_prev)
	begin
			e_next <= '0';       --reinitialize the next state to 0 so we only get one pulse
			l_next <= '0';       --when the button is humanly held for longer than 8-16ns
			r_next <= '0';
			u_next <= '0';
			d_next <= '0';
			
		if (btn_now(4) = '1' and btn_prev(4) = '0') then  --i.e. rising edge of input when the
			e_next <= '1';                                --button is held that state resets
		                                                  --back to 0
		elsif (btn_now(3) = '1' and btn_prev(3) = '0') then
			l_next <= '1';
			
		elsif (btn_now(2) = '1' and btn_prev(2) = '0') then
			r_next <= '1';
			
		elsif (btn_now(1) = '1' and btn_prev(1) = '0') then
			u_next <= '1';
			
		elsif (btn_now(0) = '1' and btn_prev(0) = '0') then
			d_next <= '1';
		
		end if;
	end process;
end beh;
