----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2026 12:01:29 PM
-- Design Name: 
-- Module Name: ChessBoard - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity ChessBoard is
  Port (piece, move: in std_logic_vector(5 downto 0);
        enable, clk, reset, set: in std_logic;
       -- promote: in std_logic_vector(2 downto 0);
        boardState: out std_logic_vector(255 downto 0);
        ready: out std_logic);
end ChessBoard;

architecture Behavioral of ChessBoard is
type cols is array (0 to 7) of std_logic_vector(3 downto 0);
type state is array(0 to 7) of cols;
signal coords, coordsnext: state;
signal from1, from2, to1, to2: INTEGER;
begin
    from1 <= 
            0 when piece(5 downto 3) = "000" else
            1 when piece(5 downto 3) = "001" else
            2 when piece(5 downto 3) = "010" else
            3 when piece(5 downto 3) = "011" else
            4 when piece(5 downto 3) = "100" else
            5 when piece(5 downto 3) = "101" else
            6 when piece(5 downto 3) = "110" else
            7 when piece(5 downto 3) = "111" else
            0;
     from2 <= 
            0 when piece(2 downto 0) = "000" else
            1 when piece(2 downto 0) = "001" else
            2 when piece(2 downto 0) = "010" else
            3 when piece(2 downto 0) = "011" else
            4 when piece(2 downto 0) = "100" else
            5 when piece(2 downto 0) = "101" else
            6 when piece(2 downto 0) = "110" else
            7 when piece(2 downto 0) = "111" else
            0;
     to1 <= 
            0 when move(5 downto 3) = "000" else
            1 when move(5 downto 3) = "001" else
            2 when move(5 downto 3) = "010" else
            3 when move(5 downto 3) = "011" else
            4 when move(5 downto 3) = "100" else
            5 when move(5 downto 3) = "101" else
            6 when move(5 downto 3) = "110" else
            7 when move(5 downto 3) = "111" else
            0;
     to2 <= 
            0 when move(2 downto 0) = "000" else
            1 when move(2 downto 0) = "001" else
            2 when move(2 downto 0) = "010" else
            3 when move(2 downto 0) = "011" else
            4 when move(2 downto 0) = "100" else
            5 when move(2 downto 0) = "101" else
            6 when move(2 downto 0) = "110" else
            7 when move(2 downto 0) = "111" else
            0;
  --empty "0000" if we want the board to blank on a reset than having empty as "0000" makes most sense
