library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cursor is
  Port (--boardstate: in std_logic_vector(255 downto 0);		-- unsure if we need the boardstate as an input to this file, as all the file will output
        clk, reset: in std_logic;							-- is the to and from addresses, the ready if we want it, and the address of the current
		enter: in std_logic;								-- cusor square, it won't do any bit operations on the boardstate nor needs it to know 
		left_arrow: in std_logic;							-- where the player is if we're starting at 0,0 every time
		right_arrow: in std_logic;
		up_arrow: in std_logic;
		down_arrow: in std_logic;
		cur_ready: out std_logic;
		pto, pfrom: out std_logic_vector(5 downto 0);
		cur_sq: out std_logic_vector(5 downto 0));
end cursor;

architecture beh of cursor is

signal piece_selected, piece_selected_next, player_turn, player_turn_next: std_logic;    			-- 1 bit data that a piece is currently selected, and 1 bit data for which player's turn it is
signal square_over, square_over_next: std_logic_vector(5 downto 0);			-- 6 bit data for the square player is on, first 3 bits for the row, last three for the column
signal row_pd, row_pd_next, row_pu, row_pu_next, col_pd, col_pd_next, col_pu, col_pu_next: std_logic_vector(2 downto 0);	-- 3 bit data for the row/col player is picking up (pu) from or placing down (pd) on.
signal next1, next2, next5, next6: integer;
signal next3, next4: std_logic_vector(2 downto 0);
begin
-- detect and store data on piece selected

    with square_over(5 downto 3) select
        next1 <= 0 when "000",
                 1 when "001",
                 2 when "010",
                 3 when "011",
                 4 when "100",
                 5 when "101",
                 6 when "110",
                 7 when "111",
                 0 when others;
    with square_over(2 downto 0) select
        next2 <= 0 when "000",
                 1 when "001",
                 2 when "010",
                 3 when "011",
                 4 when "100",
                 5 when "101",
                 6 when "110",
                 7 when "111",
                 0 when others;
                 
   with next5 select
        next3 <= "000" when 0,
                 "001" when 1,
                 "010" when 2,
                 "011" when 3,
                 "100" when 4,
                 "101" when 5,
                 "110" when 6,
                 "111" when 7,
                 "000" when others;
   with next6 select
        next4 <= "000" when 0,
                 "001" when 1,
                 "010" when 2,
                 "011" when 3,
                 "100" when 4,
                 "101" when 5,
                 "110" when 6,
                 "111" when 7,
                 "000" when others;
    
	process(clk, reset)
	begin
		if (reset = '1') then
			square_over <= "000000";
			col_pu <= "000";
			col_pd <= "000";
			row_pu <= "000";
			row_pd <= "000";
			piece_selected <= '0';
			cur_ready <= '0';
			player_turn <= '0';
		elsif (rising_edge(clk)) then
			square_over <= square_over_next;
			row_pu <= row_pu_next;
			row_pd <= row_pd_next;
			col_pu <= col_pu_next;
			col_pd <= col_pd_next;
			piece_selected <= piece_selected_next;
			player_turn <= player_turn_next;
			ready_1 <= ready_1_next;
			ready_2 <= ready_2_next;
		end if;
	end process;
	
	process(enter, left_arrow, right_arrow, up_arrow, down_arrow)
	begin
		square_over_next <= "000000";											--unsure if these are necessary here, or if they'll do anything unwanted to the program
		col_pu_next <= "000";
		col_pd_next <= "000";
		row_pu_next <= "000";
		row_pd_next <= "000";
		piece_selected_next <= '0';
		cur_ready <= '0';
		ready_1 <= '0';
		ready_2 <= '0';
		
		if (enter = '1') then
			if piece_selected <= '0' then									--if we're picking up a piece
				col_pu_next <= square_over(2 downto 0);
				row_pu_next <= square_over(5 downto 3);
				piece_selected_next <= '1';
				ready_1_next <= '1';
			else															
				if player_turn = '1'	then										--switch player turn when placing piece
					player_turn_next <= '0';
				else
					player_turn_next <= '1';
				end if;
				piece_selected <= '0';										--placing down
				col_pd_next <= square_over(2 downto 0);
				row_pd_next <= square_over(5 downto 3);
				ready_2_next <= '1';
			end if;

	-- detect movement (change value of square_over) based on key presses
		elsif (left_arrow = '1') then
			if (square_over(2 downto 0) = "000") then  						--detect if we're on the zeroth column so that we dont move off the board
				square_over_next(2 downto 0) <= "000";
			else 
			    next6 <= next2;
			    next5 <= next1 - 1;
				square_over_next(5 downto 3) <= next3;		--think of the array structure for why its + instead of - here
				square_over_next(2 downto 0) <= next4;
			end if;
			
		elsif (right_arrow = '1') then
			if (square_over(2 downto 0) = "111") then   					--detect if we're on the seventh column so that we dont move off the board
				square_over_next(2 downto 0) <= "111";
			else
			    next6 <= next2;
			    next5 <= next1 + 1;
				square_over_next(5 downto 3) <= next3;		--think of the array structure for why its + instead of - here
				square_over_next(2 downto 0) <= next4;
			end if;
			
		elsif (up_arrow = '1') then
			if (square_over(5 downto 3) <= "000") then   					--detect if we're on the zero (top) row so that we dont move off the board
				square_over_next(5 downto 3) <= "000";
			else
			    next6 <= next2 + 1;
			    next5 <= next1;
				square_over_next(5 downto 3) <= next3;		--think of the array structure for why its + instead of - here
				square_over_next(2 downto 0) <= next4;
			end if;
			
			
		elsif (down_arrow = '1') then
			if (square_over(5 downto 3) <= "111") then   					--detect if we're on the seven (bottom) row so that we dont move off the board
				square_over_next(5 downto 3) <= "111";
			else
			    next6 <= next2 - 1;
			    next5 <= next1;
				square_over_next(5 downto 3) <= next3;		--think of the array structure for why its + instead of - here
				square_over_next(2 downto 0) <= next4;
				
			end if;
			
		end if;
	end process;

	cur_ready <= ready_1 and ready_2;
	cur_sq <= square_over;
	pfrom <= row_pu & col_pu;
	pto <= row_pd & col_pd;												--i dont know if we want to use a ready for this or if it's properly implemented
																		--but it's here if we want it
end beh;
