----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Professor Jim Plusquellic
-- 
-- Create Date:
-- Design Name: 
-- Module Name:    Top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

-- ===================================================================================================
-- ===================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

library work;
use work.DataTypes_pkg.all;

entity Top is
   port (
      Clk: in std_logic;
      GPIO_Ins: in std_logic_vector(31 downto 0);
      GPIO_Outs: out std_logic_vector(31 downto 0);
      PNL_BRAM_addr: out std_logic_vector (12 downto 0);
      PNL_BRAM_din: out std_logic_vector (15 downto 0);
      PNL_BRAM_dout: in std_logic_vector (15 downto 0);
      PNL_BRAM_we: out std_logic_vector (0 to 0);
      hdmi_red : out STD_LOGIC_VECTOR ( 7 downto 0 );
      hdmi_green : out STD_LOGIC_VECTOR ( 7 downto 0 );
      hdmi_blue : out STD_LOGIC_VECTOR ( 7 downto 0 );
      hdmi_hsync : out STD_LOGIC;
      hdmi_vsync : out STD_LOGIC;
      hdmi_enable : out STD_LOGIC;
      btn: in std_logic_vector(3 downto 0);
      switches: in std_logic_vector(1 downto 0);
      promote: in std_logic_vector(1 downto 0);
      lights: out std_logic_vector(3 downto 0)
  --    DEBUG_IN: in std_logic;
   --   DEBUG_OUT: out std_logic
      );
end Top;

architecture beh of Top is

-- GPIO INPUT BIT ASSIGNMENTS
   constant IN_CP_RESET: integer := 31;
   constant IN_CP_START: integer := 30;
   constant IN_CP_LM_ULM_LOAD_UNLOAD: integer := 26;
   constant IN_CP_LM_ULM_DONE: integer := 25;
   constant IN_CP_HANDSHAKE: integer := 24;

-- GPIO OUTPUT BIT ASSIGNMENTS
   constant OUT_SM_READY: integer := 31;
   constant OUT_SM_HANDSHAKE: integer := 28;

-- Signal declarations
   signal RESET_final: std_logic;

   signal pixel_x: unsigned(10 downto 0);
   signal pixel_y: unsigned(9 downto 0);
   signal pixel_x_std: std_logic_vector(9 downto 0);
   signal pixel_y_std: std_logic_vector(9 downto 0);

   signal LM_ULM_start, LM_ULM_ready: std_logic;
   signal LM_ULM_stopped, LM_ULM_continue: std_logic;
   signal LM_ULM_done: std_logic;
   signal LM_ULM_base_address: std_logic_vector(PNL_BRAM_ADDR_SIZE_NB-1 downto 0);
   signal LM_ULM_upper_limit: std_logic_vector(PNL_BRAM_ADDR_SIZE_NB-1 downto 0);
   signal LM_ULM_load_unload: std_logic;

   signal DataIn: std_logic_vector(WORD_SIZE_NB-1 downto 0);
   signal DataOut: std_logic_vector(WORD_SIZE_NB-1 downto 0);

   signal graph_rgb: std_logic_vector(23 downto 0);
   signal hdmi_enable_out: STD_LOGIC;
   
   signal boardState: std_logic_vector(255 downto 0);
   signal selector, squareFrom, squareTo: std_logic_vector(5 downto 0);
   signal pushEngine, Update: std_logic;
   signal up, down, left, right, enter: std_logic;
   signal reset, set, clear: std_logic;

    component ChessBoard
        Port (piece, move: in std_logic_vector(5 downto 0);
        enable, clk, reset, set: in std_logic;
        promote: in std_logic_vector(1 downto 0);
        boardState: out std_logic_vector(255 downto 0);
        ready: out std_logic);
    end component;
    
    component pong_graph_st
        port(
      clk, reset: in std_logic;
      --btn: in std_logic_vector(1 downto 0);
      video_on: in std_logic;
      pixel_x, pixel_y: in std_logic_vector(9 downto 0);
      graph_rgb: out std_logic_vector(23 downto 0);
      boardState: in std_logic_vector(255 downto 0);
      square: in std_logic_vector(5 downto 0));
    end component;
    
--    component simp_int
--        Port(clk, reset: in std_logic;
--	       enter, lefta, righta, upa, downa: in std_logic;
--	       e_a, l_a, r_a, u_a, d_a: out std_logic);
--	end component;
	
    component cursor
        Port (--boardstate: in std_logic_vector(255 downto 0);		-- unsure if we need the boardstate as an input to this file, as all the file will output
          clk, reset: in std_logic;								-- is the to and from addresses, the ready if we want it, and the address of the current
		  enter: in std_logic;									-- cusor square, it won't do any bit operations on the boardstate nor needs it to know 
    	  left_arrow: in std_logic;								-- where the player is if we're starting at 0,0 every time
	   	  right_arrow: in std_logic;
		  up_arrow: in std_logic;
		  down_arrow: in std_logic;
		  cur_ready: out std_logic;
		  pto, pfrom: out std_logic_vector(5 downto 0);
		  cur_sq: out std_logic_vector(5 downto 0));
    end component;
-- =======================================================================================================
   begin

-- Light up LED if LoadUnLoadMemMod is ready for a command
--   DEBUG_OUT <= LM_ULM_ready;