--white pawn "0001" feel free to change it, but this is what I thought was best/easiest
--black pawn "1001"
--white knight "0010"
--black knight "1010"
--white bishop "0011"
--black bishop "1011"
--white rook "0100"
--black rook "1100"
--white queen "0101"
--black queen "1101"
--white king "0110"
--black king "1110"
--chessboard colors from the concept art
--light: #C3C3C3 = R = "11000011", G = "11000011", B = "11000011"
--dark:  #B97A57 = R = "10111001", G = "01111010", B = "01010111"
--black  #000000 = R = "00000000", G = "00000000", B = "00000000"
--white  #FFFFFF = R = "11111111", G = "11111111", B = "11111111"


    process(clk, reset)
    begin
        if (reset = '1') then
            coords(0)(0) <= "0000";
            coords(0)(1) <= "0000";
            coords(0)(2) <= "0000";
            coords(0)(3) <= "0000";
            coords(0)(4) <= "0000";
            coords(0)(5) <= "0000";
            coords(0)(6) <= "0000";
            coords(0)(7) <= "0000";
            coords(1)(0) <= "0000";
            coords(1)(1) <= "0000";
            coords(1)(2) <= "0000";
            coords(1)(3) <= "0000";
            coords(1)(4) <= "0000";
            coords(1)(5) <= "0000";
            coords(1)(6) <= "0000";
            coords(1)(7) <= "0000";
            coords(2)(0) <= "0000";
            coords(2)(1) <= "0000";
            coords(2)(2) <= "0000";
            coords(2)(3) <= "0000";
            coords(2)(4) <= "0000";
            coords(2)(5) <= "0000";
            coords(2)(6) <= "0000";
            coords(2)(7) <= "0000";
            coords(3)(0) <= "0000";
            coords(3)(1) <= "0000";
            coords(3)(2) <= "0000";
            coords(3)(3) <= "0000";
            coords(3)(4) <= "0000";
            coords(3)(5) <= "0000";
            coords(3)(6) <= "0000";
            coords(3)(7) <= "0000";
            coords(4)(0) <= "0000";
            coords(4)(1) <= "0000";
            coords(4)(2) <= "0000";
            coords(4)(3) <= "0000";
            coords(4)(4) <= "0000";
            coords(4)(5) <= "0000";
            coords(4)(6) <= "0000";
            coords(4)(7) <= "0000";
            coords(5)(0) <= "0000";
            coords(5)(1) <= "0000";
            coords(5)(2) <= "0000";
            coords(5)(3) <= "0000";
            coords(5)(4) <= "0000";
            coords(5)(5) <= "0000";
            coords(5)(6) <= "0000";
            coords(5)(7) <= "0000";
            coords(6)(0) <= "0000";
            coords(6)(1) <= "0000";
            coords(6)(2) <= "0000";
            coords(6)(3) <= "0000";
            coords(6)(4) <= "0000";
            coords(6)(5) <= "0000";
            coords(6)(6) <= "0000";
            coords(6)(7) <= "0000";
            coords(7)(0) <= "0000";
            coords(7)(1) <= "0000";
            coords(7)(2) <= "0000";
            coords(7)(3) <= "0000";
            coords(7)(4) <= "0000";
            coords(7)(5) <= "0000";
            coords(7)(6) <= "0000";
            coords(7)(7) <= "0000";
        elsif(rising_edge(clk)) then
            coords(0)(0) <= coordsnext(0)(0);
            coords(0)(1) <= coordsnext(0)(1);
            coords(0)(2) <= coordsnext(0)(2);
            coords(0)(3) <= coordsnext(0)(3);
            coords(0)(4) <= coordsnext(0)(4);
            coords(0)(5) <= coordsnext(0)(5);
            coords(0)(6) <= coordsnext(0)(6);
            coords(0)(7) <= coordsnext(0)(7);
            coords(1)(0) <= coordsnext(1)(0);
            coords(1)(1) <= coordsnext(1)(1);
            coords(1)(2) <= coordsnext(1)(2);
            coords(1)(3) <= coordsnext(1)(3);
            coords(1)(4) <= coordsnext(1)(4);
            coords(1)(5) <= coordsnext(1)(5);
            coords(1)(6) <= coordsnext(1)(6);
            coords(1)(7) <= coordsnext(1)(7);
            coords(2)(0) <= coordsnext(2)(0);
            coords(2)(1) <= coordsnext(2)(1);
            coords(2)(2) <= coordsnext(2)(2);
            coords(2)(3) <= coordsnext(2)(3);
            coords(2)(4) <= coordsnext(2)(4);
            coords(2)(5) <= coordsnext(2)(5);
            coords(2)(6) <= coordsnext(2)(6);
            coords(2)(7) <= coordsnext(2)(7);
            coords(3)(0) <= coordsnext(3)(0);
            coords(3)(1) <= coordsnext(3)(1);
            coords(3)(2) <= coordsnext(3)(2);
            coords(3)(3) <= coordsnext(3)(3);
            coords(3)(4) <= coordsnext(3)(4);
            coords(3)(5) <= coordsnext(3)(5);
            coords(3)(6) <= coordsnext(3)(6);
            coords(3)(7) <= coordsnext(3)(7);
            coords(4)(0) <= coordsnext(4)(0);
            coords(4)(1) <= coordsnext(4)(1);
            coords(4)(2) <= coordsnext(4)(2);
            coords(4)(3) <= coordsnext(4)(3);
            coords(4)(4) <= coordsnext(4)(4);
            coords(4)(5) <= coordsnext(4)(5);
            coords(4)(6) <= coordsnext(4)(6);
            coords(4)(7) <= coordsnext(4)(7);
            coords(5)(0) <= coordsnext(5)(0);
            coords(5)(1) <= coordsnext(5)(1);
            coords(5)(2) <= coordsnext(5)(2);
            coords(5)(3) <= coordsnext(5)(3);
            coords(5)(4) <= coordsnext(5)(4);
            coords(5)(5) <= coordsnext(5)(5);
            coords(5)(6) <= coordsnext(5)(6);
            coords(5)(7) <= coordsnext(5)(7);
            coords(6)(0) <= coordsnext(6)(0);
            coords(6)(1) <= coordsnext(6)(1);
            coords(6)(2) <= coordsnext(6)(2);
            coords(6)(3) <= coordsnext(6)(3);
            coords(6)(4) <= coordsnext(6)(4);
            coords(6)(5) <= coordsnext(6)(5);
            coords(6)(6) <= coordsnext(6)(6);
            coords(6)(7) <= coordsnext(6)(7);
            coords(7)(0) <= coordsnext(7)(0);
            coords(7)(1) <= coordsnext(7)(1);
            coords(7)(2) <= coordsnext(7)(2);
            coords(7)(3) <= coordsnext(7)(3);
            coords(7)(4) <= coordsnext(7)(4);
            coords(7)(5) <= coordsnext(7)(5);
            coords(7)(6) <= coordsnext(7)(6);
            coords(7)(7) <= coordsnext(7)(7);
        end if;
    end process;

    process(set, enable) --initial board setup
    begin
        ready <= '0';
        if (set = '1') then
            coordsnext(0)(0) <= "0100";
            coordsnext(0)(1) <= "0010";
            coordsnext(0)(2) <= "0011";
            coordsnext(0)(3) <= "0101";
            coordsnext(0)(4) <= "0110";
            coordsnext(0)(5) <= "0011";
            coordsnext(0)(6) <= "0010";
            coordsnext(0)(7) <= "0100";
            coordsnext(1)(0) <= "0001";
            coordsnext(1)(1) <= "0001";
            coordsnext(1)(2) <= "0001";
            coordsnext(1)(3) <= "0001";
            coordsnext(1)(4) <= "0001";
            coordsnext(1)(5) <= "0001";
            coordsnext(1)(6) <= "0001";
            coordsnext(1)(7) <= "0001";
            coordsnext(2)(0) <= "0000";
            coordsnext(2)(1) <= "0000";
            coordsnext(2)(2) <= "0000";
            coordsnext(2)(3) <= "0000";
            coordsnext(2)(4) <= "0000";
            coordsnext(2)(5) <= "0000";
            coordsnext(2)(6) <= "0000";
            coordsnext(2)(7) <= "0000";
            coordsnext(3)(0) <= "0000";
            coordsnext(3)(1) <= "0000";
            coordsnext(3)(2) <= "0000";
            coordsnext(3)(3) <= "0000";
            coordsnext(3)(4) <= "0000";
            coordsnext(3)(5) <= "0000";
            coordsnext(3)(6) <= "0000";
            coordsnext(3)(7) <= "0000";
            coordsnext(4)(0) <= "0000";
            coordsnext(4)(1) <= "0000";
            coordsnext(4)(2) <= "0000";
            coordsnext(4)(3) <= "0000";
            coordsnext(4)(4) <= "0000";
            coordsnext(4)(5) <= "0000";
            coordsnext(4)(6) <= "0000";
            coordsnext(4)(7) <= "0000";
            coordsnext(5)(0) <= "0000";
            coordsnext(5)(1) <= "0000";
            coordsnext(5)(2) <= "0000";
            coordsnext(5)(3) <= "0000";
            coordsnext(5)(4) <= "0000";
            coordsnext(5)(5) <= "0000";
            coordsnext(5)(6) <= "0000";
            coordsnext(5)(7) <= "0000";
            coordsnext(6)(0) <= "1001";
            coordsnext(6)(1) <= "1001";
            coordsnext(6)(2) <= "1001";
            coordsnext(6)(3) <= "1001";
            coordsnext(6)(4) <= "1001";
            coordsnext(6)(5) <= "1001";
            coordsnext(6)(6) <= "1001";
            coordsnext(6)(7) <= "1001";
            coordsnext(7)(0) <= "1100";
            coordsnext(7)(1) <= "1010";
            coordsnext(7)(2) <= "1011";
            coordsnext(7)(3) <= "1101";
            coordsnext(7)(4) <= "1110";
            coordsnext(7)(5) <= "1011";
            coordsnext(7)(6) <= "1010";
            coordsnext(7)(7) <= "1100";
            ready <= '1';
        elsif (enable = '1') then -- actual piece movement
            coordsnext(to2)(to1) <= coords(from2)(from1);
            coordsnext(from2)(from1) <= "0000";
            ready <= '1';
        end if;
    end process;     
    boardstate(3 downto 0) <= coords(0)(0);
    boardstate(7 downto 4) <= coords(0)(1);
    boardstate(11 downto 8) <= coords(0)(2);
    boardstate(15 downto 12) <= coords(0)(3); 
    boardstate(19 downto 16) <= coords(0)(4);
    boardstate(23 downto 20) <= coords(0)(5);
    boardstate(27 downto 24) <= coords(0)(6);
    boardstate(31 downto 28) <= coords(0)(7);
    boardstate(35 downto 32) <= coords(1)(0);
    boardstate(39 downto 36) <= coords(1)(1);
    boardstate(43 downto 40) <= coords(1)(2);
    boardstate(47 downto 44) <= coords(1)(3);
    boardstate(51 downto 48) <= coords(1)(4);
    boardstate(55 downto 52) <= coords(1)(5);
    boardstate(59 downto 56) <= coords(1)(6);
    boardstate(63 downto 60) <= coords(1)(7);
    boardstate(67 downto 64) <= coords(2)(0);
    boardstate(71 downto 68) <= coords(2)(1);
    boardstate(75 downto 72) <= coords(2)(2);
    boardstate(79 downto 76) <= coords(2)(3);
    boardstate(83 downto 80) <= coords(2)(4);
    boardstate(87 downto 84) <= coords(2)(5);
    boardstate(91 downto 88) <= coords(2)(6);
    boardstate(95 downto 92) <= coords(2)(7);
    boardstate(99 downto 96) <= coords(3)(0);
    boardstate(103 downto 100) <= coords(3)(1);
    boardstate(107 downto 104) <= coords(3)(2);
    boardstate(111 downto 108) <= coords(3)(3);
    boardstate(115 downto 112) <= coords(3)(4);
    boardstate(119 downto 116) <= coords(3)(5);
    boardstate(123 downto 120) <= coords(3)(6);
    boardstate(127 downto 124) <= coords(3)(7);
    boardstate(131 downto 128) <= coords(4)(0);
    boardstate(135 downto 132) <= coords(4)(1);
    boardstate(139 downto 136) <= coords(4)(2);
    boardstate(143 downto 140) <= coords(4)(3);
    boardstate(147 downto 144) <= coords(4)(4);
    boardstate(151 downto 148) <= coords(4)(5);
    boardstate(155 downto 152) <= coords(4)(6);
    boardstate(159 downto 156) <= coords(4)(7);
    boardstate(163 downto 160) <= coords(5)(0);
    boardstate(167 downto 164) <= coords(5)(1);
    boardstate(171 downto 168) <= coords(5)(2);
    boardstate(175 downto 172) <= coords(5)(3);
    boardstate(179 downto 176) <= coords(5)(4);
    boardstate(183 downto 180) <= coords(5)(5);
    boardstate(187 downto 184) <= coords(5)(6);
    boardstate(191 downto 188) <= coords(5)(7);
    boardstate(195 downto 192) <= coords(6)(0);
    boardstate(199 downto 196) <= coords(6)(1);
    boardstate(203 downto 200) <= coords(6)(2);
    boardstate(207 downto 204) <= coords(6)(3);
    boardstate(211 downto 208) <= coords(6)(4);
    boardstate(215 downto 212) <= coords(6)(5);
    boardstate(219 downto 216) <= coords(6)(6);
    boardstate(223 downto 220) <= coords(6)(7);
    boardstate(227 downto 224) <= coords(7)(0);
    boardstate(231 downto 228) <= coords(7)(1);
    boardstate(235 downto 232) <= coords(7)(2);
    boardstate(239 downto 236) <= coords(7)(3);
    boardstate(243 downto 240) <= coords(7)(4);
    boardstate(247 downto 244) <= coords(7)(5);
    boardstate(251 downto 248) <= coords(7)(6);
    boardstate(255 downto 252) <= coords(7)(7);
end Behavioral;