-- =====================
-- INPUT control and status signals
-- Software (C code) plus hardware global reset
   RESET_final <= GPIO_Ins(IN_CP_RESET) or reset;

-- Start signal from C program. 
   LM_ULM_start <= GPIO_Ins(IN_CP_START);

-- C program controls whether we are loading or unloading memory
   LM_ULM_load_unload <= GPIO_Ins(IN_CP_LM_ULM_LOAD_UNLOAD);

-- C program asserts if done reading or writing memory (or a portion of it)
   LM_ULM_done <= GPIO_Ins(IN_CP_LM_ULM_DONE);

-- Handshake signal
   LM_ULM_continue <= GPIO_Ins(IN_CP_HANDSHAKE);

-- Data from C program
   DataIn <= GPIO_Ins(WORD_SIZE_NB-1 downto 0);

-- =====================
-- OUTPUT control and status signals
-- Tell C program whether LoadUnLoadMemMod is ready 
   GPIO_Outs(OUT_SM_READY) <= LM_ULM_ready; 

-- Handshake signals
   GPIO_Outs(OUT_SM_HANDSHAKE) <= LM_ULM_stopped; 

-- Data to C program
   GPIO_Outs(WORD_SIZE_NB-1 downto 0) <= DataOut;

-- =====================
-- Setup memory base and upper_limit
   LM_ULM_base_address <= std_logic_vector(to_unsigned(PN_BRAM_BASE, PNL_BRAM_ADDR_SIZE_NB));
   LM_ULM_upper_limit <= std_logic_vector(to_unsigned(PNL_BRAM_NUM_WORDS_NB -1, PNL_BRAM_ADDR_SIZE_NB));

-- Secure BRAM access control module
   LoadUnLoadMemMod: entity work.LoadUnLoadMem(beh)
      port map(Clk=>Clk, RESET=>RESET, start=>LM_ULM_start, ready=>LM_ULM_ready, load_unload=>LM_ULM_load_unload, stopped=>LM_ULM_stopped, 
         continue=>LM_ULM_continue, done=>LM_ULM_done, base_address=>LM_ULM_base_address, upper_limit=>LM_ULM_upper_limit, 
         CP_in_word=>DataIn, CP_out_word=>DataOut, 
         PNL_BRAM_addr=>PNL_BRAM_addr, PNL_BRAM_din=>PNL_BRAM_din, PNL_BRAM_dout=>PNL_BRAM_dout, PNL_BRAM_we=>PNL_BRAM_we);


    hdmi_sync_i: entity work.hdmi_sync(rtl)
       port map (clk=>Clk, reset=>reset, hdmi_hsync=>hdmi_hsync, hdmi_vsync=>hdmi_vsync, hdmi_enable=>hdmi_enable_out, pixel_x=>pixel_x, pixel_y=>pixel_y);

   pixel_x_std <= std_logic_vector(pixel_x(9 downto 0));
   pixel_y_std <= std_logic_vector(pixel_y);
     pong_i: pong_graph_st port map (clk=>Clk, reset=>reset, boardstate => boardstate, square => selector, video_on=>hdmi_enable_out, pixel_x=>pixel_x_std, pixel_y=>pixel_y_std, graph_rgb=>graph_rgb);
    
     engine: ChessBoard port map (clk => clk, reset => reset, set => set, enable => pushEngine, piece => squareFrom, move => squareTo, promote => promote, boardState => boardState, ready => Update);
        
    process(switches(0))
    begin
        if switches(0) = '1' then
            up <= btn(0);
            down <= btn(1);
            left <= btn(2);
            right <= btn(3);
            reset <= '0';
            enter <= '0';
            set <= '0';
            clear <= '0';
        elsif switches(0) = '1' then
            up <= '0';
            down <= '0';
            left <= '0';
            right <= '0';
            reset <= btn(0);
            enter <= btn(1);
            set <= btn(2);
            clear <= btn(3);
        else
            up <= '0';
            down <= '0';
            left <= '0';
            right <= '0';
            reset <= '0';
            enter <= '0';
            set <= '0';
            clear <= '0';
        end if;
    end process;
    
    location: cursor port map(clk => clk, reset => reset, enter => enter, left_arrow => left, right_arrow => right, up_arrow => up, down_arrow => down, cur_ready => pushEngine, pto => squareTo, pfrom => squareFrom, cur_sq => selector);
    lights(3) <= switches(1);
    process(switches(1))
    begin
        if switches(1) <= '0' then
            lights(2 downto 0) <= selector(2 downto 0);
        elsif switches(1) <= '1' then
            lights(2 downto 0) <= selector(5 downto 3);
        else
            lights(2 downto 0) <= "000";
        end if;
    end process;
--    hdmi_red <= std_logic_vector(resize(pixel_x, 8)) when sw_r = '1' else (others => '0');
--    hdmi_green <= std_logic_vector(resize(pixel_y, 8)) when sw_g = '1' else (others => '0');
   hdmi_red <= graph_rgb(23 downto 16);
   hdmi_green <= graph_rgb(15 downto 8);
   hdmi_blue <= graph_rgb(7 downto 0);

   hdmi_enable <= hdmi_enable_out;

end beh;

